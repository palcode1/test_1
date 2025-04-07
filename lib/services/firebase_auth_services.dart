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
      print("Firebase Auth Error: \${e.code}");
      String errorMessage = _handleFirebaseError(e.code);
      showToast(errorMessage);
      return e.code;
    } catch (e) {
      print("Unexpected login error: \$e");
      showToast("Terjadi kesalahan tak terduga!");
      return "unexpected_error";
    }
  }

  // Sign Up User dengan validasi dan error handling
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

      User? user = userCredential.user;

      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'name': name,
          'email': email,
          'phone': phone,
          'created_at': FieldValue.serverTimestamp(),
        });

        showToast("Pendaftaran berhasil!", success: true);
        return "success";
      } else {
        return "user creation failed";
      }
    } on FirebaseAuthException catch (e) {
      print("FirebaseAuthException: \${e.code} - \${e.message}");
      String errorMessage = _handleFirebaseError(e.code);
      showToast(errorMessage);
      return e.code;
    } on FirebaseException catch (e) {
      print("FirebaseException (Firestore): \${e.code} - \${e.message}");
      showToast("Gagal menyimpan data ke database. Cek permission Firestore.");
      return "firestore_error";
    } catch (e) {
      print("Unexpected registration error: \$e");
      showToast("Terjadi kesalahan tak terduga!");
      return "unexpected_error";
    }
  }

  // Sign In dengan Google
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

      UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );
      User? user = userCredential.user;

      if (user != null) {
        // Cek apakah user baru
        DocumentSnapshot doc =
            await _firestore.collection('users').doc(user.uid).get();

        if (!doc.exists) {
          // Jika user baru, simpan data awal
          await _firestore.collection('users').doc(user.uid).set({
            'uid': user.uid,
            'name': user.displayName ?? '',
            'email': user.email ?? '',
            'phone': user.phoneNumber ?? '',
            'created_at': FieldValue.serverTimestamp(),
            'login_with': 'google',
          });
        }
      }

      showToast("Login dengan Google berhasil!", success: true);
      return "success";
    } on FirebaseAuthException catch (e) {
      print("Google Auth Error: \${e.code} - \${e.message}");
      showToast("Autentikasi Google gagal: \${e.message}");
      return e.code;
    } catch (e) {
      print("Unexpected Google sign-in error: \$e");
      showToast("Terjadi kesalahan tak terduga saat login dengan Google!");
      return "unexpected_error";
    }
  }

  // Logout dari Firebase & Google
  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }
}
