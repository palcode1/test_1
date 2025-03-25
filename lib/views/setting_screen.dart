import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test_1/services/firebase_auth_services/firebase_auth_services.dart';
import 'package:test_1/views/login_screen.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final AuthService authService = AuthService();

  void signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFB1F0F7), Color(0xFF81BFDA)],
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 40), // Memberi jarak dari atas
            Container(
              padding: const EdgeInsets.all(
                16,
              ), // Padding dalam container header
              decoration: BoxDecoration(
                color: Colors.yellow[100], // Warna latar header
                borderRadius: BorderRadius.circular(
                  10,
                ), // Membuat sudut melengkung
              ),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/cog.png',
                    width: 30,
                    height: 30,
                  ), // Ikon pengaturan
                  const SizedBox(width: 10), // Jarak antara ikon dan teks
                  const Text(
                    'Pengaturan', // Judul header
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ), // Penutup Container header
            const SizedBox(height: 20), // Jarak antara header dan daftar menu
            _buildSettingItem(
              'assets/images/user.png',
              'Edit Profile',
            ), // Menu Edit Profile
            _buildSettingItem(
              'assets/images/password.png',
              'Ubah Password',
            ), // Menu Ubah Password
            _buildSettingItem(
              'assets/images/notification.png',
              'Notifikasi',
            ), // Menu Notifikasi
            _buildSettingItem(
              'assets/images/translate.png',
              'Bahasa',
            ), // Menu Bahasa
            _buildSettingItem(
              'assets/images/support.png',
              'Pusat Bantuan',
            ), // Menu Pusat Bantuan
            _buildSettingItem(
              'assets/images/power.png',
              'Keluar',
              onTap: signOut,
            ), // Menu Keluar
          ], // Penutup children pada Column utama
        ), // Penutup Column utama
      ),
    );
  }

  Widget _buildSettingItem(
    String imagePath,
    String title, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 6,
        ), // Jarak antar item menu
        child: Container(
          padding: const EdgeInsets.all(
            16,
          ), // Padding dalam container item menu
          decoration: BoxDecoration(
            color: Colors.yellow[100], // Warna latar item menu
            borderRadius: BorderRadius.circular(10), // Membuat sudut melengkung
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2), // Warna bayangan
                spreadRadius: 2, // Sebaran bayangan
                blurRadius: 5, // Blur bayangan
                offset: const Offset(3, 3), // Posisi bayangan
              ),
            ], // Penutup BoxShadow
          ), // Penutup BoxDecoration
          child: Row(
            children: [
              Image.asset(
                imagePath,
                width: 30,
                height: 30,
              ), // Menampilkan ikon dari assets
              const SizedBox(width: 10), // Jarak antara ikon dan teks
              Text(
                title, // Judul menu
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ), // Penutup Text
            ], // Penutup children Row
          ), // Penutup Row
        ), // Penutup Container
      ),
    ); // Penutup Padding
  } // Penutup method _buildSettingItem
}
