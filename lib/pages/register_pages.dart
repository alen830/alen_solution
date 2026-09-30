import 'package:flutter/material.dart';
import 'package:alen_solution/model/presensi_model.dart';

import 'login_pages.dart'; // Sesuaikan lokasi file LoginPage jika berbeda

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Fungsi untuk mencatat kehadiran otomatis
  void _simpanDataKehadiran(String namaUser) {
    final sekarang = DateTime.now();

    // Format daftar nama hari dan bulan dalam bahasa Indonesia
    const daftarHari = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu',
    ];
    const daftarBulan = [
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

    final namaHari = daftarHari[sekarang.weekday - 1];
    final namaBulan = daftarBulan[sekarang.month - 1];
    final tanggalLengkap =
        '$namaHari, ${sekarang.day} $namaBulan ${sekarang.year}';

    // Batas tepat waktu misal jam 08:00
    final statusWaktu =
        (sekarang.hour < 8 || (sekarang.hour == 8 && sekarang.minute == 0))
        ? 'Tepat Waktu'
        : 'Lewat';

    final dataBaru = Presensi(
      nama: namaUser,
      tanggal: tanggalLengkap,
      jamMasuk:
          '${sekarang.hour.toString().padLeft(2, '0')}:${sekarang.minute.toString().padLeft(2, '0')}',
      jamKeluar: '-',
      lokasi: 'Pejabat Pusat (GPS Sah)',
      status: statusWaktu,
    );

    // Simpan ke list data presensi
    PresensiRepository.tambahPresensi(dataBaru);
  }

  void _handleRegister() {
    if (_formKey.currentState!.validate()) {
      // 1. Simpan data presensi otomatis menggunakan nama yang didaftarkan
      _simpanDataKehadiran(_nameController.text.trim());

      // 2. Berikan notifikasi sukses
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pendaftaran berhasil & Kehadiran tercatat otomatis!'),
          backgroundColor: Colors.green,
        ),
      );

      // 3. Arahkan pengguna ke halaman Login atau Home
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon Header
                  Container(
                    width: 70,
                    height: 70,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE8EEFD),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person_add_alt_1_rounded,
                      size: 36,
                      color: Color(0xFF4F6EF7),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Judul & Subjudul
                  const Text(
                    'Buat Akun Baru',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Lengkapi form di bawah untuk mendaftar',
                    style: TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                  ),
                  const SizedBox(height: 32),

                  // Input Nama Lengkap
                  _buildTextField(
                    controller: _nameController,
                    hintText: 'Nama Lengkap',
                    icon: Icons.person_outline_rounded,
                    validator: (val) => val == null || val.trim().isEmpty
                        ? 'Nama tidak boleh kosong'
                        : null,
                  ),
                  const SizedBox(height: 16),

                  // Input Email
                  _buildTextField(
                    controller: _emailController,
                    hintText: 'Email',
                    icon: Icons.mail_outline_rounded,
                    keyboardType: TextInputType.emailAddress,
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Email tidak boleh kosong';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(val.trim())) {
                        return 'Format email tidak valid';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Input Password
                  _buildTextField(
                    controller: _passwordController,
                    hintText: 'Password',
                    icon: Icons.lock_outline_rounded,
                    isPassword: true,
                    obscureText: _obscurePassword,
                    onTogglePassword: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                    validator: (val) => (val != null && val.length < 6)
                        ? 'Password minimal 6 karakter'
                        : null,
                  ),
                  const SizedBox(height: 24),

                  // Tombol Daftar
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _handleRegister,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4F6EF7),
                        elevation: 4,
                        shadowColor: const Color(0x664F6EF7),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Daftar Sekarang',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 36),

                  // Link ke Login Page
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Sudah punya akun? ',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                          );
                        },
                        child: const Text(
                          'Masuk',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4F6EF7),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onTogglePassword,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(14)),
        boxShadow: [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: const Color(0xFF94A3B8), size: 20),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    obscureText
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: const Color(0xFF94A3B8),
                    size: 20,
                  ),
                  onPressed: onTogglePassword,
                )
              : null,
          hintText: hintText,
          hintStyle: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 14),
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFF4F6EF7), width: 1.5),
          ),
        ),
      ),
    );
  }
}
