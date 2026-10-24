import 'package:flutter/material.dart';

import '../viewmodel/kas_viewmodel.dart';
import '../model/transaction_model.dart';

class AnggotaDashboardPage extends StatefulWidget {
  const AnggotaDashboardPage({super.key});

  @override
  State<AnggotaDashboardPage> createState() => _AnggotaDashboardPageState();
}

class _AnggotaDashboardPageState extends State<AnggotaDashboardPage> {
  // Widget Tab 1: Daftar Tagihan & Tombol Bayar
  Widget _buildTagihanList() {
    final tagihanList = KasViewModel.tagihanAktif;
    if (tagihanList.isEmpty) {
      return const Center(child: Text('Hore! Tidak ada tagihan kas saat ini.'));
    }
    return ListView.builder(
      itemCount: tagihanList.length,
      itemBuilder: (ctx, i) {
        final tg = tagihanList[i];

        // Cek apakah tagihan ini sudah pernah dibayar (ada di daftar transaksi)
        final riwayatPembayaran = KasViewModel.transactions
            .where((tx) => tx.kategori == 'Pembayaran: ${tg.namaTagihan}')
            .toList();

        bool isSudahDibayar = false;
        String labelTombol = 'Bayar Rp ${tg.nominal.toStringAsFixed(0)}';

        // Menentukan status tombol berdasarkan status verifikasi Pengawas
        if (riwayatPembayaran.isNotEmpty) {
          final tx =
              riwayatPembayaran.last; // ambil riwayat pembayaran terakhir
          if (tx.approvalStatus == 'Pending') {
            isSudahDibayar = true;
            labelTombol = 'Menunggu Verifikasi';
          } else if (tx.approvalStatus == 'Approved') {
            isSudahDibayar = true;
            labelTombol = 'Sudah Lunas';
          } else if (tx.approvalStatus == 'Rejected') {
            isSudahDibayar = false;
            labelTombol = 'Bayar Ulang';
          }
        }

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          elevation: 2,
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.amber,
              child: Icon(Icons.receipt_long, color: Colors.white),
            ),
            title: Text(
              tg.namaTagihan,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'Tenggat: ${tg.tglTenggat.day}/${tg.tglTenggat.month}/${tg.tglTenggat.year}',
            ),
            trailing: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isSudahDibayar ? Colors.grey : Colors.indigo,
                foregroundColor: Colors.white,
              ),
              // Jika isSudahDibayar true, onPressed diisi null agar tombol disable/mati
              onPressed: isSudahDibayar
                  ? null
                  : () {
                      setState(() {
                        KasViewModel.bayarTagihan(tg, 'Andi (Mahasiswa)');
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.green,
                          content: Text(
                            'Pembayaran ${tg.namaTagihan} berhasil diajukan! Menunggu persetujuan Pengawas.',
                          ),
                        ),
                      );
                    },
              child: Text(labelTombol),
            ),
          ),
        );
      },
    );
  }

  // Widget Tab 2 & 3: Riwayat Transaksi Publik
  Widget _buildTransactionList(List<TransactionModel> list) {
    if (list.isEmpty) {
      return const Center(child: Text('Belum ada riwayat di kategori ini.'));
    }
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (ctx, i) {
        final tx = list[i];
        final isPemasukan = tx.tipe == 'Pemasukan';
        return ListTile(
          leading: Icon(
            isPemasukan ? Icons.add_circle : Icons.remove_circle,
            color: isPemasukan ? Colors.green : Colors.red,
          ),
          title: Text(tx.kategori),
          subtitle: Text(
            '${tx.keterangan}\nTanggal: ${tx.tglTransaksi.day}/${tx.tglTransaksi.month}/${tx.tglTransaksi.year}',
          ),
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
    // Ambil data mutasi yang SUDAH DISETUJUI saja (Transparansi)
    final approvedList = KasViewModel.transactions
        .where((t) => t.approvalStatus == 'Approved')
        .toList();

    final approvedPemasukan = approvedList
        .where((t) => t.tipe == 'Pemasukan')
        .toList();
    final approvedPengeluaran = approvedList
        .where((t) => t.tipe == 'Pengeluaran')
        .toList();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Portal Anggota Kelas'),
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
            // Ringkasan Transparansi Kas
            Card(
              margin: const EdgeInsets.all(16),
              color: Colors.indigo.shade50,
              elevation: 0,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.indigo.shade200, width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Kas Kelas Saat Ini:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Rp ${KasViewModel.totalSaldo.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Tab Menu
            const TabBar(
              labelColor: Colors.indigo,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.indigo,
              isScrollable: true,
              tabs: [
                Tab(icon: Icon(Icons.payment), text: 'Bayar Iuran'),
                Tab(icon: Icon(Icons.arrow_downward), text: 'Riwayat Masuk'),
                Tab(icon: Icon(Icons.arrow_upward), text: 'Riwayat Keluar'),
              ],
            ),

            // Isi Tab
            Expanded(
              child: TabBarView(
                children: [
                  _buildTagihanList(), // Tab 1: Bayar Tagihan
                  _buildTransactionList(
                    approvedPemasukan,
                  ), // Tab 2: Transparansi Pemasukan
                  _buildTransactionList(
                    approvedPengeluaran,
                  ), // Tab 3: Transparansi Pengeluaran
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
