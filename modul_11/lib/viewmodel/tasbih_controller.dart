import 'package:get/get.dart';

class TasbihController extends GetxController {
  // Variabel reaktif (observable) menggunakan .obs
  var counter = 0.0.obs;
  var progress = 0.0.obs;
  final double maxCount = 33;

  // Method untuk menambah hitungan tasbih
  void incrementCounter() {
    if (counter < maxCount) {
      counter.value++;
      progress.value = (counter.value / maxCount) * 100;
    }
  }

  // Method untuk mereset hitungan kembali ke 0
  void resetCounter() {
    counter.value = 0.0;
    progress.value = 0.0;
  }
}
