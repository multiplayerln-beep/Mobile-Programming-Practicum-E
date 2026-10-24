import 'package:flutter/material.dart';

import '../viewmodel/auth_viewmodel.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _nimController = TextEditingController(text: '220001');
  String _selectedRole = 'Admin';

  void _handleLogin() {
    final user = AuthViewModel.login(_nimController.text, _selectedRole);
    if (user != null) {
      if (_selectedRole == 'Admin') {
        Navigator.pushReplacementNamed(context, '/admin/dashboard');
      } else if (_selectedRole == 'Pengawas') {
        Navigator.pushReplacementNamed(context, '/pengawas/dashboard');
      } else {
        Navigator.pushReplacementNamed(context, '/anggota/dashboard');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'NIM atau Role tidak cocok! Gunakan NIM 220001 (Admin), 220002 (Pengawas), atau 220003 (Anggota)',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.account_balance_wallet,
                size: 70,
                color: Colors.indigo,
              ),
              const SizedBox(height: 16),
              const Text(
                'Aplikasi Kas Kelas',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _nimController,
                decoration: const InputDecoration(
                  labelText: 'NIM Mahasiswa',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedRole,
                decoration: const InputDecoration(
                  labelText: 'Pilih Peran',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.badge),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'Admin',
                    child: Text('Bendahara (Admin)'),
                  ),
                  DropdownMenuItem(
                    value: 'Pengawas',
                    child: Text('Pengawas (Auditor)'),
                  ),
                  DropdownMenuItem(
                    value: 'Anggota',
                    child: Text('Mahasiswa (Anggota)'),
                  ),
                ],
                onChanged: (val) => setState(() => _selectedRole = val!),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _handleLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Masuk Aplikasi',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
