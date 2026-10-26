// lib/pages/input_absen_page.dart
import 'package:flutter/material.dart';

class InputAbsenPage extends StatefulWidget {
  const InputAbsenPage({super.key});

  @override
  State<InputAbsenPage> createState() => _InputAbsenPageState();
}

class _InputAbsenPageState extends State<InputAbsenPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _catatanController = TextEditingController();

  final List<String> _listStatus = ['Hadir', 'Terlambat', 'Izin', 'Sakit'];
  String? _selectedStatus = 'Hadir';

  // Placeholder catatan dinamis sesuai status yang dipilih
  String _getHintText(String? status) {
    switch (status) {
      case 'Sakit':
        return 'Contoh: Flu, Demam';
      case 'Izin':
        return 'Contoh: Urusan keluarga, Keperluan mendesak';
      case 'Terlambat':
        return 'Contoh: Terjebak macet, Kendaraan bermasalah';
      case 'Hadir':
      default:
        return 'Contoh: Tepat waktu, WFH';
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _catatanController.dispose();
    super.dispose();
  }

  void _kirimPresensi() {
    if (_formKey.currentState!.validate()) {
      final String nama = _namaController.text.trim();
      final String status = _selectedStatus ?? 'Hadir';
      final String catatan = _catatanController.text.trim();

      // Panggil API atau simpan ke state management di sini jika diperlukan

      // Tampilkan feedback sukses
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Presensi berhasil dikirim: $nama ($status)'),
          backgroundColor: Colors.green,
        ),
      );

      // Kembalikan data ke halaman pemanggil
      Navigator.pop(context, {
        'nama': nama,
        'status': status,
        'catatan': catatan,
        'waktu': DateTime.now(),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Input Presensi')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Input Nama Lengkap
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama Lengkap',
                  prefixIcon: Icon(Icons.person_outline),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama lengkap tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Dropdown Status Kehadiran
              DropdownButtonFormField<String>(
                value: _selectedStatus,
                decoration: InputDecoration(
                  labelText: 'Status Kehadiran',
                  prefixIcon: const Icon(Icons.check_circle_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                items: _listStatus.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedStatus = newValue;
                  });
                },
                validator: (value) =>
                    value == null ? 'Pilih salah satu status' : null,
              ),
              const SizedBox(height: 16),

              // Input Catatan / Alasan
              TextFormField(
                controller: _catatanController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Catatan / Alasan (Opsional)',
                  hintText: _getHintText(_selectedStatus),
                  alignLabelWithHint: true,
                  prefixIcon: const Icon(Icons.notes),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),

              // Tombol Kirim
              ElevatedButton.icon(
                onPressed: _kirimPresensi,
                icon: const Icon(Icons.send),
                label: const Text('Kirim Presensi'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
