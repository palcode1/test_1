import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DBHelper {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Menambahkan janji temu ke Firestore
  Future<void> addAppointment({
    required String area,
    required String hospital,
    required String specialization,
    required String doctor,
    required String date,
    required String time,
  }) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception("User tidak login");

    await _firestore.collection('appointments').add({
      'uid': uid,
      'area': area,
      'hospital': hospital,
      'specialization': specialization,
      'doctor': doctor,
      'date': date,
      'time': time,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  /// Menghapus janji temu berdasarkan document ID
  Future<void> deleteAppointment(String docId) async {
    try {
      await _firestore.collection('appointments').doc(docId).delete();
    } catch (e) {
      throw Exception("Gagal menghapus janji temu: $e");
    }
  }

  /// Memperbarui tanggal dan waktu janji temu berdasarkan document ID
  Future<void> updateAppointment(
    String docId,
    String newDate,
    String newTime,
  ) async {
    try {
      await _firestore.collection('appointments').doc(docId).update({
        'date': newDate,
        'time': newTime,
      });
    } catch (e) {
      throw Exception("Gagal memperbarui janji temu: $e");
    }
  }

  /// Mengambil semua janji temu user yang sedang login berdasarkan UID
  Future<List<Map<String, dynamic>>> getAppointments() async {
    final uid = _auth.currentUser?.uid;

    if (uid == null) throw Exception("User tidak login");

    try {
      print("✅ Mengambil janji temu untuk UID: $uid");
      final snapshot =
          await _firestore
              .collection('appointments')
              .where('uid', isEqualTo: uid)
              .orderBy('createdAt', descending: true)
              .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id; // penting untuk update/hapus
        return data;
      }).toList();
    } catch (e) {
      throw Exception("Gagal mengambil janji temu: $e");
    }
  }
}
