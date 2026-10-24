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
      title: 'Tugas Music Card',
      // Mengubah tema aplikasi menjadi gelap
      theme: ThemeData.dark(),
      home: const MusicCardScreen(),
    );
  }
}

class MusicCardScreen extends StatelessWidget {
  const MusicCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sedang memutar'),
        // Memposisikan teks AppBar di tengah
        centerTitle: true,
      ),
      // Menempatkan Card tepat di tengah layar
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Card(
            elevation: 4,
            // Membuat sudut Card membulat
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            // Mengatur warna latar Card agar sedikit berbeda dengan background hitam Scaffold
            color: const Color(0xFF1E1E1E),
            child: Padding(
              // Memberikan ruang (padding) di dalam Card
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize:
                    MainAxisSize.min, // Ukuran Column menyesuaikan isi
                children: [
                  // 1. Ikon Cover Album
                  const Icon(
                    Icons.album, // Ikon bawaan piringan hitam/album
                    size: 150,
                    color: Colors.blueGrey,
                  ),

                  // Menggunakan SizedBox untuk memberi jarak vertikal yang FIX/tetap
                  const SizedBox(height: 30),

                  // Baris untuk Info Lagu dan Tombol Like
                  Row(
                    children: [
                      // 2. Info Lagu (Judul dan Nama Artis)
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Di sini ada judul lagu',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          // Jarak kecil antara judul dan artis
                          SizedBox(height: 5),
                          Text(
                            'Di sini ada nama artis',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),

                      // 3. Menggunakan Spacer untuk mendorong tombol Like ke ujung kanan layar
                      const Spacer(),

                      // 4. Tombol Aksi (Like)
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.favorite_border,
                          color: Colors.redAccent,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
