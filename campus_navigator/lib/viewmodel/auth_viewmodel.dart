import '../model/user_model.dart';

class AuthViewModel {
  static final List<UserModel> dummyUsers = [
    UserModel(id: '1', nim: '220001', nama: 'Budi (Bendahara)', role: 'Admin'),
    UserModel(
      id: '2',
      nim: '220002',
      nama: 'Siti (Pengawas)',
      role: 'Pengawas',
    ),
    UserModel(
      id: '3',
      nim: '220003',
      nama: 'Andi (Mahasiswa)',
      role: 'Anggota',
    ),
  ];

  static UserModel? login(String nim, String role) {
    try {
      return dummyUsers.firstWhere(
        (user) => user.nim == nim && user.role == role,
      );
    } catch (_) {
      return null;
    }
  }
}
