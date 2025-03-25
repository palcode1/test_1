import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:test_1/utils/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  // Mapping error message dari Firebase ke pesan yang lebih jelas
  String _handleFirebaseError(String errorCode) {
    switch (errorCode) {
      case "invalid-email":
        return "Format email tidak valid!";
      case "user-not-found":
        return "Akun tidak ditemukan, silakan daftar terlebih dahulu!";
      case "invalid-credential":
        return "Password salah, coba lagi!";
      case "email-already-in-use":
        return "Email ini sudah terdaftar, silakan login!";
      case "weak-password":
        return "Gunakan password minimal 6 karakter!";
      case "too-many-requests":
        return "Terlalu banyak percobaan login, coba lagi nanti!";
      default:
        return "Terjadi kesalahan, coba lagi nanti.";
    }
  }

  // Login User dengan validasi dan switch-case error handling

  Future<String> login({
    required String email,
    required String password,
  }) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        showToast("Email dan password harus diisi!");
        return "empty_fields";
      }

      await _auth.signInWithEmailAndPassword(email: email, password: password);
      showToast("Login berhasil!", success: true);
      return "success";
    } on FirebaseAuthException catch (e) {
      print("Firebase Auth Error: ${e.code}");
      String errorMessage = _handleFirebaseError(e.code);
      showToast(errorMessage);
      return e.code;
    } catch (e) {
      print(e);
      showToast("Terjadi kesalahan tak terduga!");
      return "unexpected_error";
    }
  }

  // Sign Up User dengan validasi dan switch-case error handling
  Future<String> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      if (name.isEmpty || email.isEmpty || phone.isEmpty || password.isEmpty) {
        showToast("Semua data harus diisi!");
        return "empty_fields";
      }

      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'name': name,
        'email': email,
        'phone': phone,
        'created_at': DateTime.now(),
      });
      showToast("Pendaftaran berhasil!", success: true);
      return "success";
    } on FirebaseAuthException catch (e) {
      String errorMessage = _handleFirebaseError(e.code);
      showToast(errorMessage);
      return e.code;
    } catch (e) {
      showToast("Terjadi kesalahan tak terduga!");
      return "unexpected_error";
    }
  }

  Future<String> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return "canceled"; // User membatalkan login

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);
      showToast("Login dengan Google berhasil!", success: true);
      return "success";
    } on FirebaseAuthException catch (e) {
      showToast("Autentikasi Google gagal: ${e.message}");
      return e.code;
    } catch (e) {
      showToast("Terjadi kesalahan tak terduga saat login dengan Google!");
      return "unexpected_error";
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut(); // Logout dari Firebase
    await GoogleSignIn().signOut(); // Logout dari Google
  }
}
