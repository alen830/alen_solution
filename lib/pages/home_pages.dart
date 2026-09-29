import 'package:flutter/material.dart';

import 'daftar_hadir_pages.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _jabatanController = TextEditingController();
  String _statusTerpilih = 'Tepat Waktu';

  void _simpanAbsen() {
    if (_formKey.currentState!.validate()) {
      final now = DateTime.now();
      final String jamFormatted =
          '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')} WIB';

      // Simpan data ke static list DaftarHadirPage
      DaftarHadirPage.listHadirGlobal.insert(0, {
        'nama': _namaController.text.trim(),
        'jabatan': _jabatanController.text.trim(),
        'jam': jamFormatted,
        'status': _statusTerpilih,
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Presensi berhasil dicatat!'),
          backgroundColor: Colors.green.shade700,
          behavior: SnackBarBehavior.floating,
        ),
      );

      // Berpindah ke halaman DaftarHadirPage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DaftarHadirPage()),
      );
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _jabatanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          'ABSEN PPKD',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.assignment_turned_in_rounded,
                        size: 60,
                        color: Colors.deepPurple,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Silakan Isi Absen Anda',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Input Nama
                    TextFormField(
                      controller: _namaController,
                      decoration: InputDecoration(
                        labelText: 'Nama Lengkap',
                        prefixIcon: const Icon(Icons.person_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                          ? 'Nama wajib diisi'
                          : null,
                    ),
                    const SizedBox(height: 16),

                    // Input Jabatan
                    TextFormField(
                      controller: _jabatanController,
                      decoration: InputDecoration(
                        labelText: 'Jabatan / Divisi',
                        prefixIcon: const Icon(Icons.work_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                          ? 'Jabatan wajib diisi'
                          : null,
                    ),
                    const SizedBox(height: 16),

                    // Pilihan Status
                    DropdownButtonFormField<String>(
                      value: _statusTerpilih,
                      decoration: InputDecoration(
                        labelText: 'Keterangan Hadir',
                        prefixIcon: const Icon(Icons.access_time),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'Tepat Waktu',
                          child: Text(
                            'Tepat Waktu',
                            style: TextStyle(color: Colors.green),
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'Terlambat',
                          child: Text(
                            'Terlambat',
                            style: TextStyle(color: Colors.orange),
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null)
                          setState(() => _statusTerpilih = value);
                      },
                    ),
                    const SizedBox(height: 28),

                    // Tombol Submit
                    ElevatedButton.icon(
                      icon: const Icon(Icons.send_rounded),
                      label: const Text('Kirim Kehadiran'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: _simpanAbsen,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
