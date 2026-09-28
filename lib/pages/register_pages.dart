import 'package:alen_solution/model/register_model.dart';
import 'package:alen_solution/service/api_service.dart';
import 'package:alen_solution/service/dio_service.dart';
import 'package:alen_solution/service/simpan_token.dart';
import 'package:flutter/material.dart';
import 'package:alen_solution/pages/login_pages.dart';
import 'package:alen_solution/pages/home_pages.dart';
import 'package:dio/dio.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Controller untuk mengambil data dari input text
  final TextEditingController namaController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _registrasiForm = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _isPasswordObscure = true;

  void _simpanPendaftaranUser() async {
    if (!_registrasiForm.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final dio = createDioService();
    final apiService = ApiService(dio);

    // masukan input dari user ke dalam model register request

    RegisterModel registerData = RegisterModel(
      name: namaController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text,
    );

    try {
      RegisterResponseModel response = await apiService.registerUser(
        registerData,
      );
      if (!mounted) return;

      if (response.data != null) {
        // Ambil token dari dalam response.data jika ingin disimpan
        final tokenBaru = response.data?.token;
        if (tokenBaru != null && tokenBaru.isNotEmpty) {
          await SimpanToken.saveToken(tokenBaru);
        }

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              response.message ?? 'Registrasi Berhasil, silahkan login.',
            ),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message ?? 'Gagal melakukan registrasi !'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } on DioException catch (e) {
      String erroMessage = 'Terjadi kesalahan pada koneksi internet';

      if (e.response != null && e.response?.data != null) {
        final responseData = e.response?.data;

        if (responseData['errors'] != null && responseData['errors'] is Map) {
          List<String> semuaError = [];
          Map<String, dynamic> errorsMap = responseData['errors'];

          errorsMap.forEach((key, value) {
            if (value is List) {
              semuaError.addAll(value.map((item) => item.toString()));
            }
          });

          if (semuaError.isNotEmpty) {
            erroMessage = semuaError.join("\n");
          }
        } else {
          erroMessage = responseData['message'] ?? erroMessage;
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $erroMessage'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    // Membersihkan controller saat widget di-dispose untuk mencegah memory leak
    namaController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _register() {
    // Validasi sederhana (seperti pada kode Anda)
    if (namaController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Harap isi semua kolom!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Tampilkan pesan sukses atau kirim data
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Pendaftaran berhasil untuk ${namaController.text}!'),
        backgroundColor: Colors.green,
      ),
    );

    // TODO: Tambahkan logika kirim data ke API / Halaman selanjutnya / ProfilePage
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Akun'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _registrasiForm,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Buat Akun Baru',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),

              // Field Input Nama
              TextFormField(
                controller: namaController,
                decoration: InputDecoration(
                  labelText: 'Nama Lengkap',
                  hintText: 'Masukkan nama Anda',
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Field Input Email
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Masukkan email Anda',
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Field Input Password
              TextField(
                controller: passwordController,
                obscureText: _isPasswordObscure,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Masukkan password',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordObscure
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordObscure = !_isPasswordObscure;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Tombol Daftar
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: _simpanPendaftaranUser,
                  child: const Text(
                    'Daftar',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Link ke Halaman Login
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Sudah punya akun? '),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context); // Kembali ke halaman Login
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
