class Game {
  final int id;
  final String title;
  final int originalPrice;
  final int discountPercent;
  final int finalPrice;
  final int historicalLow; // Variabel perbandingan all-time low
  final String endsIn;
  final String thumbnail;
  final String genre;
  final String sysReq;
  final List<String> os; // Variabel baru yang mengatasi error getter 'os'

  Game({
    required this.id,
    required this.title,
    required this.originalPrice,
    required this.discountPercent,
    required this.finalPrice,
    required this.historicalLow,
    required this.endsIn,
    required this.thumbnail,
    required this.genre,
    required this.sysReq,
    required this.os,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'],
      title: json['title'],
      originalPrice: json['original_price'],
      discountPercent: json['discount_percent'],
      finalPrice: json['final_price'],
      historicalLow: json['historical_low'],
      endsIn: json['ends_in'],
      thumbnail: json['thumbnail'],
      genre: json['genre'],
      sysReq: json['sys_req'],
      // Mengambil data Array/List dari JSON
      os: List<String>.from(json['os'] ?? []),
    );
  }
}
