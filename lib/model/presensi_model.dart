import 'package:flutter/material.dart';

// --- Model Presensi ---
class Presensi {
  final String nama;
  final String tanggal;
  final String status; // 'Tepat Waktu', 'Lewat', 'Izin', 'Cuti'
  final String jamMasuk;
  final String jamKeluar;
  final String lokasi;

  const Presensi({
    required this.nama,
    required this.tanggal,
    required this.status,
    this.jamMasuk = '',
    this.jamKeluar = '',
    this.lokasi = '',
  });
}

// --- Shared Repository ---
class PresensiRepository {
  static final List<Presensi> _data = [
    const Presensi(
      nama: 'Budi Santoso',
      tanggal: '30 Sep 2026',
      status: 'Tepat Waktu',
      jamMasuk: '07:55',
      jamKeluar: '17:05',
      lokasi: 'Kantor Pusat - Jakarta',
    ),
    const Presensi(
      nama: 'Siti Rahma',
      tanggal: '30 Sep 2026',
      status: 'Lewat',
      jamMasuk: '08:20',
      jamKeluar: '17:15',
      lokasi: 'Kantor Cabang - Bandung',
    ),
    const Presensi(
      nama: 'Ahmad Fauzi',
      tanggal: '30 Sep 2026',
      status: 'Izin',
      lokasi: 'Cuti Tahunan (Disetujui HR)',
    ),
    const Presensi(
      nama: 'Rina Wijaya',
      tanggal: '30 Sep 2026',
      status: 'Tepat Waktu',
      jamMasuk: '07:48',
      lokasi: 'Kantor Pusat - Jakarta',
    ),
  ];

  static List<Presensi> get daftarKehadiran => List.unmodifiable(_data);

  static void tambahPresensi(Presensi item) {
    _data.insert(0, item);
  }
}

class DaftarHadirPage extends StatefulWidget {
  const DaftarHadirPage({super.key});

  @override
  State<DaftarHadirPage> createState() => _DaftarHadirPageState();
}

class _DaftarHadirPageState extends State<DaftarHadirPage> {
  String _selectedFilter = 'Semua';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  Future<void> _refreshData() async {
    await Future.delayed(const Duration(milliseconds: 400));
    if (mounted) setState(() {});
  }

