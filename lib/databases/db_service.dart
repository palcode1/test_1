import 'package:cloud_firestore/cloud_firestore.dart';

class DBHelper {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addAppointment({
    required String area,
    required String hospital,
    required String specialization,
    required String doctor,
    required String date,
    required String time,
  }) async {
    await _firestore.collection('appointments').add({
      'area': area,
      'hospital': hospital,
      'specialization': specialization,
      'doctor': doctor,
      'date': date,
      'time': time,
      'created_at': FieldValue.serverTimestamp(),
    });
  }
}
