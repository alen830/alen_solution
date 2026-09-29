import 'package:flutter/material.dart';

import 'home_pages.dart';

class DaftarHadirPage extends StatefulWidget {
  const DaftarHadirPage({super.key});

  // Variabel statis untuk menampung riwayat presensi yang dikirim dari HomePage
  static List<Map<String, String>> listHadirGlobal = [];

  @override
  State<DaftarHadirPage> createState() => _DaftarHadirPageState();
}

class _DaftarHadirPageState extends State<DaftarHadirPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          'Daftar Kehadiran',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Isi Absen Baru'),
      ),
      body: DaftarHadirPage.listHadirGlobal.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox_outlined, size: 70, color: Colors.grey),
                  SizedBox(height: 12),
                  Text(
                    'Belum ada data kehadiran',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: DaftarHadirPage.listHadirGlobal.length,
              itemBuilder: (context, index) {
                final data = DaftarHadirPage.listHadirGlobal[index];
                final isTepatWaktu = data['status'] == 'Tepat Waktu';

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    leading: CircleAvatar(
                      backgroundColor: Colors.deepPurple.shade100,
                      child: Text(
                        data['nama']!.isNotEmpty
                            ? data['nama']![0].toUpperCase()
                            : '?',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ),
                    title: Text(
                      data['nama'] ?? '',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text('Divisi: ${data['jabatan'] ?? '-'}'),
                        Text(
                          'Jam: ${data['jam'] ?? '-'}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    trailing: Chip(
                      label: Text(
                        data['status'] ?? '',
                        style: TextStyle(
                          fontSize: 12,
                          color: isTepatWaktu
                              ? Colors.green.shade800
                              : Colors.red.shade800,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      backgroundColor: isTepatWaktu
                          ? Colors.green.shade50
                          : Colors.red.shade50,
                      side: BorderSide(
                        color: isTepatWaktu
                            ? Colors.green.shade200
                            : Colors.red.shade200,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
