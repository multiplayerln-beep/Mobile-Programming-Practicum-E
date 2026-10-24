import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tugas Modul 6',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const GameListPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class GameListPage extends StatefulWidget {
  const GameListPage({super.key});

  @override
  State<GameListPage> createState() => _GameListPageState();
}

class _GameListPageState extends State<GameListPage> {
  // List untuk menampung data game dari API
  List dataGame = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _ambilDataGame();
  }

  // Fungsi untuk mengambil data dari HTTP API FreeToGame
  Future<void> _ambilDataGame() async {
    try {
      final response = await http.get(
        Uri.parse('https://www.freetogame.com/api/games'),
      );

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        setState(() {
          dataGame = data.take(20).toList(); // Ambil 20 data game pertama
          isLoading = false;
        });
      } else {
        throw Exception('Gagal memuat data game');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Free to Play Games'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : dataGame.isEmpty
          ? const Center(
              child: Text('Tidak ada data atau gagal memuat internet.'),
            )
          : ListView.builder(
              itemCount: dataGame.length,
              itemBuilder: (context, index) {
                final game = dataGame[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Menampilkan Gambar Game dari URL (Thumbnail)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            game['thumbnail'] ?? '',
                            width: 100,
                            height: 70,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              // Widget cadangan jika gambar gagal dimuat
                              return Container(
                                width: 100,
                                height: 70,
                                color: Colors.grey[300],
                                child: const Icon(
                                  Icons.broken_image,
                                  color: Colors.grey,
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Informasi Teks Game (Judul, Genre, Tanggal Rilis)
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                game['title'] ?? 'Tanpa Judul',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Genre: ${game['genre'] ?? '-'}",
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Rilis: ${game['release_date'] ?? '-'}",
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
