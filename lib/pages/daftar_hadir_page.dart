import 'package:flutter/material.dart';

// ==========================================
// 1. MODEL DATA PRESENSI
// ==========================================
class Presensi {
  final String nama;
  final String tanggal;
  final String status;
  final String jamMasuk;
  String jamKeluar; // Bukan final agar bisa diisi saat Check Out
  final String lokasi;

  Presensi({
    required this.nama,
    required this.tanggal,
    required this.status,
    required this.jamMasuk,
    this.jamKeluar = '--:--',
    required this.lokasi,
  });
}

// ==========================================
// 2. DATA REPOSITORY & FUNGSI OTOMATIS
// ==========================================
class PresensiRepository {
  // List data presensi (bisa bertambah otomatis)
  static List<Presensi> daftarKehadiran = [
    Presensi(
      nama: 'Budi Santoso',
      tanggal: 'Senin, 30 Sep 2026',
      status: 'Tepat Waktu',
      jamMasuk: '07:55',
      jamKeluar: '17:05',
      lokasi: 'Kantor Pusat',
    ),
    Presensi(
      nama: 'Siti Aminah',
      tanggal: 'Senin, 30 Sep 2026',
      status: 'Lewat',
      jamMasuk: '08:24',
      jamKeluar: '17:30',
      lokasi: 'Kantor Pusat',
    ),
  ];

  // 🔹 FUNGSI CHECK IN OTOMATIS
  static void checkIn(String namaKaryawan, {String lokasi = 'Kantor Pusat'}) {
    final now = DateTime.now();
    final jam =
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
    final tanggal = "${now.day}/${now.month}/${now.year}";

    // Otomatis tentukan status (lewat batas jam 08:00 dianggap 'Lewat')
    final status = (now.hour < 8 || (now.hour == 8 && now.minute == 0))
        ? 'Tepat Waktu'
        : 'Lewat';

    // Tambahkan data presensi baru ke urutan paling atas
    daftarKehadiran.insert(
      0,
      Presensi(
        nama: namaKaryawan,
        tanggal: tanggal,
        status: status,
        jamMasuk: jam,
        jamKeluar: '--:--',
        lokasi: lokasi,
      ),
    );
  }

  // 🔹 FUNGSI CHECK OUT OTOMATIS
  static void checkOut(String namaKaryawan) {
    final now = DateTime.now();
    final jam =
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

    // Cari riwayat masuk yang jam keluarnya masih kosong
    try {
      final item = daftarKehadiran.firstWhere(
        (p) => p.nama == namaKaryawan && p.jamKeluar == '--:--',
      );
      item.jamKeluar = jam;
    } catch (e) {
      // Jika belum check-in hari ini atau sudah check-out
    }
  }
}
