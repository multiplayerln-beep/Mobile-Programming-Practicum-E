import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

import '../model/detailgame.dart';
import '../viewmodel/fetchgame.dart';

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
            return SingleChildScrollView(
              child: Column(
                children: [
                  // Header Cover Image & Back Button
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
                            height: 300,
                            width: double.infinity,
                          ),
                        ),
                        Positioned(
                          top: 40,
                          left: 10,
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
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

                  // Content Body
                  Container(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // System Requirements Box
                        Container(
                          padding: const EdgeInsets.all(15),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Minimum System Requirements",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54.withOpacity(0.8),
                                ),
                              ),
                              const SizedBox(height: 10),
                              _requirementRow(
                                'OS',
                                game.minimum_system_requirements.os,
                              ),
                              _requirementRow(
                                'Processor',
                                game.minimum_system_requirements.processor,
                              ),
                              _requirementRow(
                                'Memory',
                                game.minimum_system_requirements.memory,
                              ),
                              _requirementRow(
                                'Graphics',
                                game.minimum_system_requirements.graphics,
                              ),
                              _requirementRow(
                                'Storage',
                                game.minimum_system_requirements.storage,
                              ),
                            ],
                          ),
                        ),

                        // Screenshots List
                        Container(
                          height: 150,
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: game.screenshots.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 15),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Image.network(
                                    game.screenshots[index].image,
                                    width: 250,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        // Description with ReadMore
                        Container(
                          padding: const EdgeInsets.all(5),
                          child: ReadMoreText(
                            game.description,
                            trimLines: 3,
                            colorClickableText: Colors.amberAccent.shade700,
                            trimMode: TrimMode.Line,
                            trimCollapsedText: 'more',
                            trimExpandedText: ' less',
                            style: TextStyle(
                              color: Colors.black54.withOpacity(0.8),
                              height: 1.5,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
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
}

Row _requirementRow(String title, String value) {
  return Row(
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
  );
}
