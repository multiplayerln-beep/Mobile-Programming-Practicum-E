import 'package:flutter/material.dart';

import 'view/login_page.dart';
import 'view/admin_dashboard.dart';
import 'view/pengawas_dashboard.dart';
import 'view/anggota_dashboard.dart';

void main() {
  runApp(const KasKelasApp());
}

class KasKelasApp extends StatelessWidget {
  const KasKelasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aplikasi Kas Kelas',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/admin/dashboard': (context) => const AdminDashboardPage(),
        '/pengawas/dashboard': (context) => const PengawasDashboardPage(),
        '/anggota/dashboard': (context) => const AnggotaDashboardPage(),
      },
    );
  }
}
