import 'package:flutter/material.dart';

import '../viewmodel/kas_viewmodel.dart';
import '../model/transaction_model.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  void _showFormTransaksi({TransactionModel? existingTx}) {
    final bool isEdit = existingTx != null;
    final kategoriCtrl = TextEditingController(
      text: isEdit ? existingTx.kategori : '',
    );
    final nominalCtrl = TextEditingController(
      text: isEdit ? existingTx.nominal.toStringAsFixed(0) : '',
    );
    final ketCtrl = TextEditingController(
      text: isEdit ? existingTx.keterangan : '',
    );
    String tipe = isEdit ? existingTx.tipe : 'Pemasukan';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
            top: 16,
            left: 16,
            right: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                isEdit ? 'Edit Transaksi Kas' : 'Tambah Transaksi Kas',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: tipe,
                items: const [
                  DropdownMenuItem(
                    value: 'Pemasukan',
                    child: Text('Pemasukan'),
                  ),
                  DropdownMenuItem(
                    value: 'Pengeluaran',
                    child: Text('Pengeluaran'),
                  ),
                ],
                onChanged: (val) {
                  if (val != null) {
                    setModalState(() => tipe = val);
                  }
                },
                decoration: const InputDecoration(labelText: 'Tipe Transaksi'),
              ),
              TextField(
                controller: kategoriCtrl,
                decoration: const InputDecoration(
                  labelText: 'Kategori (e.g. Fotokopi, Iuran)',
                ),
              ),
              TextField(
                controller: nominalCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Nominal (Rp)'),
              ),
              TextField(
                controller: ketCtrl,
                decoration: const InputDecoration(labelText: 'Keterangan'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (nominalCtrl.text.isNotEmpty &&
                      double.tryParse(nominalCtrl.text) != null) {
                    setState(() {
                      if (isEdit) {
                        KasViewModel.editTransaction(
                          existingTx.id,
                          kategoriCtrl.text.isEmpty
                              ? 'Umum'
                              : kategoriCtrl.text,
                          double.parse(nominalCtrl.text),
                          ketCtrl.text,
                          tipe,
                        );
                      } else {
                        KasViewModel.addTransaction(
                          TransactionModel(
                            id: 'TX${DateTime.now().millisecondsSinceEpoch}',
                            tipe: tipe,
                            kategori: kategoriCtrl.text.isEmpty
                                ? 'Umum'
                                : kategoriCtrl.text,
                            nominal: double.parse(nominalCtrl.text),
                            keterangan: ketCtrl.text,
                            tglTransaksi: DateTime.now(),
                            // SESUDAH (Semua transaksi baru berstatus Pending agar masuk ke Pengawas):
                            approvalStatus: 'Pending',
                          ),
                        );
                      }
                    });
                    Navigator.pop(ctx);
                  }
                },
                child: Text(isEdit ? 'Simpan Perubahan' : 'Tambah Transaksi'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDelete(String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Transaksi'),
        content: const Text('Apakah Anda yakin ingin menghapus transaksi ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              bool isDeleted = KasViewModel.deleteTransactionWithProtection(id);
              Navigator.pop(ctx);

              if (!isDeleted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: Colors.red,
                    content: Text(
                      'Transaksi tidak dapat dihapus karena dana pemasukan sudah tercatat lunas di saldo kas!',
                    ),
                  ),
                );
              } else {
                setState(() {});
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: Colors.green,
                    content: Text('Transaksi berhasil dihapus.'),
                  ),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionList(List<TransactionModel> list) {
    if (list.isEmpty) {
      return const Center(child: Text('Belum ada transaksi di kategori ini.'));
    }
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (ctx, i) {
        final tx = list[i];
        final isPemasukan = tx.tipe == 'Pemasukan';
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: isPemasukan
                ? Colors.green.shade100
                : Colors.red.shade100,
            child: Icon(
              isPemasukan ? Icons.arrow_downward : Icons.arrow_upward,
              color: isPemasukan ? Colors.green : Colors.red,
            ),
          ),
          title: Text(tx.kategori),
          subtitle: Text(
            '${tx.keterangan}\n'
            'Tanggal: ${tx.tglTransaksi.day}/${tx.tglTransaksi.month}/${tx.tglTransaksi.year}\n'
            'Status: ${tx.approvalStatus}',
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Rp ${tx.nominal.toStringAsFixed(0)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isPemasukan ? Colors.green : Colors.red,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
                onPressed: () => _showFormTransaksi(existingTx: tx),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                onPressed: () => _confirmDelete(tx.id),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final listPemasukan = KasViewModel.transactions
        .where((t) => t.tipe == 'Pemasukan')
        .toList();
    final listPengeluaran = KasViewModel.transactions
        .where((t) => t.tipe == 'Pengeluaran')
        .toList();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Dashboard Bendahara'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, '/login'),
            ),
          ],
        ),
        body: Column(
          children: [
            // Ringkasan Total Saldo
            Card(
              margin: const EdgeInsets.all(16),
              color: Colors.indigo,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Text(
                      'Total Saldo Kas',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    Text(
                      'Rp ${KasViewModel.totalSaldo.toStringAsFixed(0)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(color: Colors.white24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'Masuk: Rp ${KasViewModel.totalPemasukan.toStringAsFixed(0)}',
                          style: const TextStyle(color: Colors.greenAccent),
                        ),
                        Text(
                          'Keluar: Rp ${KasViewModel.totalPengeluaran.toStringAsFixed(0)}',
                          style: const TextStyle(color: Colors.redAccent),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Tab Bar Pemasukan & Pengeluaran
            const TabBar(
              labelColor: Colors.indigo,
              indicatorColor: Colors.indigo,
              tabs: [
                Tab(icon: Icon(Icons.download_sharp), text: 'Pemasukan'),
                Tab(icon: Icon(Icons.upload_sharp), text: 'Pengeluaran'),
              ],
            ),
            // Isi Konten Per Tab
            Expanded(
              child: TabBarView(
                children: [
                  _buildTransactionList(listPemasukan),
                  _buildTransactionList(listPengeluaran),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showFormTransaksi(),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
