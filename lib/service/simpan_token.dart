import 'package:shared_preferences/shared_preferences.dart';

class SimpanToken {
  //simpan token ke local database jika berhasil login
  static Future<void> saveToken(String token) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString('autentikasi_token', token);
  }
  //ambil token dari lokal database

  static Future<String?> getToken() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString('autentikasi_token');
  }

  //hapus token ketika logout

  static Future<void> hapusToken() async {
    final pref = await SharedPreferences.getInstance();
    await pref.reload();
    await pref.remove('autentikasi_token');
    await pref.remove('nama_user');
  }
}
