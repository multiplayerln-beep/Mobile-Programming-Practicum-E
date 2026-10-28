# 📱 Praktikum Pemrograman Mobile

Repositori ini berisi seluruh kumpulan tugas praktikum modul serta **Proyek Tugas Tengah Semester (UTS)** untuk mata kuliah Pemrograman Mobile.

---

## 🎮 Proyek Utama UTS: Steam Deals Tracker (`/uts_steam_diskon`)

Aplikasi mobile berbasis **Flutter** yang berfungsi untuk melacak diskon game platform Steam, membandingkan rekor harga terendah historis (*All-Time Low*), serta menyediakan fitur pencarian spesifikasi dan kompatibilitas OS secara dinamis.

### 🌟 Fitur Utama Aplikasi
1. **🔥 All-Time Low Deals:** Menyaring dan menampilkan game secara otomatis jika harga promo saat ini lebih rendah atau sama dengan rekor harga historisnya (`final_price <= historical_low`).
2. **🔍 Deep Filter Pencarian:**
   - **Slider Diskon:** Filter persentase minimal diskon (0% - 90%).
   - **Filter Spesifikasi:** Pencarian teks presisi tinggi menggunakan *Word Boundary RegEx* (mencari `"2 GB"` tanpa tertukar dengan `"12 GB"`).
   - **Kompatibilitas OS:** Filter multi-OS *case-insensitive* dengan logika pencocokan ketat (*AND*).
3. **📱 Detail Screen & Passing Data:** Menampilkan detail spesifikasi, genre, harga, dan syarat sistem minimum dengan mentransfer objek data secara dinamis menggunakan `Navigator.push`.

---

## 📁 Struktur Repositori

```text
.
├── modul_1/ ... modul_9/  # Latihan & Tugas Modul Mingguan
└── uts_steam_diskon/      # Proyek Utama UTS (Steam Deals Tracker)
    ├── assets/data/       # Database Lokal (games.json)
    └── lib/
        ├── models/        # Model Data (game.dart)
        ├── services/      # Service Pembaca Data (data_service.dart)
        └── views/         # UI Screen (home_screen, detail_screen, filter_screen)
