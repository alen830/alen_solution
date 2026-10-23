// lib/models/presensi_model.dart
import 'package:flutter/material.dart';

class PresensiModel {
  final String nama;
  final String tanggal;
  final String? jamMasuk;
  final String? jamKeluar;
  final String status;
  final String? catatan;

  const PresensiModel({
    required this.nama,
    required this.tanggal,
    this.jamMasuk,
    this.jamKeluar,
    required this.status,
    this.catatan,
  });

  // Getter pembantu untuk mengecek apakah user sudah absen pulang
  bool get sudahKeluar => jamKeluar != null && jamKeluar!.trim().isNotEmpty;

  // Konversi dari JSON (API / Database lokal) ke Object Dart
  factory PresensiModel.fromJson(Map<String, dynamic> json) {
    return PresensiModel(
      nama: json['nama'] ?? '-',
      tanggal: json['tanggal'] ?? '-',
      // Membaca 'jam_masuk' atau 'waktu_masuk' sesuai respon backend
      jamMasuk: json['jam_masuk'] ?? json['waktu_masuk'],
      // Membaca 'jam_keluar' atau 'waktu_keluar' sesuai respon backend
      jamKeluar: json['jam_keluar'] ?? json['waktu_keluar'],
      status: json['status'] ?? 'Hadir',
      catatan: json['catatan'] ?? json['keterangan'],
    );
  }

  // Konversi dari Object Dart ke Map/JSON untuk dikirim ke API
  Map<String, dynamic> toJson() {
    return {
      'nama': nama,
      'tanggal': tanggal,
      'jam_masuk': jamMasuk,
      'jam_keluar': jamKeluar,
      'status': status,
      'catatan': catatan,
    };
  }

  // Method copyWith untuk mempermudah update jamKeluar saat checkout
  PresensiModel copyWith({
    String? nama,
    String? tanggal,
    String? jamMasuk,
    String? jamKeluar,
    String? status,
    String? catatan,
  }) {
    return PresensiModel(
      nama: nama ?? this.nama,
      tanggal: tanggal ?? this.tanggal,
      jamMasuk: jamMasuk ?? this.jamMasuk,
      jamKeluar: jamKeluar ?? this.jamKeluar,
      status: status ?? this.status,
      catatan: catatan ?? this.catatan,
    );
  }
}

class StatusConfig {
  final Color primaryColor;
  final Color backgroundColor;
  final IconData icon;

  const StatusConfig({
    required this.primaryColor,
    required this.backgroundColor,
    required this.icon,
  });

  static StatusConfig getConfig(String status) {
    switch (status.toLowerCase()) {
      case 'hadir':
        return const StatusConfig(
          primaryColor: Color(0xFF16A34A),
          backgroundColor: Color(0xFFDCFCE7),
          icon: Icons.check_circle_rounded,
        );
      case 'terlambat':
        return const StatusConfig(
          primaryColor: Color(0xFFD97706),
          backgroundColor: Color(0xFFFEF3C7),
          icon: Icons.access_time_filled_rounded,
        );
      case 'izin':
        return const StatusConfig(
          primaryColor: Color(0xFF2563EB),
          backgroundColor: Color(0xFFDBEAFE),
          icon: Icons.assignment_turned_in_rounded,
        );
      case 'sakit':
        return const StatusConfig(
          primaryColor: Color(0xFFDC2626),
          backgroundColor: Color(0xFFFEE2E2),
          icon: Icons.local_hospital_rounded,
        );
      case 'dinas luar':
        return const StatusConfig(
          primaryColor: Color(0xFF7C3AED),
          backgroundColor: Color(0xFFEDE9FE),
          icon: Icons.business_center_rounded,
        );
      default:
        return const StatusConfig(
          primaryColor: Color(0xFF4B5563),
          backgroundColor: Color(0xFFF3F4F6),
          icon: Icons.help_outline_rounded,
        );
    }
  }
}
