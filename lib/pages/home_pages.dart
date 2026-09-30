import 'package:alen_solution/model/presensi_model.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'daftar_hadir_page.dart';
import 'login_pages.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String checkInTime = "--:--";
  String checkOutTime = "--:--";
  String lastStatus = "Belum Presensi";
  String currentLocation = "Lokasi belum dicatat";
  bool isLoading = false;

  // Fungsi pengambil koordinat GPS dengan proteksi timeout & fallback
  Future<Position?> _determinePosition() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showSnackbar("Layanan lokasi (GPS) nonaktif. Harap aktifkan GPS.");
        return null;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showSnackbar("Izin akses lokasi ditolak oleh pengguna.");
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showSnackbar(
          "Izin lokasi ditolak permanen. Buka pengaturan aplikasi.",
        );
        return null;
      }

      // Coba ambil posisi aktif dengan batas waktu 7 detik
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 7),
        ),
      );
    } catch (e) {
      // Jika timeout di emulator, ambil posisi terakhir yang terekam
      try {
        Position? lastKnown = await Geolocator.getLastKnownPosition();
        if (lastKnown != null) {
          return lastKnown;
        }
      } catch (_) {}

      // Fallback koordinat demo jika emulator tidak mengirim sinyal GPS sama sekali
      _showSnackbar(
        "GPS lambat merespons, menggunakan titik koordinat dummy emulator.",
      );
      return Position(
        latitude: -6.2088,
        longitude: 106.8456,
        timestamp: DateTime.now(),
        accuracy: 10.0,
        altitude: 0.0,
        altitudeAccuracy: 0.0,
        heading: 0.0,
        headingAccuracy: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0,
      );
    }
  }

  // Modal dialog pemilihan status dan input keterangan
  Future<void> _showPresensiDialog() async {
    String selectedType = "Hadir Masuk";
    final notesController = TextEditingController();

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                left: 20,
                right: 20,
                top: 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Input Presensi",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedType,
                    decoration: InputDecoration(
                      labelText: "Jenis Kehadiran",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: "Hadir Masuk",
                        child: Text("Hadir (Masuk)"),
                      ),
                      DropdownMenuItem(
                        value: "Hadir Pulang",
                        child: Text("Hadir (Pulang)"),
                      ),
                      DropdownMenuItem(value: "Izin", child: Text("Izin")),
                      DropdownMenuItem(value: "Sakit", child: Text("Sakit")),
                      DropdownMenuItem(
                        value: "Tugas Luar",
                        child: Text("Tugas Luar"),
                      ),
                    ],
                    onChanged: (val) {
                      setModalState(() {
                        selectedType = val!;
                      });
                    },
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: notesController,
                    decoration: InputDecoration(
                      labelText: "Keterangan Tambahan (Opsional)",
                      hintText: "Contoh: Hadir di kantor / WFH",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4F6EF7),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        _submitPresensi(selectedType, notesController.text);
                      },
                      child: const Text(
                        "Konfirmasi & Catat Lokasi",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Eksekusi pencatatan presensi
  Future<void> _submitPresensi(String type, String note) async {
    setState(() => isLoading = true);

    try {
      Position? pos = await _determinePosition();
      final now = DateTime.now();
      final formattedTime =
          "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

      if (pos != null) {
        setState(() {
          currentLocation =
              "${pos.latitude.toStringAsFixed(5)}, ${pos.longitude.toStringAsFixed(5)}";
          lastStatus = type + (note.trim().isNotEmpty ? " ($note)" : "");

          if (type == "Hadir Masuk") {
            checkInTime = formattedTime;
          } else if (type == "Hadir Pulang") {
            checkOutTime = formattedTime;
          }
        });
        _showSnackbar("Berhasil mencatat $type ($formattedTime)");
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  void _showSnackbar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF4F6EF7),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Selamat Datang 👋",
              style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
            ),
            Text(
              "ABSEN PPKD",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Color(0xFFEF4444)),
            tooltip: 'Logout',
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kartu Ringkasan Status & Waktu Presensi
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4F6EF7), Color(0xFF6C8CFF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x334F6EF7),
                    blurRadius: 15,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    "Status: $lastStatus",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildTimeCard(
                        title: "Masuk",
                        time: checkInTime,
                        icon: Icons.login_rounded,
                      ),
                      Container(width: 1, height: 45, color: Colors.white24),
                      _buildTimeCard(
                        title: "Keluar",
                        time: checkOutTime,
                        icon: Icons.logout_rounded,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.pin_drop,
                          size: 14,
                          color: Colors.white70,
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            currentLocation,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Tombol Utama Catat Presensi
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: isLoading ? null : _showPresensiDialog,
                icon: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(
                        Icons.fingerprint_rounded,
                        size: 26,
                        color: Colors.white,
                      ),
                label: Text(
                  isLoading ? "Mengambil Lokasi..." : "Pilih & Catat Kehadiran",
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4F6EF7),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Menu Cepat
            const Text(
              "Menu Cepat",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 14),

            Row(
              children: [
                Expanded(
                  child: _buildMenuCard(
                    title: "Daftar Hadir",
                    subtitle: "Riwayat presensi",
                    icon: Icons.calendar_month_rounded,
                    color: const Color(0xFF0EA5E9),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DaftarHadirPage(),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _buildMenuCard(
                    title: "Lokasi Kantor",
                    subtitle: "Cek radius GPS",
                    icon: Icons.location_on_rounded,
                    color: const Color(0xFF10B981),
                    onTap: () async {
                      final pos = await _determinePosition();
                      if (pos != null) {
                        _showSnackbar(
                          "Koordinat: ${pos.latitude}, ${pos.longitude}",
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeCard({
    required String title,
    required String time,
    required IconData icon,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.white70, size: 16),
            const SizedBox(width: 6),
            Text(
              title,
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          time,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Color(0x08000000),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 14),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
            ),
          ],
        ),
      ),
    );
  }
}
