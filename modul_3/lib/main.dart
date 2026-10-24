import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tugas Alignment Cuaca',
      home: WeatherScreen(),
    );
  }
}

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Menggunakan background sedikit keunguan/pink muda agar mirip dengan modul
      backgroundColor: const Color(0xFFFFF7FA),
      body: SafeArea(
        child: Center(
          child: Column(
            // Mengatur jarak vertikal agar tersebar proporsional (atas, tengah, bawah)
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text(
                'Malang',
                style: TextStyle(fontSize: 45, color: Colors.black87),
              ),
              const Text(
                '25°',
                style: TextStyle(
                  fontSize: 130,
                  fontWeight: FontWeight.w400,
                  color: Colors.black87,
                ),
              ),
              Row(
                // Mengatur jarak horizontal secara merata antar ramalan hari
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildForecast('Minggu', Icons.sunny, '20°C'),
                  _buildForecast('Senin', Icons.cloudy_snowing, '23°C'),
                  _buildForecast('Selasa', Icons.cloud, '22°C'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Method custom untuk membuat kolom cuaca per harinya
  Widget _buildForecast(String hari, IconData ikon, String suhu) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(hari, style: const TextStyle(fontSize: 18, color: Colors.black87)),
        const SizedBox(height: 15), // Jarak antara teks hari dan ikon
        Icon(ikon, size: 50, color: Colors.black87),
        const SizedBox(height: 15), // Jarak antara ikon dan teks suhu
        Text(suhu, style: const TextStyle(fontSize: 16, color: Colors.black87)),
      ],
    );
  }
}
