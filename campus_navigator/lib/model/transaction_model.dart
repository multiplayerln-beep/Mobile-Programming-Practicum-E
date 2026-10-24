class TransactionModel {
  final String id;
  final String tipe; // 'Pemasukan' atau 'Pengeluaran'
  final String kategori;
  final double nominal;
  final String keterangan;
  final DateTime tglTransaksi;
  String approvalStatus; // 'Pending', 'Approved', 'Rejected'

  TransactionModel({
    required this.id,
    required this.tipe,
    required this.kategori,
    required this.nominal,
    required this.keterangan,
    required this.tglTransaksi,
    this.approvalStatus = 'Pending',
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      tipe: json['tipe'],
      kategori: json['kategori'],
      nominal: (json['nominal'] as num).toDouble(),
      keterangan: json['keterangan'],
      tglTransaksi: DateTime.parse(json['tgl_transaksi']),
      approvalStatus: json['approval_status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tipe': tipe,
      'kategori': kategori,
      'nominal': nominal,
      'keterangan': keterangan,
      'tgl_transaksi': tglTransaksi.toIso8601String(),
      'approval_status': approvalStatus,
    };
  }
}
