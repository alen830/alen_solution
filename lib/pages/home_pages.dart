import 'dart:async';

import 'package:alen_solution/service/simpan_token.dart';
import 'package:flutter/material.dart';

import 'daftar_hadir_page.dart';
import 'login_pages.dart';
import 'register_pages.dart';

class HomePage extends StatefulWidget {
  final String namaPengguna;

  const HomePage({super.key, this.namaPengguna = 'Pengguna'});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<PresensiItem> _daftarPresensi = [];

  String _jamSekarang = '';
  String _tanggalSekarang = '';
  String? _jamMasuk;
  String? _jamKeluar;
  String _statusHariIni = 'Belum Absen';
  late Timer _timer;
  String _namaTampil = 'Pengguna';

  @override
  void initState() {
    _namaTampil = widget.namaPengguna;
    _muatNamaTersimpan();
    super.initState();
    _updateWaktu();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateWaktu();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> _muatNamaTersimpan() async {
    if (_namaTampil == 'Pengguna') {
      final savedNama = await SimpanToken.getNama();
      if (savedNama != null && savedNama.isNotEmpty && mounted) {
        setState(() {
          _namaTampil = savedNama;
        });
      }
    }
  }

  void _updateWaktu() {
    final now = DateTime.now();
    final jamFormatted =
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";

    const namaBulan = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    final tanggalFormatted =
        "${now.day} ${namaBulan[now.month - 1]} ${now.year}";

    if (mounted) {
      setState(() {
        _jamSekarang = jamFormatted;
        _tanggalSekarang = tanggalFormatted;
      });
    }
  }

  void _simpanAbsensi(String status, Color color) {
    final now = DateTime.now();
    final timeStr =
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

    setState(() {
      _jamMasuk = timeStr;
      _statusHariIni = status;

      _daftarPresensi.insert(
        0,
        PresensiItem(
          nama: widget.namaPengguna,
          tanggal: _tanggalSekarang,
          jam: '$timeStr WIB',
          status: status,
        ),
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Presensi dicatat: $status pada $timeStr WIB'),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _absenKeluar() {
    final now = DateTime.now();
    final timeStr =
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

    setState(() {
      _jamKeluar = timeStr;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Berhasil Absen Keluar pada jam $timeStr WIB'),
        backgroundColor: Colors.orange.shade800,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _tampilkanDialogKeterangan(String jenis) {
    final TextEditingController alasanController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Pengajuan $jenis'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Masukkan catatan atau alasan $jenis Anda:',
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: alasanController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Tulis keterangan...',
                filled: true,
                fillColor: Colors.grey.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
            },
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              final alasan = alasanController.text.trim();
              final now = DateTime.now();
              final timeStr =
                  "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

              Navigator.pop(ctx);

              setState(() {
                _statusHariIni = jenis;

                final namaDisplay = alasan.isNotEmpty
                    ? '${widget.namaPengguna} ($alasan)'
                    : widget.namaPengguna;

                _daftarPresensi.insert(
                  0,
                  PresensiItem(
                    nama: namaDisplay,
                    tanggal: _tanggalSekarang,
                    jam: '$timeStr WIB',
                    status: jenis,
                  ),
                );
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    alasan.isNotEmpty
                        ? 'Keterangan $jenis ($alasan) berhasil dikirim!'
                        : 'Keterangan $jenis berhasil dikirim!',
                  ),
                  backgroundColor: Colors.blueAccent,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
            child: const Text('Kirim', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _bukaDaftarHadir() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DaftarHadirPage(riwayatAwal: _daftarPresensi),
      ),
    );
  }

  void _konfirmasiLogout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Konfirmasi Keluar'),
        content: const Text('Apakah Anda yakin ingin keluar dari akun ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false,
              );
            },
            child: const Text('Keluar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildKeteranganItem({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: color.withOpacity(0.2),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.blueGrey.shade800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: const Text(
          'Beranda Absensi',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        actions: [
          IconButton(
            icon: const Icon(Icons.history_rounded, color: Colors.blueAccent),
            tooltip: 'Riwayat Kehadiran',
            onPressed: _bukaDaftarHadir,
          ),
          IconButton(
            icon: const Icon(
              Icons.person_add_alt_1_outlined,
              color: Colors.teal,
            ),
            tooltip: 'Halaman Register',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RegisterPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
            tooltip: 'Keluar Akun',
            onPressed: _konfirmasiLogout,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Card Profil Pengguna
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.blueAccent.withValues(alpha: 0.15),
                    child: const Icon(
                      Icons.person,
                      size: 32,
                      color: Colors.blueAccent,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Halo, $_namaTampil!',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Text(
                              'Status: ',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                _statusHariIni,
                                style: const TextStyle(
                                  color: Colors.blueAccent,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Card Jam & Waktu Live
            Container(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2193b0), Color(0xFF6dd5ed)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    _tanggalSekarang,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _jamSekarang.isEmpty ? '--:--:--' : _jamSekarang,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Waktu Indonesia Barat (WIB)',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Status Jam Masuk & Keluar
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.login_rounded,
                              color: Colors.green,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Jam Masuk',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _jamMasuk ?? '--:--',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.logout_rounded,
                              color: Colors.orange,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Jam Keluar',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _jamKeluar ?? '--:--',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Pilihan Keterangan Presensi
            const Text(
              'Keterangan & Pengajuan',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildKeteranganItem(
                    icon: Icons.check_circle_outline,
                    label: 'Hadir',
                    color: Colors.teal,
                    onTap: () => _simpanAbsensi('Hadir', Colors.teal),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildKeteranganItem(
                    icon: Icons.alarm_on_rounded,
                    label: 'Terlambat',
                    color: Colors.amber.shade800,
                    onTap: () => _tampilkanDialogKeterangan('Terlambat'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildKeteranganItem(
                    icon: Icons.assignment_outlined,
                    label: 'Izin',
                    color: Colors.blueAccent,
                    onTap: () => _tampilkanDialogKeterangan('Izin'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildKeteranganItem(
                    icon: Icons.healing_rounded,
                    label: 'Sakit',
                    color: Colors.redAccent,
                    onTap: () => _tampilkanDialogKeterangan('Sakit'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Tombol Utama Aksi Absen Masuk & Keluar
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _simpanAbsensi('Hadir', Colors.green),
                    icon: const Icon(Icons.fingerprint, color: Colors.white),
                    label: const Text(
                      'Absen Masuk',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _absenKeluar,
                    icon: const Icon(Icons.exit_to_app, color: Colors.white),
                    label: const Text(
                      'Absen Keluar',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange.shade700,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Navigasi ke Riwayat
            OutlinedButton.icon(
              onPressed: _bukaDaftarHadir,
              icon: const Icon(
                Icons.receipt_long_rounded,
                color: Colors.blueAccent,
              ),
              label: const Text(
                'Lihat Daftar & Riwayat Hadir',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.blueAccent,
                ),
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                side: const BorderSide(color: Colors.blueAccent, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 14),

            // Navigasi ke Login & Buat Akun
            Row(
              children: [
                Expanded(
                  child: TextButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.login, size: 18),
                    label: const Text('Ke Login'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.blueGrey.shade700,
                    ),
                  ),
                ),
                Container(height: 16, width: 1, color: Colors.grey.shade300),
                Expanded(
                  child: TextButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterPage(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.person_add_alt_outlined, size: 18),
                    label: const Text('Buat Akun'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.blueGrey.shade700,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
