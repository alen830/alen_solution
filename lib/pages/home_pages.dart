import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Import file halaman sesuai struktur folder Anda:
import 'daftar_hadir_pages.dart';
import 'register_pages.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Variabel penampung nilai waktu absen
  String _jamMasuk = '--:--';
  String _jamKeluar = '--:--';

  // Fungsi untuk mencatat jam masuk
  void _absenMasuk() {
    setState(() {
      _jamMasuk = DateFormat('HH:mm').format(DateTime.now());
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Absen masuk berhasil dicatat: $_jamMasuk'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Fungsi untuk mencatat jam keluar
  void _absenKeluar() {
    setState(() {
      _jamKeluar = DateFormat('HH:mm').format(DateTime.now());
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Absen keluar berhasil dicatat: $_jamKeluar'),
        backgroundColor: Colors.redAccent,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FA),
      appBar: AppBar(
        title: const Text(
          'Dashboard Absensi',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          children: [
            // Row Jam Masuk & Jam Keluar Card
            Row(
              children: [
                Expanded(
                  child: _buildTimeCard(
                    title: 'Jam Masuk',
                    time: _jamMasuk, // Menggunakan state _jamMasuk
                    icon: Icons.login_rounded,
                    iconColor: Colors.green,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTimeCard(
                    title: 'Jam Keluar',
                    time: _jamKeluar, // Menggunakan state _jamKeluar
                    icon: Icons.logout_rounded,
                    iconColor: Colors.redAccent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Tombol Aksi Absen
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _absenMasuk,
                    icon: const Icon(Icons.check_circle_outline, size: 20),
                    label: const Text(
                      'ABSEN MASUK',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _absenKeluar,
                    icon: const Icon(Icons.cancel_outlined, size: 20),
                    label: const Text(
                      'ABSEN KELUAR',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade600,
                      foregroundColor: Colors.white,
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
            const SizedBox(height: 32),

            // Divider Pemisah
            const Divider(color: Colors.black12, thickness: 1),
            const SizedBox(height: 16),

            // Tombol Navigasi: Daftar Akun Baru (Register)
            OutlinedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterPage()),
                );
              },
              icon: const Icon(Icons.person_add_alt_1_rounded, size: 20),
              label: const Text(
                'Daftar Akun Baru (Register)',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.blueAccent,
                minimumSize: const Size(double.infinity, 50),
                side: const BorderSide(color: Colors.blueAccent, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Tombol Navigasi: Daftar Hadir
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DaftarHadirPage(),
                  ),
                );
              },
              icon: const Icon(Icons.assignment_outlined, size: 20),
              label: const Text(
                'Lihat Daftar Hadir',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.blueGrey.shade800,
                minimumSize: const Size(double.infinity, 50),
                elevation: 1,
                side: BorderSide(color: Colors.grey.shade300),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget Pembantu Card Jam
  Widget _buildTimeCard({
    required String title,
    required String time,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 26),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            time,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
