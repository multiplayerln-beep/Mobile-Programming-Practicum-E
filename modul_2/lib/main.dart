import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Row and Column',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Row and Column'),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Baris Pertama (2 Kotak)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  KotakFavorite(warnaKotak: Colors.lightBlue, teks: 'Kotak 1'),
                  SizedBox(width: 20), // Jarak antar kotak horizontal
                  KotakFavorite(warnaKotak: Colors.lightGreen, teks: 'Kotak 2'),
                ],
              ),
              SizedBox(height: 20), // Jarak antar baris vertikal
              // Baris Kedua (2 Kotak)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  KotakFavorite(warnaKotak: Colors.amber, teks: 'Kotak 3'),
                  SizedBox(width: 20),
                  KotakFavorite(
                    warnaKotak: Colors.purpleAccent,
                    teks: 'Kotak 4',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom Widget untuk Kotak Favorite
class KotakFavorite extends StatelessWidget {
  final Color warnaKotak;
  final String teks;

  const KotakFavorite({
    super.key,
    required this.warnaKotak,
    required this.teks,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: warnaKotak,
        border: Border.all(color: Colors.black, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      // Menggunakan Column untuk menyusun Ikon dan Teks secara vertikal
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.favorite, color: Colors.red, size: 40),
          const SizedBox(height: 10), // Jarak antara ikon dan teks
          Text(
            teks,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
