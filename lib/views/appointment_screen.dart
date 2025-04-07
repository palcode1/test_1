import 'package:flutter/material.dart';
import 'package:test_1/databases/db_model.dart';
import 'package:test_1/databases/db_service.dart';
import 'package:test_1/views/history.dart';

class AppointmentScreen extends StatefulWidget {
  @override
  _AppointmentScreenState createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  String? selectedArea;
  String? selectedHospital;
  String? selectedSpeciality;
  String? selectedDoctor;
  String? selectedDate;
  String? selectedTime;

  final DBHelper dbHelper = DBHelper(); // Inisialisasi DBHelper

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100), // Tinggi AppBar lebih besar
        child: Container(
          decoration: BoxDecoration(
            color: Colors.yellow[100], // Warna latar AppBar
          ),
          padding: EdgeInsets.only(top: 40, left: 16, right: 16, bottom: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/add-event.png',
                width: 30,
                height: 30,
              ), // Ikon pengaturan
              SizedBox(width: 10),
              Text(
                'Buat Janji Temu',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(16), // Memberikan padding di seluruh sisi
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFB1F0F7),
              Color(0xFF81BFDA),
            ], // Gradasi background
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(), // Jarak dari atas layar
            // Formulir Dropdown menggunakan data dari DBModel
            _buildDropdown(
              "Area",
              selectedArea,
              DBModel.areas,
              (value) => setState(() => selectedArea = value),
            ),
            _buildDropdown(
              "Rumah Sakit",
              selectedHospital,
              DBModel.hospitals,
              (value) => setState(() => selectedHospital = value),
            ),
            _buildDropdown(
              "Spesialisasi",
              selectedSpeciality,
              DBModel.specializations,
              (value) => setState(() => selectedSpeciality = value),
            ),
            _buildDropdown(
              "Pilih Dokter",
              selectedDoctor,
              DBModel.doctors,
              (value) => setState(() => selectedDoctor = value),
            ),
            _buildDropdown(
              "Pilih Tanggal",
              selectedDate,
              ["12 Maret", "13 Maret", "14 Maret"],
              (value) => setState(() => selectedDate = value),
            ),
            _buildDropdown(
              "Pilih Waktu",
              selectedTime,
              ["08:00", "10:00", "14:00"],
              (value) => setState(() => selectedTime = value),
            ),

            SizedBox(height: 20),

            // Tombol Buat Janji Temu
            Container(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFADA7A), // Warna tombol
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      10,
                    ), // Membuat sudut melengkung
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
                onPressed: () {
                  _saveAppointment(); // Simpan data ke Firestore
                },
                child: Text(
                  "Buat Janji Temu",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fungsi menyimpan data ke Firestore
  void _saveAppointment() {
    if (selectedArea != null &&
        selectedHospital != null &&
        selectedSpeciality != null &&
        selectedDoctor != null &&
        selectedDate != null &&
        selectedTime != null) {
      dbHelper
          .addAppointment(
            area: selectedArea!,
            hospital: selectedHospital!,
            specialization: selectedSpeciality!,
            doctor: selectedDoctor!,
            date: selectedDate!,
            time: selectedTime!,
          )
          .then((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Janji Temu Berhasil Dibuat")),
            );
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HistoryScreen()),
            );
          })
          .catchError((error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Gagal menyimpan janji temu: $error")),
            );
          });
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Silakan lengkapi semua bidang!")));
    }
  }

  // Widget untuk membuat DropdownButtonFormField
  Widget _buildDropdown(
    String label,
    String? selectedValue,
    List<String> items,
    Function(String?) onChanged,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey),
            ),
            child: DropdownButtonFormField<String>(
              value: selectedValue,
              decoration: InputDecoration(border: InputBorder.none),
              isExpanded: true,
              icon: Icon(Icons.arrow_drop_down),
              items:
                  items.map((item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    );
                  }).toList(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
