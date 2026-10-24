import '../model/transaction_model.dart';
import '../model/kas_period_model.dart'; // Import model Tagihan

class KasViewModel {
  // 1. DATA TRANSAKSI UTAMA
  static final List<TransactionModel> transactions = [
    TransactionModel(
      id: 'TX01',
      tipe: 'Pemasukan',
      kategori: 'Iuran Kas',
      nominal: 150000,
      keterangan: 'Iuran Kas Minggu 1',
      tglTransaksi: DateTime.now().subtract(const Duration(days: 3)),
      approvalStatus: 'Approved',
    ),
  ];

  // 2. DATA TAGIHAN AKTIF (YANG DISET OLEH BENDAHARA)
  static final List<KasPeriodModel> tagihanAktif = [
    KasPeriodModel(
      id: 'TG01',
      namaTagihan: 'Iuran Kas Kelas (Bulan Oktober)',
      nominal: 20000,
      tglTenggat: DateTime.now().add(const Duration(days: 7)),
    ),
    KasPeriodModel(
      id: 'TG02',
      namaTagihan: 'Dana Patungan Beli Spidol & Penghapus',
      nominal: 5000,
      tglTenggat: DateTime.now().add(const Duration(days: 3)),
    ),
  ];

  // 3. LOGIKA KEUANGAN
  static double get totalPemasukan => transactions
      .where((t) => t.tipe == 'Pemasukan' && t.approvalStatus == 'Approved')
      .fold(0, (sum, t) => sum + t.nominal);

  static double get totalPengeluaran => transactions
      .where((t) => t.tipe == 'Pengeluaran' && t.approvalStatus == 'Approved')
      .fold(0, (sum, t) => sum + t.nominal);

  static double get totalSaldo => totalPemasukan - totalPengeluaran;

  // 4. FUNGSI CRUD TRANSAKSI
  static void addTransaction(TransactionModel transaction) {
    transactions.add(transaction);
  }

  static void updateStatus(String id, String newStatus) {
    final index = transactions.indexWhere((t) => t.id == id);
    if (index != -1) transactions[index].approvalStatus = newStatus;
  }

  static void editTransaction(
    String id,
    String kategori,
    double nominal,
    String keterangan,
    String tipe,
  ) {
    final index = transactions.indexWhere((t) => t.id == id);
    if (index != -1) {
      final oldTx = transactions[index];
      transactions[index] = TransactionModel(
        id: oldTx.id,
        tipe: tipe,
        kategori: kategori,
        nominal: nominal,
        keterangan: keterangan,
        tglTransaksi: oldTx.tglTransaksi,
        approvalStatus: 'Pending', // Selalu kembali ke Pending kalau diedit
      );
    }
  }

  static bool deleteTransactionWithProtection(String id) {
    final index = transactions.indexWhere((t) => t.id == id);
    if (index != -1) {
      if (transactions[index].tipe == 'Pemasukan' &&
          transactions[index].approvalStatus == 'Approved') {
        return false;
      }
      transactions.removeAt(index);
      return true;
    }
    return false;
  }

  // --- FITUR BARU: ANGGOTA KLIK BAYAR TAGIHAN ---
  static void bayarTagihan(KasPeriodModel tagihan, String namaMahasiswa) {
    // 1. Buat transaksi baru dengan status 'Pending' untuk diverifikasi Pengawas
    addTransaction(
      TransactionModel(
        id: 'TX${DateTime.now().millisecondsSinceEpoch}',
        tipe: 'Pemasukan',
        kategori: 'Pembayaran: ${tagihan.namaTagihan}',
        nominal: tagihan.nominal,
        keterangan: 'Dibayar oleh: $namaMahasiswa',
        tglTransaksi: DateTime.now(),
        approvalStatus: 'Pending', // Menunggu ACC pengawas
      ),
    );

    // 2. (Opsional) Hapus tagihan dari daftar jika sudah dibayar
    // tagihanAktif.removeWhere((t) => t.id == tagihan.id);
  }
}
