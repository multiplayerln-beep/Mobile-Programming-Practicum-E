import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../viewmodel/tasbih_controller.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    // Menghubungkan halaman Home dengan TasbihController
    final TasbihController controller = Get.put(TasbihController());

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 245, 245),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Widget angka dibungkus Obx agar otomatis update
              Obx(
                () => Text(
                  '${controller.counter.value.round()}',
                  style: const TextStyle(fontSize: 250),
                ),
              ),

              // Widget Progress Bar dibungkus Obx agar otomatis update
              Obx(
                () => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: LinearProgressIndicator(
                    value: controller.progress.value / 100,
                    backgroundColor: const Color.fromARGB(255, 134, 134, 134),
                    color: const Color.fromARGB(255, 81, 80, 80),
                    minHeight: 15,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 75),

              // Tombol Tambah Hitungan (Fingerprint)
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(50)),
                child: InkWell(
                  onTap: controller
                      .incrementCounter, // Memanggil fungsi di controller
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 230, 202, 202),
                    ),
                    padding: const EdgeInsets.all(30),
                    child: const Icon(Icons.fingerprint, size: 100),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // Tombol Reset di pojok kanan bawah
      floatingActionButton: FloatingActionButton(
        onPressed: controller.resetCounter, // Memanggil fungsi di controller
        backgroundColor: const Color.fromARGB(255, 244, 219, 219),
        child: const Icon(Icons.refresh_outlined, color: Colors.black),
      ),
    );
  }
}
