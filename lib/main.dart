import 'package:alen_solution/pages/daftar_hadir_pages.dart';
import 'package:alen_solution/pages/home_pages.dart';
import 'package:alen_solution/pages/login_pages.dart';
import 'package:alen_solution/pages/profile_pages.dart';
import 'package:alen_solution/pages/register_pages.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const RegisterPage(),
    );
  }
}
