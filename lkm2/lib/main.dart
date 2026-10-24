import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class Mahasiswa {
  String nim;
  String nama;
  String prodi;

  Mahasiswa({required this.nim, required this.nama, required this.prodi});
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Collection Flutter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const MahasiswaPage(),
    );
  }
}

class MahasiswaPage extends StatefulWidget {
  const MahasiswaPage({super.key});

  @override
  State<MahasiswaPage> createState() => _MahasiswaPageState();
}

class _MahasiswaPageState extends State<MahasiswaPage> {
  final List<Mahasiswa> _dataMahasiswa = [
    Mahasiswa(
      nim: '23010001',
      nama: 'Ahmad Fauzi',
      prodi: 'Teknik Informatika',
    ),
    Mahasiswa(
      nim: '23010002',
      nama: 'Budi Santoso',
      prodi: 'Teknik Informatika',
    ),
    Mahasiswa(
      nim: '23010003',
      nama: 'Citra Lestari',
      prodi: 'Teknik Informatika',
    ),
  ];

  String _keyword = '';

  List<Mahasiswa> get _dataTampil {
    if (_keyword.isEmpty) return _dataMahasiswa;
    final keyword = _keyword.toLowerCase();
    return _dataMahasiswa.where((mahasiswa) {
      return mahasiswa.nama.toLowerCase().contains(keyword) ||
          mahasiswa.nim.toLowerCase().contains(keyword) ||
          mahasiswa.prodi.toLowerCase().contains(keyword);
    }).toList();
  }

  void _tambahData() => _showFormDialog();

  void _editData(Mahasiswa mahasiswa) => _showFormDialog(mahasiswa: mahasiswa);

  void _hapusData(Mahasiswa mahasiswa) {
    setState(() => _dataMahasiswa.remove(mahasiswa));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${mahasiswa.nama} berhasil dihapus')),
    );
  }

  void _urutkanData() {
    setState(() {
      _dataMahasiswa.sort((a, b) => a.nama.compareTo(b.nama));
    });
  }

  void _showFormDialog({Mahasiswa? mahasiswa}) {
    final nimController = TextEditingController(text: mahasiswa?.nim ?? '');
    final namaController = TextEditingController(text: mahasiswa?.nama ?? '');
    final prodiController = TextEditingController(text: mahasiswa?.prodi ?? '');
    final bool isEdit = mahasiswa != null;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(isEdit ? 'Edit Mahasiswa' : 'Tambah Mahasiswa'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nimController,
                  decoration: const InputDecoration(
                    labelText: 'NIM',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: namaController,
                  decoration: const InputDecoration(
                    labelText: 'Nama',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: prodiController,
                  decoration: const InputDecoration(
                    labelText: 'Program Studi',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () {
                final nim = nimController.text.trim();
                final nama = namaController.text.trim();
                final prodi = prodiController.text.trim();
                if (nim.isEmpty || nama.isEmpty || prodi.isEmpty) return;

                setState(() {
                  if (isEdit) {
                    mahasiswa.nim = nim;
                    mahasiswa.nama = nama;
                    mahasiswa.prodi = prodi;
                  } else {
                    _dataMahasiswa.add(
                      Mahasiswa(nim: nim, nama: nama, prodi: prodi),
                    );
                  }
                });
                Navigator.pop(dialogContext);
              },
              child: Text(isEdit ? 'Update' : 'Simpan'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _konfirmasiHapus(Mahasiswa mahasiswa) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Konfirmasi'),
          content: Text('Hapus data ${mahasiswa.nama}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Tidak'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Ya'),
            ),
          ],
        );
      },
    );
    if (result == true && mounted) _hapusData(mahasiswa);
  }

  @override
  Widget build(BuildContext context) {
    final data = _dataTampil;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Mahasiswa'),
        actions: [
          IconButton(
            tooltip: 'Urutkan Nama',
            onPressed: _urutkanData,
            icon: const Icon(Icons.sort_by_alpha),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _tambahData,
        icon: const Icon(Icons.add),
        label: const Text('Tambah'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Cari mahasiswa',
                hintText: 'Cari berdasarkan NIM, nama, atau prodi',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() => _keyword = value);
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text(
                  'Jumlah data: ${data.length}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: data.isEmpty
                  ? const Center(child: Text('Data tidak ditemukan'))
                  : ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final mahasiswa = data[index];
                        return Card(
                          child: ListTile(
                            leading: CircleAvatar(child: Text('${index + 1}')),
                            title: Text(mahasiswa.nama),
                            subtitle: Text(
                              '${mahasiswa.nim}\n${mahasiswa.prodi}',
                            ),
                            isThreeLine: true,
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  tooltip: 'Edit',
                                  onPressed: () => _editData(mahasiswa),
                                  icon: const Icon(Icons.edit),
                                ),
                                IconButton(
                                  tooltip: 'Hapus',
                                  onPressed: () => _konfirmasiHapus(mahasiswa),
                                  icon: const Icon(Icons.delete),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
