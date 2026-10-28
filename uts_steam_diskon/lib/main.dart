import 'package:flutter/material.dart';

import 'views/home_screen.dart';

void main() {
  runApp(const SteamDealsApp());
}

class SteamDealsApp extends StatelessWidget {
  const SteamDealsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Steam Deals Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(
          0xFF171D25,
        ), // Warna latar gelap Steam
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF171D25),
          elevation: 0,
        ),
        cardColor: const Color(0xFF202326),
      ),
      home: const HomeScreen(),
    );
  }
}
