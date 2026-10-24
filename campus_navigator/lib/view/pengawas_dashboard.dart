import 'package:flutter/material.dart';

import '../viewmodel/kas_viewmodel.dart';
import '../model/transaction_model.dart';

class PengawasDashboardPage extends StatefulWidget {
  const PengawasDashboardPage({super.key});

  @override
  State<PengawasDashboardPage> createState() => _PengawasDashboardPageState();
}

class _PengawasDashboardPageState extends State<PengawasDashboardPage> {
  // Widget Builder untuk Daftar Transaksi (Pemasukan / Pengeluaran)
  Widget _buildTransactionList(List<TransactionModel> list) {
    if (list.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('Belum ada transaksi di kategori ini.'),
        ),
      );
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
          subtitle: Text('${tx.keterangan}\nStatus: ${tx.approvalStatus}'),
          trailing: Text(
            'Rp ${tx.nominal.toStringAsFixed(0)}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isPemasukan ? Colors.green : Colors.red,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Filter List berdasarkan Kategori & Status
    final pendingList = KasViewModel.transactions
        .where((t) => t.approvalStatus == 'Pending')
        .toList();

    final listPemasukan = KasViewModel.transactions
        .where((t) => t.tipe == 'Pemasukan')
        .toList();

    final listPengeluaran = KasViewModel.transactions
        .where((t) => t.tipe == 'Pengeluaran')
        .toList();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Dashboard Pengawas'),
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
            // Card Overview Total Saldo & Ringkasan Keuangan Kas
            Card(
              margin: const EdgeInsets.all(16),
              color: Colors.indigo,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Total Saldo Terverifikasi',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    Text(
                      'Rp ${KasViewModel.totalSaldo.toStringAsFixed(0)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(color: Colors.white24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'Masuk: Rp ${KasViewModel.totalPemasukan.toStringAsFixed(0)}',
                          style: const TextStyle(
                            color: Colors.greenAccent,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          'Keluar: Rp ${KasViewModel.totalPengeluaran.toStringAsFixed(0)}',
                          style: const TextStyle(
                            color: Colors.redAccent,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Tab Navigation 3 Kategori
            const TabBar(
              labelColor: Colors.indigo,
              indicatorColor: Colors.indigo,
              tabs: [
                Tab(icon: Icon(Icons.fact_check), text: 'Verifikasi'),
                Tab(icon: Icon(Icons.download_sharp), text: 'Pemasukan'),
                Tab(icon: Icon(Icons.upload_sharp), text: 'Pengeluaran'),
              ],
            ),

            // Konten Isi Setiap Tab
            Expanded(
              child: TabBarView(
                children: [
                  // Tab 1: Khusus Verifikasi / Approval
                  Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        color: Colors.amber.shade100,
                        child: Text(
                          'Transaksi Menunggu Verifikasi: ${pendingList.length}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: pendingList.isEmpty
                            ? const Center(
                                child: Text(
                                  'Tidak ada pengajuan transaksi yang perlu diverifikasi.',
                                ),
                              )
                            : ListView.builder(
                                itemCount: pendingList.length,
                                itemBuilder: (ctx, i) {
                                  final tx = pendingList[i];
                                  return Card(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    child: ListTile(
                                      title: Text(
                                        '${tx.kategori} - Rp ${tx.nominal.toStringAsFixed(0)}',
                                      ),
                                      subtitle: Text(
                                        'Keterangan: ${tx.keterangan}\n(Oleh Bendahara)',
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: const Icon(
                                              Icons.check_circle,
                                              color: Colors.green,
                                              size: 28,
                                            ),
                                            tooltip: 'Setujui (Approve)',
                                            onPressed: () {
                                              setState(() {
                                                KasViewModel.updateStatus(
                                                  tx.id,
                                                  'Approved',
                                                );
                                              });
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                        'Transaksi disetujui!',
                                                      ),
                                                    ),
                                                  );
                                            },
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.cancel,
                                              color: Colors.red,
                                              size: 28,
                                            ),
                                            tooltip: 'Tolak (Reject)',
                                            onPressed: () {
                                              setState(() {
                                                KasViewModel.updateStatus(
                                                  tx.id,
                                                  'Rejected',
                                                );
                                              });
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                        'Transaksi ditolak!',
                                                      ),
                                                    ),
                                                  );
                                            },
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

                  // Tab 2: Semua Riwayat Pemasukan
                  _buildTransactionList(listPemasukan),

                  // Tab 3: Semua Riwayat Pengeluaran
                  _buildTransactionList(listPengeluaran),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
