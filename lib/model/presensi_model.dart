// lib/models/presensi_model.dart
import 'package:flutter/material.dart';

class PresensiModel {
  final String tanggal;
  final String jam;
  final String status;
  final String? catatan;

  const PresensiModel({
    required this.tanggal,
    required this.jam,
    required this.status,
    this.catatan,
  });
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
