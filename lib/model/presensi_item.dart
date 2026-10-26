class PresensiItem {
  final String nama;
  final String tanggal;
  final String? waktuMasuk;
  final String? waktuKeluar;
  final String status;
  final String? jam;
  final String? keterangan;

  PresensiItem({
    this.nama = '',
    required this.tanggal,
    this.waktuMasuk,
    this.waktuKeluar,
    required this.status,
    this.jam,
    this.keterangan,
  });

  bool get isHadir => status.toLowerCase() == 'hadir';
  bool get isLate => status.toLowerCase() == 'terlambat';
  bool get isSakit => status.toLowerCase() == 'sakit';
  bool get isIzin => status.toLowerCase() == 'izin';
}
