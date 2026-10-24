import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/detailgame.dart';
import 'package:flutter_application_1/viewmodel/fetchgame.dart';
import 'package:readmore/readmore.dart';

class Detail extends StatelessWidget {
  final int gameTerpilih;

  const Detail({super.key, required this.gameTerpilih});

  Future<DetailGame> fetchData() async {
    final jsonData = await fetchDataFromAPI(gameTerpilih);
    return DetailGame.fromJson(jsonData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amberAccent.shade400,
      body: FutureBuilder<DetailGame>(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Data tidak tersedia'));
          } else {
            final game = snapshot.data!;
            return SafeArea(
              child: Column(
                children: [
                  // Header Image dengan tombol Back
                  SizedBox(
                    width: double.infinity,
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(25),
                            bottomRight: Radius.circular(25),
                          ),
                          child: Image.network(
                            game.thumbnail,
                            fit: BoxFit.cover,
                            height: 250,
                            width: double.infinity,
                          ),
                        ),
                        Positioned(
                          top: 15,
                          left: 10,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.8),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.arrow_back_ios_outlined,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Konten Detail
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // System Requirements
                              const Text(
                                "Minimum System Requirements",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 8),
                              _requirementRow(
                                "OS",
                                game.minimumSystemRequirements.os,
                              ),
                              _requirementRow(
                                "Processor",
                                game.minimumSystemRequirements.processor,
                              ),
                              _requirementRow(
                                "Memory",
                                game.minimumSystemRequirements.memory,
                              ),
                              _requirementRow(
                                "Graphics",
                                game.minimumSystemRequirements.graphics,
                              ),
                              _requirementRow(
                                "Storage",
                                game.minimumSystemRequirements.storage,
                              ),
                              const SizedBox(height: 15),

                              // Screenshots Horizontal ListView
                              if (game.screenshots.isNotEmpty)
                                Container(
                                  height: 150,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  child: ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: game.screenshots.length,
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(width: 15),
                                    itemBuilder: (context, index) {
                                      return _itemList(
                                        game.screenshots[index].image,
                                      );
                                    },
                                  ),
                                ),
                              const SizedBox(height: 10),

                              // Description ReadMoreText
                              Container(
                                padding: const EdgeInsets.all(5),
                                child: ReadMoreText(
                                  game.description,
                                  trimLines: 3,
                                  colorClickableText:
                                      Colors.amberAccent.shade700,
                                  trimMode: TrimMode.Line,
                                  style: TextStyle(
                                    color: Colors.black54.withOpacity(0.8),
                                    height: 1.5,
                                  ),
                                  trimCollapsedText: 'more',
                                  trimExpandedText: 'less',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _itemList(String url) {
    return SizedBox(
      width: 220,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Image.network(url, fit: BoxFit.cover),
      ),
    );
  }

  Widget _requirementRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              title,
              style: TextStyle(color: Colors.black54.withOpacity(0.8)),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              ':',
              style: TextStyle(color: Colors.black54.withOpacity(0.8)),
            ),
          ),
          Expanded(
            flex: 8,
            child: Text(
              value,
              style: TextStyle(color: Colors.black54.withOpacity(0.8)),
            ),
          ),
        ],
      ),
    );
  }
}
