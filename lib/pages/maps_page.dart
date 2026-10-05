import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsPage extends StatefulWidget {
  final bool pilihLokasi;

  const MapsPage({super.key, this.pilihLokasi = false});

  @override
  State<MapsPage> createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  GoogleMapController? _mapController;

  // Koordinat default kantor / titik acuan presensi (Bisa disesuaikan)
  static const LatLng _titikKantor = LatLng(
    -6.200000,
    106.816666,
  ); // Contoh: Jakarta
  static const double _radiusKantorMeter = 100.0; // Radius absensi 100 meter

  LatLng? _lokasiPengguna;
  String _alamatTeks = 'Mengambil alamat...';
  double? _jarakKeKantor;
  bool _diDalamRadius = false;

  bool _memuatLokasi = true;
  String? _pesanError;
  MapType _tipePetaSaatIni = MapType.normal;

  @override
  void initState() {
    super.initState();
    _dapatkanLokasiSaatIni();
  }

  Future<void> _dapatkanLokasiSaatIni() async {
    setState(() {
      _memuatLokasi = true;
      _pesanError = null;
    });

    try {
      // 1. Periksa apakah GPS aktif
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _memuatLokasi = false;
          _pesanError = 'Layanan lokasi (GPS) tidak aktif. Mohon aktifkan GPS perangkat Anda.';
        });
        return;
      }

      // 2. Periksa dan minta izin lokasi
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _memuatLokasi = false;
            _pesanError = 'Izin lokasi ditolak oleh pengguna.';
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _memuatLokasi = false;
          _pesanError = 'Izin lokasi ditolak permanen. Buka pengaturan aplikasi untuk mengizinkan.';
        });
        return;
      }

      // 3. Dapatkan posisi saat ini
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 15),
        ),
      );

      final userLatLng = LatLng(position.latitude, position.longitude);

      // 4. Hitung jarak ke kantor
      final jarak = Geolocator.distanceBetween(
        userLatLng.latitude,
        userLatLng.longitude,
        _titikKantor.latitude,
        _titikKantor.longitude,
      );

      // 5. Dapatkan alamat via Reverse Geocoding
      String alamat = 'Alamat tidak ditemukan';
      try {
        final geocoding = Geocoding();
        List<Placemark> placemarks = await geocoding.placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );
        if (placemarks.isNotEmpty) {
          final p = placemarks.first;
          final parts = [
            if (p.street != null && p.street!.isNotEmpty) p.street,
            if (p.subLocality != null && p.subLocality!.isNotEmpty)
              p.subLocality,
            if (p.locality != null && p.locality!.isNotEmpty) p.locality,
            if (p.administrativeArea != null &&
                p.administrativeArea!.isNotEmpty)
              p.administrativeArea,
          ];
          alamat = parts.isNotEmpty
              ? parts.join(', ')
              : 'Koordinat: ${userLatLng.latitude}, ${userLatLng.longitude}';
        }
      } catch (e) {
        alamat =
            'Lat: ${userLatLng.latitude.toStringAsFixed(5)}, Lng: ${userLatLng.longitude.toStringAsFixed(5)}';
      }

      if (mounted) {
        setState(() {
          _lokasiPengguna = userLatLng;
          _jarakKeKantor = jarak;
          _diDalamRadius = jarak <= _radiusKantorMeter;
          _alamatTeks = alamat;
          _memuatLokasi = false;
        });

        _pindahkanKamera(userLatLng);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _memuatLokasi = false;
          _pesanError = 'Gagal mendeteksi lokasi: $e';
        });
      }
    }
  }

  void _pindahkanKamera(LatLng posisi) {
    if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: posisi, zoom: 17.0),
        ),
      );
    }
  }

  void _gantiTipePeta() {
    setState(() {
      if (_tipePetaSaatIni == MapType.normal) {
        _tipePetaSaatIni = MapType.satellite;
      } else if (_tipePetaSaatIni == MapType.satellite) {
        _tipePetaSaatIni = MapType.terrain;
      } else {
        _tipePetaSaatIni = MapType.normal;
      }
    });
  }

  Set<Marker> _buatMarkers() {
    final markers = <Marker>{};

    // Marker Titik Kantor / Titik Absen
    markers.add(
      Marker(
        markerId: const MarkerId('kantor'),
        position: _titikKantor,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        infoWindow: const InfoWindow(
          title: 'Titik Kantor Presensi',
          snippet: 'Area radius presensi yang ditentukan',
        ),
      ),
    );

    // Marker Pengguna
    if (_lokasiPengguna != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('posisi_saya'),
          position: _lokasiPengguna!,
          icon: BitmapDescriptor.defaultMarkerWithHue(
            _diDalamRadius
                ? BitmapDescriptor.hueGreen
                : BitmapDescriptor.hueRed,
          ),
          infoWindow: InfoWindow(
            title: 'Posisi Anda Saat Ini',
            snippet: _alamatTeks,
          ),
        ),
      );
    }

    return markers;
  }

  Set<Circle> _buatCircles() {
    return {
      Circle(
        circleId: const CircleId('radius_kantor'),
        center: _titikKantor,
        radius: _radiusKantorMeter,
        strokeWidth: 2,
        strokeColor: Colors.blueAccent.withValues(alpha: 0.8),
        fillColor: Colors.blueAccent.withValues(alpha: 0.15),
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final cameraTarget = _lokasiPengguna ?? _titikKantor;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lokasi & Peta Presensi',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0.5,
        actions: [
          IconButton(
            icon: const Icon(Icons.layers_outlined),
            tooltip: 'Ganti Tipe Peta',
            onPressed: _gantiTipePeta,
          ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Segarkan Lokasi',
            onPressed: _dapatkanLokasiSaatIni,
          ),
        ],
      ),
      body: Stack(
        children: [
          // Widget Google Maps
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: cameraTarget,
              zoom: 15.5,
            ),
            mapType: _tipePetaSaatIni,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            compassEnabled: true,
            markers: _buatMarkers(),
            circles: _buatCircles(),
            onMapCreated: (controller) {
              _mapController = controller;
              if (_lokasiPengguna != null) {
                _pindahkanKamera(_lokasiPengguna!);
              }
            },
          ),

          // Tombol Aksi Cepat Mengambang
          Positioned(
            right: 16,
            bottom: 230,
            child: Column(
              children: [
                FloatingActionButton.small(
                  heroTag: 'fab_my_location',
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blueAccent,
                  onPressed: () {
                    if (_lokasiPengguna != null) {
                      _pindahkanKamera(_lokasiPengguna!);
                    } else {
                      _dapatkanLokasiSaatIni();
                    }
                  },
                  tooltip: 'Pusatkan ke Lokasi Saya',
                  child: const Icon(Icons.my_location),
                ),
                const SizedBox(height: 10),
                FloatingActionButton.small(
                  heroTag: 'fab_office_location',
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.teal,
                  onPressed: () {
                    _pindahkanKamera(_titikKantor);
                  },
                  tooltip: 'Pusatkan ke Kantor',
                  child: const Icon(Icons.business_rounded),
                ),
              ],
            ),
          ),

          // Banner Loading / Error jika ada
          if (_memuatLokasi)
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2.5),
                      ),
                      SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          'Mendeteksi titik koordinat GPS...',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          if (_pesanError != null)
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Card(
                color: Colors.red.shade50,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.warning_amber_rounded,
                        color: Colors.redAccent,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _pesanError!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.redAccent,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.refresh,
                          size: 20,
                          color: Colors.redAccent,
                        ),
                        onPressed: _dapatkanLokasiSaatIni,
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Panel Info Lokasi & Presensi di Bawah Layar
          Positioned(
            left: 16,
            right: 16,
            bottom: 20,
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Status Radius
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _diDalamRadius
                                ? Colors.green.withValues(alpha: 0.15)
                                : Colors.red.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _diDalamRadius
                                    ? Icons.check_circle
                                    : Icons.cancel,
                                size: 16,
                                color: _diDalamRadius
                                    ? Colors.green
                                    : Colors.red,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                _diDalamRadius
                                    ? 'Dalam Radius Presensi'
                                    : 'Di Luar Radius',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: _diDalamRadius
                                      ? Colors.green.shade800
                                      : Colors.red.shade800,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        if (_jarakKeKantor != null)
                          Text(
                            'Jarak: ${_jarakKeKantor!.toStringAsFixed(0)} m',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.black54,
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Detail Alamat
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.location_on_rounded,
                          color: Colors.blueAccent,
                          size: 22,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Lokasi Anda Saat Ini',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.black45,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _alamatTeks,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Tombol Konfirmasi / Selesai
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _lokasiPengguna == null
                            ? null
                            : () {
                                Navigator.pop(context, {
                                  'latitude': _lokasiPengguna!.latitude,
                                  'longitude': _lokasiPengguna!.longitude,
                                  'alamat': _alamatTeks,
                                  'jarak': _jarakKeKantor,
                                  'diDalamRadius': _diDalamRadius,
                                });
                              },
                        icon: const Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                        ),
                        label: Text(
                          widget.pilihLokasi
                              ? 'Gunakan Lokasi Ini'
                              : 'Konfirmasi Lokasi Presensi',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
