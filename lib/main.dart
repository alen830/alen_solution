import 'package:alen_solution/pages/home_pages.dart';
import 'package:alen_solution/pages/input_absen_page.dart';
import 'package:alen_solution/pages/login_pages.dart';
import 'package:alen_solution/pages/profile_page.dart';
import 'package:alen_solution/pages/register_pages.dart';
import 'package:flutter/material.dart';
import 'package:alen_solution/pages/historyabsenscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Absensi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ProfilePages(),
    );
  }
}
