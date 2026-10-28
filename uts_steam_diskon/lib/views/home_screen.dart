import 'package:flutter/material.dart';

import '../models/game.dart';
import '../services/data_service.dart';
import 'detail_screen.dart';
import 'filter_screen.dart'; // Import halaman Deep Filter

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DataService _dataService = DataService();
  int _selectedIndex = 0;

  // Variabel Future untuk menampung data agar tidak dipanggil berulang kali
  late Future<List<Game>> _gamesFuture;

  @override
  void initState() {
    super.initState();
    // Memuat data JSON HANYA SATU KALI saat halaman pertama kali dibuka
    _gamesFuture = _dataService.loadGames();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Steam Deals',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder<List<Game>>(
        // Menggunakan variabel yang sudah diinisialisasi di initState
        future: _gamesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Tidak ada data promo."));
          }

          List<Game> allGames = snapshot.data!;
          // Filter dinamis: membandingkan harga final dengan rekor harga terendah
          List<Game> allTimeLowGames = allGames
              .where((g) => g.finalPrice <= g.historicalLow)
              .toList();

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "🔥 All-Time Low Deals",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 240,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: allTimeLowGames.length,
                    itemBuilder: (context, index) {
                      return _buildGameCard(allTimeLowGames[index]);
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "Semua Promo",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: allGames.length,
                  itemBuilder: (context, index) {
                    final game = allGames[index];
                    return ListTile(
                      leading: Image.network(
                        game.thumbnail,
                        width: 80,
                        fit: BoxFit.cover,
                      ),
                      title: Text(
                        game.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text("Diskon ${game.discountPercent}%"),
                      trailing: const Icon(Icons.chevron_right, size: 20),
                      onTap: () {
                        // Navigasi ke DetailScreen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailScreen(game: game),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        backgroundColor: const Color(0xFF171D25),
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          if (index == 1) {
            // Navigasi ke halaman Deep Filter
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FilterScreen()),
            ).then((_) {
              // Kembali ke Beranda saat tombol back ditekan dari FilterScreen
              setState(() {
                _selectedIndex = 0;
              });
            });
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Beranda"),
          BottomNavigationBarItem(
            icon: Icon(Icons.filter_alt),
            label: "Deep Filter",
          ),
        ],
      ),
    );
  }

  Widget _buildGameCard(Game game) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DetailScreen(game: game)),
        );
      },
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(left: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Image.network(
                game.thumbnail,
                height: 90,
                width: 160,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    game.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 4,
                        ),
                        color: const Color(0xFF4C6B22),
                        child: Text(
                          "-${game.discountPercent}%",
                          style: const TextStyle(
                            color: Color(0xFFA4D007),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Rp${game.finalPrice}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
