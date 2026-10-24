import 'package:flutter/material.dart';

import 'screen_arguments.dart';

class Tujuan extends StatelessWidget {
  const Tujuan({super.key});

  static const routeName = '/extractArguments';

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;

    return Scaffold(
      backgroundColor: const Color(0xFFF94A29),
      appBar: AppBar(
        title: const Text('Halaman Detail Game'),
        backgroundColor: const Color(0xFFF94A29),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: double.maxFinite,
            margin: const EdgeInsets.all(15),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: const Color(0xFFF4F8FB),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(args.cover, fit: BoxFit.cover),
                ),
                const SizedBox(height: 15),
                Text(
                  args.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 47, 72),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  args.description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color.fromARGB(255, 0, 47, 72),
                  ),
                ),
                const SizedBox(height: 25),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF0081C9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 15,
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.arrow_back_ios_outlined,
                            size: 15,
                            color: Color(0xFFF4F8FB),
                          ),
                          SizedBox(width: 5),
                          Text(
                            'Kembali ke game',
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFFF4F8FB),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
