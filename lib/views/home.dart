import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:test_1/services/firebase_auth_services/firebase_auth_services.dart';
import 'package:test_1/views/appointment_screen.dart';
import 'package:test_1/views/login_screen.dart';
import 'package:test_1/views/setting_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final AuthService authService = AuthService();
  void logout(BuildContext context) async {
    await authService.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.black26,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Hi, User',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.settings, color: Colors.black54),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SettingScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ), //Penutup Row utama untuk header
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(height: 60, width: 140, color: Colors.grey[300]),
                Container(height: 60, width: 140, color: Colors.grey[300]),
              ],
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                children: [
                  _buildMenuItem(
                    'assets/images/add-event.png',
                    'Janji Temu',
                    context,
                  ), // Menu Janji Temu
                  _buildMenuItem(
                    'assets/images/health-check.png',
                    'Riwayat',
                    context,
                  ), // Menu Riwayat
                  _buildMenuItem(
                    'assets/images/hospital.png',
                    'Rumah Sakit',
                    context,
                  ), // Menu Rumah Sakit // Menu Rumah Sakit
                  _buildMenuItem('assets/images/doctor.png', 'Dokter', context),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Informasi Terbaru',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 130,
                width: 350,
                color: Colors.grey[300],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(String imagePath, String title, BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (title == 'Janji Temu') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AppointmentScreen()),
          );
        }
      },
      child: SizedBox(
        width: 160,
        height: 160,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.yellow[100], // Warna latar belakang kuning muda
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(3, 3),
              ),
            ], // Membuat sudut melengkung
          ), // Penutup BoxDecoration
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment
                    .center, // Menyusun elemen secara tengah vertikal
            children: [
              Image.asset(imagePath, width: 80, height: 80), // Ikon menu
              SizedBox(height: 20), // Memberikan jarak antar ikon dan teks
              Text(
                title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ), // Teks menu
            ], // Penutup children Column
          ), // Penutup Column
        ),
      ),
    ); // Penutup Container
  } // Penutup method _buildMenuItem
}
