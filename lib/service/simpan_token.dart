import 'package:shared_preferences/shared_preferences.dart';

class SimpanToken {
  // Simpan token ke local storage
  static Future<void> saveToken(String token) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString('autentikasi_token', token);
  }

  // Ambil token dari local storage
  static Future<String?> getToken() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString('autentikasi_token');
  }

  // Simpan nama user
  static Future<void> saveNama(String nama) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString('nama_user', nama);
  }

  // Ambil nama user
  static Future<String?> getNama() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString('nama_user');
  }

  // Hapus semua sesi ketika logout
  static Future<void> hapusToken() async {
    final pref = await SharedPreferences.getInstance();
    await pref.reload();
    await pref.remove('autentikasi_token');
    await pref.remove('nama_user');
  }
}
