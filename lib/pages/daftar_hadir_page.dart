import 'package:flutter/material.dart';

// Model data kehadiran
class PresensiItem {
  final String nama;
  final String tanggal;
  final String? waktuMasuk;
  final String? waktuKeluar;
  final String status;
  final String? jam;

  PresensiItem({
    this.nama = '',
    required this.tanggal,
    this.waktuMasuk,
    this.waktuKeluar,
    required this.status,
    this.jam,
  });

  bool get isHadir => status.toLowerCase() == 'hadir';
  bool get isLate => status.toLowerCase() == 'terlambat';
  bool get isSakit => status.toLowerCase() == 'sakit';
  bool get isIzin => status.toLowerCase() == 'izin';
}

// Simpan data di level file agar tidak hilang saat halaman di-pop atau di-reopen
List<PresensiItem> riwayatGlobal = [
  PresensiItem(
    nama: 'Budi Santoso',
    tanggal: '01 Okt 2026',
    waktuMasuk: '08:00 WIB',
    waktuKeluar: '17:00 WIB',
    status: 'Hadir',
  ),
  PresensiItem(
    nama: 'Siti Aminah',
    tanggal: '30 Sep 2026',
    waktuMasuk: '08:05 WIB',
    waktuKeluar: null,
    status: 'Hadir',
  ),
  PresensiItem(
    nama: 'Rian Pratama',
    tanggal: '29 Sep 2026',
    waktuMasuk: '08:15 WIB',
    waktuKeluar: '17:10 WIB',
    status: 'Terlambat',
  ),
];

class DaftarHadirPage extends StatefulWidget {
  final List<PresensiItem>? riwayatAwal;

  const DaftarHadirPage({super.key, this.riwayatAwal});

  @override
  State<DaftarHadirPage> createState() => _DaftarHadirPageState();
}

class _DaftarHadirPageState extends State<DaftarHadirPage> {
  @override
  void initState() {
    super.initState();

    // Menggabungkan data baru yang dikirim dari halaman input
    if (widget.riwayatAwal != null && widget.riwayatAwal!.isNotEmpty) {
      for (var item in widget.riwayatAwal!.reversed) {
        final namaItemBersih = item.nama.split('(').first.trim().toLowerCase();

        final indexAda = riwayatGlobal.indexWhere((data) {
          final namaDataBersih = data.nama
              .split('(')
              .first
              .trim()
              .toLowerCase();
          return namaDataBersih == namaItemBersih &&
              data.tanggal == item.tanggal;
        });

        if (indexAda != -1) {
          riwayatGlobal[indexAda] = item;
        } else {
          riwayatGlobal.insert(0, item);
        }
      }
    }
  }

  Color _getStatusColor(PresensiItem item) {
    if (item.isLate) return Colors.orange;
    if (item.isSakit) return Colors.redAccent;
    if (item.isIzin) return Colors.blueGrey;
    return Colors.teal;
  }

  IconData _getStatusIcon(PresensiItem item) {
    if (item.isLate) return Icons.alarm_off_rounded;
    if (item.isSakit) return Icons.healing_rounded;
    if (item.isIzin) return Icons.assignment_late_rounded;
    return Icons.check_circle_rounded;
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
      body: riwayatGlobal.isEmpty
          ? _buildEmptyState()
          : ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: riwayatGlobal.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final item = riwayatGlobal[index];
                return _buildPresensiCard(item);
              },
            ),
    );
  }

  Widget _buildPresensiCard(PresensiItem item) {
    final statusColor = _getStatusColor(item);
    final hasJamMasuk =
        item.waktuMasuk != null && item.waktuMasuk!.trim().isNotEmpty;
    final hasJamKeluar =
        item.waktuKeluar != null && item.waktuKeluar!.trim().isNotEmpty;

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
          child: Icon(_getStatusIcon(item), color: statusColor, size: 24),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Jam masuk tetap ditampilkan jika ada nilainya
              if (hasJamMasuk)
                Text(
                  "Waktu Masuk: ${item.waktuMasuk}",
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                ),
              // Jam keluar ditampilkan, atau status "Belum Absen Keluar" bila statusnya Hadir/Terlambat
              if (item.isHadir || item.isLate || hasJamKeluar) ...[
                const SizedBox(height: 2),
                Text(
                  "Waktu Keluar: ${hasJamKeluar ? item.waktuKeluar! : 'Belum Absen Keluar'}",
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
              // Jika status Sakit / Izin dan tidak ada data jam sama sekali
              if (!item.isHadir &&
                  !item.isLate &&
                  !hasJamMasuk &&
                  !hasJamKeluar)
                Text(
                  'Keterangan: Tidak Masuk (${item.status})',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: statusColor,
                  ),
                ),
            ],
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
              color: statusColor,
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
