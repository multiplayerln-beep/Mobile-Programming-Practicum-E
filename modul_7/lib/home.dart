import 'package:flutter/material.dart';

import 'detail.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // Data statis sederhana untuk contoh navigasi
  final List<Map<String, String>> dataGame = const [
    {"title": "Overwatch 2", "genre": "Shooter"},
    {"title": "PUBG: BATTLEGROUNDS", "genre": "Shooter"},
    {"title": "Fall Guys", "genre": "Battle Royale"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Game'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: dataGame.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              title: Text(
                dataGame[index]['title']!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(dataGame[index]['genre']!),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // Navigasi ke halaman detail dengan membawa argumen data
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailPage(
                      judul: dataGame[index]['title']!,
                      genre: dataGame[index]['genre']!,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