  void _bukaFormInput() {
    final namaController = TextEditingController();
    final lokasiController = TextEditingController(
      text: 'Kantor Pusat - Jakarta',
    );
    String statusDipilih = 'Tepat Waktu';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 16,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: const Color(0xFFCBD5E1),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Input Presensi Baru',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: namaController,
                      decoration: InputDecoration(
                        labelText: 'Nama Karyawan',
                        hintText: 'Contoh: Alex Pratama',
                        prefixIcon: const Icon(
                          Icons.person_outline_rounded,
                          size: 20,
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFE2E8F0),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFE2E8F0),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: statusDipilih,
                      decoration: InputDecoration(
                        labelText: 'Status Kehadiran',
                        prefixIcon: const Icon(Icons.badge_outlined, size: 20),
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFE2E8F0),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFE2E8F0),
                          ),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'Tepat Waktu',
                          child: Text('Tepat Waktu'),
                        ),
                        DropdownMenuItem(
                          value: 'Lewat',
                          child: Text('Lewat / Terlambat'),
                        ),
                        DropdownMenuItem(
                          value: 'Izin',
                          child: Text('Izin / Cuti'),
                        ),
                      ],
                      onChanged: (val) {
                        setModalState(
                          () => statusDipilih = val ?? 'Tepat Waktu',
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: lokasiController,
                      decoration: InputDecoration(
                        labelText: 'Lokasi / Keterangan',
                        hintText: 'Contoh: Kantor Pusat - Jakarta',
                        prefixIcon: const Icon(
                          Icons.location_on_outlined,
                          size: 20,
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFE2E8F0),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFE2E8F0),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4F46E5),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          if (namaController.text.trim().isEmpty) return;

                          final now = TimeOfDay.now();
                          final jamNow =
                              '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

                          PresensiRepository.tambahPresensi(
                            Presensi(
                              nama: namaController.text.trim(),
                              tanggal: '30 Sep 2026',
                              status: statusDipilih,
                              jamMasuk: statusDipilih == 'Izin' ? '' : jamNow,
                              jamKeluar: '',
                              lokasi: lokasiController.text.trim(),
                            ),
                          );

                          Navigator.pop(ctx);
                          setState(() {});
                        },
                        child: const Text(
                          'Simpan Kehadiran',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Presensi> allList = PresensiRepository.daftarKehadiran;

    // Hitung ringkasan
    final int hadirCount = allList
        .where((p) => p.status.toLowerCase() == 'tepat waktu')
        .length;
    final int lewatCount = allList
        .where((p) => p.status.toLowerCase().contains('lewat'))
        .length;
    final int izinCount = allList.where((p) {
      final s = p.status.toLowerCase();
      return s.contains('izin') || s.contains('cuti');
    }).length;

    // Filter status & pencarian nama
    final filteredList = allList.where((item) {
      final matchesSearch = item.nama.toLowerCase().contains(
        _searchQuery.toLowerCase(),
      );
      if (!matchesSearch) return false;

      if (_selectedFilter == 'Hadir')
        return item.status.toLowerCase() == 'tepat waktu';
      if (_selectedFilter == 'Lewat')
        return item.status.toLowerCase().contains('lewat');
      if (_selectedFilter == 'Izin') {
        final s = item.status.toLowerCase();
        return s.contains('izin') || s.contains('cuti');
      }
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF1E293B),
            size: 18,
          ),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const Text(
          'Daftar Hadir',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1E293B),
            letterSpacing: -0.3,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF4F46E5),
        foregroundColor: Colors.white,
        elevation: 3,
        onPressed: _bukaFormInput,
        icon: const Icon(Icons.add_rounded, size: 20),
        label: const Text(
          'Presensi Baru',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        color: const Color(0xFF4F46E5),
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          children: [
            _buildSummaryCard(hadirCount, lewatCount, izinCount),
            const SizedBox(height: 18),
            _buildSearchBar(),
            const SizedBox(height: 14),
            _buildFilterRow(allList.length, hadirCount, lewatCount, izinCount),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Riwayat Kehadiran',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F172A),
                  ),
                ),
                Text(
                  '${filteredList.length} dari ${allList.length} data',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (filteredList.isEmpty)
              _buildEmptyState()
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredList.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) =>
                    _buildAttendanceCard(filteredList[index]),
              ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (val) => setState(() => _searchQuery = val),
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          hintText: 'Cari nama karyawan...',
          hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
          prefixIcon: const Icon(
            Icons.search_rounded,
            size: 20,
            color: Color(0xFF94A3B8),
          ),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(
                    Icons.close_rounded,
                    size: 18,
                    color: Color(0xFF94A3B8),
                  ),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(int hadir, int lewat, int izin) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildSummaryItem(
            "Tepat Waktu",
            "$hadir",
            const Color(0xFF10B981),
            Icons.check_circle_outline_rounded,
          ),
          Container(width: 1, height: 32, color: const Color(0xFFF1F5F9)),
          _buildSummaryItem(
            "Terlambat",
            "$lewat",
            const Color(0xFFF59E0B),
            Icons.alarm_rounded,
          ),
          Container(width: 1, height: 32, color: const Color(0xFFF1F5F9)),
          _buildSummaryItem(
            "Izin / Cuti",
            "$izin",
            const Color(0xFF6366F1),
            Icons.event_note_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(
    String label,
    String count,
    Color color,
    IconData icon,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(
          count,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFF64748B),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildFilterRow(int total, int hadir, int lewat, int izin) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          _buildFilterChip('Semua', total),
          const SizedBox(width: 8),
          _buildFilterChip('Hadir', hadir),
          const SizedBox(width: 8),
          _buildFilterChip('Lewat', lewat),
          const SizedBox(width: 8),
          _buildFilterChip('Izin', izin),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, int total) {
    final bool isSelected = _selectedFilter == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF4F46E5) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF4F46E5)
                : const Color(0xFFE2E8F0),
          ),
        ),
        child: Text(
          '$label ($total)',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : const Color(0xFF64748B),
          ),
        ),
      ),
    );
  }

  Widget _buildAttendanceCard(Presensi item) {
    final String status = item.status.toLowerCase();
    final bool isIzin = status.contains('izin') || status.contains('cuti');
    final bool isOnTime = status == 'tepat waktu';

    final Color statusColor = isIzin
        ? const Color(0xFF6366F1)
        : (isOnTime ? const Color(0xFF10B981) : const Color(0xFFEF4444));

    final IconData statusIcon = isIzin
        ? Icons.description_outlined
        : (isOnTime
              ? Icons.check_circle_outline_rounded
              : Icons.alarm_off_rounded);

    final String displayName = item.nama.trim().isNotEmpty
        ? item.nama
        : "Karyawan";
    final String initial = displayName.isNotEmpty
        ? displayName[0].toUpperCase()
        : "U";

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(width: 4.5, color: statusColor),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 17,
                                  backgroundColor: statusColor.withOpacity(
                                    0.12,
                                  ),
                                  child: Text(
                                    initial,
                                    style: TextStyle(
                                      color: statusColor,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        displayName,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF0F172A),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        item.tanggal,
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: Color(0xFF94A3B8),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3.5,
                            ),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(statusIcon, size: 12, color: statusColor),
                                const SizedBox(width: 4),
                                Text(
                                  item.status,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: statusColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Divider(
                        height: 1,
                        thickness: 0.8,
                        color: Color(0xFFF1F5F9),
                      ),
                      const SizedBox(height: 10),
                      if (isIzin)
                        Row(
                          children: [
                            const Icon(
                              Icons.info_outline_rounded,
                              size: 15,
                              color: Color(0xFF6366F1),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                item.lokasi.isNotEmpty
                                    ? item.lokasi
                                    : "Izin / Cuti Terverifikasi",
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF475569),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        )
                      else ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildTimeBadge(
                              label: 'Masuk',
                              time: item.jamMasuk.isEmpty
                                  ? '--:--'
                                  : item.jamMasuk,
                              icon: Icons.login_rounded,
                              iconColor: const Color(0xFF10B981),
                              isMissing: item.jamMasuk.isEmpty,
                            ),
                            _buildTimeBadge(
                              label: 'Keluar',
                              time: item.jamKeluar.isEmpty
                                  ? 'Belum Keluar'
                                  : item.jamKeluar,
                              icon: Icons.logout_rounded,
                              iconColor: const Color(0xFFF59E0B),
                              isMissing: item.jamKeluar.isEmpty,
                            ),
                          ],
                        ),
                        if (item.lokasi.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                size: 13,
                                color: Color(0xFF94A3B8),
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  item.lokasi,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF94A3B8),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeBadge({
    required String label,
    required String time,
    required IconData icon,
    required Color iconColor,
    required bool isMissing,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, size: 14, color: iconColor),
        ),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8)),
            ),
            Text(
              time,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isMissing
                    ? const Color(0xFFF59E0B)
                    : const Color(0xFF1E293B),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      margin: const EdgeInsets.only(top: 40),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(Icons.inbox_outlined, size: 54, color: Colors.grey.shade300),
          const SizedBox(height: 10),
          const Text(
            'Tidak ada riwayat ditemukan',
            style: TextStyle(
              color: Color(0xFF94A3B8),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
