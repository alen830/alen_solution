import 'package:flutter/material.dart';

class HistoryAbsenScreen extends StatefulWidget {
  const HistoryAbsenScreen({super.key});

  @override
  State<HistoryAbsenScreen> createState() => _HistoryAbsenScreenState();
}

class _HistoryAbsenScreenState extends State<HistoryAbsenScreen> {
  // Contoh data dummy riwayat presensi (bisa diganti dengan data dari API/presensi_model.dart)
  final List<Map<String, dynamic>> _dummyHistory = [
    {
      'tanggal': '23 Okt 2024',
      'jam_masuk': '07:55 WIB',
      'jam_keluar': '17:05 WIB',
      'status': 'Tepat Waktu',
      'is_late': false,
    },
    {
      'tanggal': '22 Okt 2024',
      'jam_masuk': '08:15 WIB',
      'jam_keluar': '17:00 WIB',
      'status': 'Terlambat',
      'is_late': true,
    },
    {
      'tanggal': '21 Okt 2024',
      'jam_masuk': '07:50 WIB',
      'jam_keluar': '17:10 WIB',
      'status': 'Tepat Waktu',
      'is_late': false,
    },
    {
      'tanggal': '18 Okt 2024',
      'jam_masuk': '-',
      'jam_keluar': '-',
      'status': 'Izin / Cuti',
      'is_late': false,
    },
  ];

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

  Future<void> _fetchHistory() async {
    setState(() => _isLoading = true);
    // TODO: Panggil ApiService Anda di sini, contoh:
    // final data = await ApiService().getHistoryPresensi();
    await Future.delayed(const Duration(milliseconds: 600)); // simulasi loading
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Riwayat Absensi',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: _fetchHistory,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _dummyHistory.isEmpty
            ? _buildEmptyState()
            : ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                itemCount: _dummyHistory.length,
                itemBuilder: (context, index) {
                  final item = _dummyHistory[index];
                  return _buildHistoryCard(item);
                },
              ),
      ),
    );
  }

  Widget _buildHistoryCard(Map<String, dynamic> item) {
    final bool isLate = item['is_late'] ?? false;
    final bool isIzin = item['status'] == 'Izin / Cuti';

    Color statusColor = Colors.green;
    if (isLate) {
      statusColor = Colors.orange;
    } else if (isIzin) {
      statusColor = Colors.blue;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card: Tanggal dan Status Badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      item['tanggal'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    item['status'],
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            // Detail Jam Masuk dan Keluar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTimeColumn(
                  label: 'Jam Masuk',
                  time: item['jam_masuk'],
                  icon: Icons.login_rounded,
                  iconColor: Colors.teal,
                ),
                Container(height: 35, width: 1, color: Colors.grey[300]),
                _buildTimeColumn(
                  label: 'Jam Pulang',
                  time: item['jam_keluar'],
                  icon: Icons.logout_rounded,
                  iconColor: Colors.redAccent,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeColumn({
    required String label,
    required String time,
    required IconData icon,
    required Color iconColor,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: iconColor),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          time,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history_toggle_off, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 12),
          Text(
            'Belum ada riwayat absensi',
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
          ),
        ],
      ),
    );
  }
}
