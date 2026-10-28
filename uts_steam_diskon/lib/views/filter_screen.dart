import 'package:flutter/material.dart';

import '../models/game.dart';
import '../services/data_service.dart';
import 'detail_screen.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  final DataService _dataService = DataService();

  double _minDiscount = 0;
  String _sysReqSearch = "";
  final List<String> _selectedOS = [];

  final List<String> _availableOS = ["Windows", "macOS", "Linux", "SteamOS"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Deep Filter Pencarian')),
      body: Column(
        children: [
          // PANEL FILTER
          Container(
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).cardColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Filter Diskon (Slider)
                Text(
                  "Minimal Diskon: ${_minDiscount.toInt()}%",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Slider(
                  value: _minDiscount,
                  min: 0,
                  max: 90,
                  divisions: 9,
                  label: "${_minDiscount.toInt()}%",
                  activeColor: const Color.fromARGB(255, 41, 145, 248),
                  onChanged: (value) {
                    setState(() {
                      _minDiscount = value;
                    });
                  },
                ),

                // 2. Filter Spesifikasi (TextField)
                const Text(
                  "Cari Spesifikasi (Misal: 16 GB, GTX):",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextField(
                  decoration: InputDecoration(
                    hintText: "Ketik spesifikasi...",
                    filled: true,
                    fillColor: Colors.black26,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _sysReqSearch = value;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // 3. Filter OS (FilterChip)
                const Text(
                  "Kompatibilitas OS:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Wrap(
                  spacing: 8,
                  children: _availableOS.map((os) {
                    final isSelected = _selectedOS.contains(os);
                    return FilterChip(
                      label: Text(os),
                      selected: isSelected,
                      selectedColor: Colors.blueAccent.withOpacity(0.5),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedOS.add(os);
                          } else {
                            _selectedOS.remove(os);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          // HASIL FILTER
          Expanded(
            child: FutureBuilder<List<Game>>(
              future: _dataService.loadGames(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("Tidak ada data."));
                }

                // LOGIKA FILTERING
                List<Game> filteredGames = snapshot.data!.where((game) {
                  // A. Cek Diskon
                  bool matchDiscount = game.discountPercent >= _minDiscount;

                  // B. Cek Spek dengan Word Boundary
                  bool matchSys = true;
                  if (_sysReqSearch.trim().isNotEmpty) {
                    final query = RegExp.escape(
                      _sysReqSearch.trim().toLowerCase(),
                    );
                    // \b memastikan pencarian mendeteksi batas kata yang utuh
                    final regex = RegExp(r'\b' + query, caseSensitive: false);
                    matchSys = regex.hasMatch(game.sysReq.toLowerCase());
                  }

                  // C. Cek OS (Case-insensitive & Logika AND jika memilih lebih dari 1 OS)
                  bool matchOs = true;
                  if (_selectedOS.isNotEmpty) {
                    matchOs = _selectedOS.every((selected) {
                      return game.os.any(
                        (gameOs) =>
                            gameOs.toLowerCase() == selected.toLowerCase(),
                      );
                    });
                  }

                  return matchDiscount && matchSys && matchOs;
                }).toList();

                if (filteredGames.isEmpty) {
                  return const Center(
                    child: Text("Tidak ada game yang cocok dengan filter."),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: filteredGames.length,
                  itemBuilder: (context, index) {
                    final game = filteredGames[index];
                    return Card(
                      child: ListTile(
                        leading: Image.network(
                          game.thumbnail,
                          width: 80,
                          fit: BoxFit.cover,
                        ),
                        title: Text(game.title),
                        subtitle: Text(
                          "OS: ${game.os.join(', ')}\nSpek: ${game.sysReq}",
                        ),
                        trailing: Text(
                          "-${game.discountPercent}%",
                          style: const TextStyle(
                            color: Color(0xFFA4D007),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        isThreeLine: true,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailScreen(game: game),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
