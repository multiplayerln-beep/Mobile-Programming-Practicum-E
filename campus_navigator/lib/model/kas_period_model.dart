class KasPeriodModel {
  final String id;
  final String namaTagihan;
  final double nominal;
  final DateTime tglTenggat;

  KasPeriodModel({
    required this.id,
    required this.namaTagihan,
    required this.nominal,
    required this.tglTenggat,
  });

  factory KasPeriodModel.fromJson(Map<String, dynamic> json) {
    return KasPeriodModel(
      id: json['id'],
      namaTagihan: json['nama_tagihan'],
      nominal: (json['nominal'] as num).toDouble(),
      tglTenggat: DateTime.parse(json['tgl_tenggat']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_tagihan': namaTagihan,
      'nominal': nominal,
      'tgl_tenggat': tglTenggat.toIso8601String(),
    };
  }
}
