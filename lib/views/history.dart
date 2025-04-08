import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test_1/databases/db_service.dart';
import 'package:test_1/views/appointment_screen.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final DBHelper dbHelper = DBHelper();
  List<Map<String, dynamic>> appointments = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  Future<void> _loadAppointments() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    print("▶️ Memulai _loadAppointments");
    try {
      final data = await dbHelper.getAppointments();
      print("📦 Data terambil: $data");
      setState(() {
        appointments = data;
        isLoading = false;
      });
    } catch (e) {
      print("❌ Error saat loadAppointments: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _deleteAppointment(String docId) async {
    try {
      await dbHelper.deleteAppointment(docId);
      _loadAppointments(); // Refresh data setelah hapus
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Janji temu berhasil dihapus")));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal menghapus janji temu: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Riwayat Janji Temu'),
        backgroundColor: Colors.yellow[100],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFB1F0F7), Color(0xFF81BFDA)],
          ),
        ),
        child:
            isLoading
                ? Center(child: CircularProgressIndicator())
                : appointments.isEmpty
                ? Center(child: Text("Belum ada janji temu."))
                : ListView.builder(
                  itemCount: appointments.length,
                  itemBuilder: (context, index) {
                    final appt = appointments[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      elevation: 4,
                      color: Colors.yellow[100],
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${appt['doctor']} - ${appt['specialization']}",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "${appt['hospital']} (${appt['area']})\n${appt['date']} - ${appt['time']}",
                            ),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () async {
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => AppointmentScreen(
                                              appointmentData: appt,
                                              appointmentId: appt['id'],
                                            ),
                                      ),
                                    );

                                    if (result == true) {
                                      _loadAppointments(); // reload data jika form berhasil simpan/edit
                                    }
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder:
                                          (ctx) => AlertDialog(
                                            title: Text("Konfirmasi"),
                                            content: Text(
                                              "Yakin ingin menghapus janji temu ini?",
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed:
                                                    () => Navigator.pop(ctx),
                                                child: Text("Batal"),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(ctx);
                                                  _deleteAppointment(
                                                    appt['id'],
                                                  );
                                                },
                                                child: Text(
                                                  "Hapus",
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      ),
    );
  }
}
