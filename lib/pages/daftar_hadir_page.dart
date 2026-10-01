import 'package:flutter/material.dart';

// Model data kehadiran
class PresensiItem {
  final String nama;
  final String tanggal;
  final String jam;
  final String status;

  PresensiItem({
    this.nama = '',
    required this.tanggal,
    required this.jam,
    required this.status,
  });

  bool get isLate => status.toLowerCase() == 'terlambat';
}

class DaftarHadirPage extends StatefulWidget {
  // Menerima data daftar hadir baru dari halaman register
  final List<PresensiItem>? riwayatAwal;

  const DaftarHadirPage({super.key, this.riwayatAwal});

  @override
  State<DaftarHadirPage> createState() => _DaftarHadirPageState();
}

class _DaftarHadirPageState extends State<DaftarHadirPage> {
  late List<PresensiItem> riwayatHadir;

  @override
  void initState() {
    super.initState();

    // Data riwayat bawaan (contoh default)
    final riwayatBawaan = [
      PresensiItem(
        nama: 'Budi Santoso',
        tanggal: '01 Okt 2026',
        jam: '08:00 WIB',
        status: 'Hadir',
      ),
      PresensiItem(
        nama: 'Siti Aminah',
        tanggal: '30 Sep 2026',
        jam: '08:05 WIB',
        status: 'Hadir',
      ),
      PresensiItem(
        nama: 'Rian Pratama',
        tanggal: '29 Sep 2026',
        jam: '08:15 WIB',
        status: 'Terlambat',
      ),
    ];

    // Jika ada kiriman data dari Register, masukkan ke paling atas
    if (widget.riwayatAwal != null && widget.riwayatAwal!.isNotEmpty) {
      riwayatHadir = [...widget.riwayatAwal!, ...riwayatBawaan];
    } else {
      riwayatHadir = riwayatBawaan;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Daftar Hadir',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: riwayatHadir.isEmpty
          ? _buildEmptyState()
          : ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: riwayatHadir.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final item = riwayatHadir[index];
                return _buildPresensiCard(item);
              },
            ),
    );
  }

  Widget _buildPresensiCard(PresensiItem item) {
    final statusColor = item.isLate ? Colors.orange : Colors.teal;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(
            item.isLate ? Icons.alarm_off_rounded : Icons.check_circle_rounded,
            color: statusColor,
            size: 24,
          ),
        ),
        title: Text(
          item.nama.isNotEmpty
              ? '${item.nama} (${item.tanggal})'
              : item.tanggal,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            color: Color(0xFF1E293B),
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            'Waktu Masuk: ${item.jam}',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: statusColor.withOpacity(0.2)),
          ),
          child: Text(
            item.status,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: statusColor.shade800,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_busy_rounded, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          Text(
            'Belum ada riwayat kehadiran',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
          ),
        ],
      ),
    );
  }
}
