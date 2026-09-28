import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:alen_solution/pages/daftar_hadir_pages.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String jamMasuk = '--:--';
  String jamKeluar = '--:--';

  void _absenMasuk() {
    setState(() {
      jamMasuk = DateFormat('HH:mm').format(DateTime.now());
    });
  }

  void _absenKeluar() {
    setState(() {
      jamKeluar = DateFormat('HH:mm').format(DateTime.now());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard Absensi')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Kartu Tampilan Jam Masuk & Jam Keluar
            Row(
              children: [
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Text('Jam Masuk'),
                          const SizedBox(height: 8),
                          Text(
                            jamMasuk,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Text('Jam Keluar'),
                          const SizedBox(height: 8),
                          Text(
                            jamKeluar,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Tombol Absen Masuk & Keluar
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _absenMasuk,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: const Text('ABSEN MASUK'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _absenKeluar,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text('ABSEN KELUAR'),
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
