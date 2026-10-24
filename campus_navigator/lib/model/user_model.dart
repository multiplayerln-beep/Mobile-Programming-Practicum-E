class UserModel {
  final String id;
  final String nim;
  final String nama;
  final String role; // 'Admin', 'Pengawas', 'Anggota'

  UserModel({
    required this.id,
    required this.nim,
    required this.nama,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      nim: json['nim'],
      nama: json['nama'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'nim': nim, 'nama': nama, 'role': role};
  }
}
