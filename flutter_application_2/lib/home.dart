import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'screen_arguments.dart';
import 'tujuan.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  var title, thumbnail, short_description, description;
  var genre, platform, release, cover, gameid, publisher;

  Future<void> getGame(String gameid) async {
    try {
      final response = await http.get(
        Uri.parse('https://www.freetogame.com/api/game?id=$gameid'),
      );

      if (response.statusCode == 200) {
        var results = jsonDecode(response.body);
        setState(() {
          this.gameid = gameid;
          title = results['title'];
          thumbnail = results['thumbnail'];
          short_description = results['short_description'];
          description = results['description'];
          genre = results['genre'];
          platform = results['platform'];
          publisher = results['publisher'];
          release = results['release_date'];
          cover = results['screenshots'][0]['image'];
        });
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    getGame('475'); // Mengambil game default ID 475 (Forza Motorsport 6: Apex)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0081C9),
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: const Color(0xFF0081C9),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Center(
          child: gameid == null
              ? const CircularProgressIndicator(color: Colors.white)
              : SingleChildScrollView(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        Tujuan.routeName,
                        arguments: ScreenArguments(
                          cover,
                          title,
                          description,
                          short_description,
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      margin: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(thumbnail ?? ''),
                          ),
                          const SizedBox(height: 15),
                          Text(
                            title ?? '',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Genre: $genre"),
                                  Text("Platform: $platform"),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Publisher: $publisher"),
                                  Text("Release: $release"),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Ketuk untuk melihat detail...",
                            style: TextStyle(
                              color: Colors.blue,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
