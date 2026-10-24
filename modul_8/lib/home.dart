import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // Data game statis yang dimodifikasi dengan tambahan deskripsi
  final List<Map<String, String>> dataGame = const [
    {
      "title": "Overwatch 2",
      "genre": "Shooter",
      "desc": "Game hero shooter gratis dari Blizzard.",
    },
    {
      "title": "PUBG: BATTLEGROUNDS",
      "genre": "Shooter",
      "desc": "Game battle royale populer pelepas penat.",
    },
    {
      "title": "Fall Guys",
      "genre": "Battle Royale",
      "desc": "Game rintangan multiplayer yang sangat seru.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modul 8 - Named Route'),
        backgroundColor: Colors.teal,
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
              leading: const Icon(
                Icons.sports_esports,
                color: Colors.teal,
                size: 40,
              ),
              title: Text(
                dataGame[index]['title']!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(dataGame[index]['genre']!),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // Berpindah halaman menggunakan Named Route dan mengirim data
                Navigator.pushNamed(
                  context,
                  '/detail',
                  arguments: dataGame[index],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
