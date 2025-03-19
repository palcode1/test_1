import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_1/services/firebase_auth_services/firebase_auth_services.dart';
import 'package:test_1/views/home.dart';
import 'package:test_1/views/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final AuthService authService = AuthService();

  void register(BuildContext context) async {
    String result = await authService.register(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text,
    );

    if (result == 'success') {
      // Jika registrasi berhasil, arahkan ke halaman Home atau Login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nama', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: 'Masukkan Nama',
                hintStyle: TextStyle(color: Colors.grey.withOpacity(1)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 10),
            Text('Email', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: 'Masukkan Email',
                hintStyle: TextStyle(color: Colors.grey.withOpacity(1)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 10),
            Text('Passwrod', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                hintText: 'Masukkan Password',
                hintStyle: TextStyle(color: Colors.grey.withOpacity(1)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => register(context),
                child: Text(
                  'Daftar',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
            Center(
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Sudah punya akun? Login',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
