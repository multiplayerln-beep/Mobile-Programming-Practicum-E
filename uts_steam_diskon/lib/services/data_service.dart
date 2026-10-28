import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/game.dart';

class DataService {
  Future<List<Game>> loadGames() async {
    // Membaca file JSON dari direktori assets lokal
    String jsonString = await rootBundle.loadString('assets/data/games.json');
    // Menerjemahkan teks JSON menjadi List dinamis
    List<dynamic> jsonResponse = jsonDecode(jsonString);
    // Mengubah List dinamis menjadi List<Game> menggunakan model
    return jsonResponse.map((data) => Game.fromJson(data)).toList();
  }
}
