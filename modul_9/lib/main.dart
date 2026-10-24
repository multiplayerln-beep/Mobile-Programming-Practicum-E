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
      title: 'Tugas Modul 9 - Tasbih Digital',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const TasbihScreen(),
    );
  }
}

// Menggunakan StatefulWidget karena layar ini perlu merender ulang UI
// setiap kali angka hitungan bertambah atau di-reset.
class TasbihScreen extends StatefulWidget {
  const TasbihScreen({super.key});

  @override
  State<TasbihScreen> createState() => _TasbihScreenState();
}

class _TasbihScreenState extends State<TasbihScreen> {
  // Variabel state untuk menyimpan nilai hitungan
  double counter = 0;
  final double maxCount = 33; // Batas maksimal hitungan tasbih

  // Fungsi untuk menambah hitungan
  void _incrementCounter() {
    setState(() {
      if (counter < maxCount) {
        counter++;
      }
    });
  }

  // Fungsi untuk mengembalikan hitungan ke 0
  void _resetCounter() {
    setState(() {
      counter = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 119, 210, 145),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Menampilkan angka hitungan
              Text(
                '${counter.toInt()}',
                style: const TextStyle(fontSize: 250, color: Colors.black87),
              ),

              // Progress Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: LinearProgressIndicator(
                  value:
                      counter /
                      maxCount, // Kalkulasi otomatis dari 0.0 hingga 1.0
                  backgroundColor: Colors.white54,
                  color: Colors.amberAccent.shade400,
                  minHeight: 15,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              const SizedBox(height: 75),

              // Tombol Tambah (Ikon Fingerprint)
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: InkWell(
                  onTap: _incrementCounter, // Memanggil fungsi tambah di dalam setState
                  child: Container(
                    decoration: const BoxDecoration(color: Colors.white),
                    padding: const EdgeInsets.all(30),
                    child: const Icon(
                      Icons.fingerprint,
                      size: 100,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // Tombol Reset di pojok kanan bawah
      floatingActionButton: FloatingActionButton(
        onPressed: _resetCounter, // Memanggil fungsi reset di dalam setState
        backgroundColor: Colors.white,
        child: const Icon(Icons.refresh_outlined, color: Colors.black),
      ),
    );
  }
}
