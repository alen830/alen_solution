import 'package:flutter/material.dart';

class DaftarHadirPage extends StatefulWidget {
  const DaftarHadirPage({super.key});

  @override
  State<DaftarHadirPage> createState() => _DaftarHadirPageState();
}

class _DaftarHadirPageState extends State<DaftarHadirPage> {
  // Contoh data senarai kehadiran (boleh digantikan dengan data API/Dio)
  final List<Map<String, dynamic>> _attendanceList = [
    {
      'date': 'Selasa, 29 September 2026',
      'checkIn': '07:55 AM',
      'checkOut': '05:05 PM',
      'status': 'Tepat Waktu',
      'isOnTime': true,
      'location': 'Pejabat Pusat (GPS Sah)',
    },
    {
      'date': 'Isnin, 28 September 2026',
      'checkIn': '08:12 AM',
      'checkOut': '05:00 PM',
      'status': 'Lewat',
      'isOnTime': false,
      'location': 'Pejabat Pusat (GPS Sah)',
    },
    {
      'date': 'Jumaat, 25 September 2026',
      'checkIn': '07:50 AM',
      'checkOut': '05:00 PM',
      'status': 'Tepat Waktu',
      'isOnTime': true,
      'location': 'Pejabat Pusat (GPS Sah)',
    },
    {
      'date': 'Khamis, 24 September 2026',
      'checkIn': '07:58 AM',
      'checkOut': '05:10 PM',
      'status': 'Tepat Waktu',
      'isOnTime': true,
      'location': 'Pejabat Pusat (GPS Sah)',
    },
  ];

  Future<void> _refreshData() async {
    // Simulasi memuat turun data terkini daripada API
    await Future.delayed(const Duration(seconds: 1));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF1E293B),
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Daftar Hadir',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        color: const Color(0xFF4F6EF7),
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          children: [
            // Kad Ringkasan Bulan Ini
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x08000000),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildSummaryItem(
                    "Hadir",
                    "22 Hari",
                    const Color(0xFF10B981),
                  ),
                  Container(
                    width: 1,
                    height: 35,
                    color: const Color(0xFFE2E8F0),
                  ),
                  _buildSummaryItem("Lewat", "2 Hari", const Color(0xFFF59E0B)),
                  Container(
                    width: 1,
                    height: 35,
                    color: const Color(0xFFE2E8F0),
                  ),
                  _buildSummaryItem(
                    "Izin / Cuti",
                    "1 Hari",
                    const Color(0xFF64748B),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),

            const Text(
              'Riwayat Kehadiran',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 12),

            // Senarai Rekod Kehadiran
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _attendanceList.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = _attendanceList[index];
                return _buildAttendanceCard(item);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String count, Color color) {
    return Column(
      children: [
        Text(
          count,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
        ),
      ],
    );
  }

  Widget _buildAttendanceCard(Map<String, dynamic> item) {
    final bool isOnTime = item['isOnTime'];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tarikh & Status Lencana
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item['date'],
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: isOnTime
                      ? const Color(0xFF10B981).withOpacity(0.12)
                      : const Color(0xFFEF4444).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  item['status'],
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isOnTime
                        ? const Color(0xFF10B981)
                        : const Color(0xFFEF4444),
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 20, thickness: 0.8, color: Color(0xFFF1F5F9)),

          // Waktu Masuk & Keluar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.login_rounded,
                    size: 18,
                    color: Color(0xFF4F6EF7),
                  ),
                  const SizedBox(width: 6),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Masuk',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                      Text(
                        item['checkIn'],
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF334155),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(
                    Icons.logout_rounded,
                    size: 18,
                    color: Color(0xFFF59E0B),
                  ),
                  const SizedBox(width: 6),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Keluar',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                      Text(
                        item['checkOut'],
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF334155),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Maklumat Lokasi
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 14,
                color: Color(0xFF94A3B8),
              ),
              const SizedBox(width: 4),
              Text(
                item['location'],
                style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
