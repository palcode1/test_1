import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            SizedBox(height: 40), // Jarak dari atas layar
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.yellow[100], // Warna background kuning muda
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/add-event.png',
                    width: 30,
                    height: 30,
                  ), // Ikon Janji Temu
                  SizedBox(width: 10),
                  Text(
                    "Buat Appointment",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Formulir Dropdown
            _buildDropdown("Area", selectedArea, [
              "Area 1",
              "Area 2",
              "Area 3",
            ], (value) => setState(() => selectedArea = value)),
            _buildDropdown(
              "Rumah Sakit",
              selectedHospital,
              ["RS A", "RS B", "RS C"],
              (value) => setState(() => selectedHospital = value),
            ),
            _buildDropdown(
              "Spesialisasi",
              selectedSpeciality,
              ["Dokter Umum", "Kardiologi", "Ortopedi"],
              (value) => setState(() => selectedSpeciality = value),
            ),
            _buildDropdown(
              "Pilih Dokter",
              selectedDoctor,
              ["Dr. John", "Dr. Sarah", "Dr. Michael"],
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
                  backgroundColor: Colors.yellow[100], // Warna tombol
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      10,
                    ), // Membuat sudut melengkung
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
                onPressed: () {
                  // Logika untuk membuat janji temu bisa ditambahkan di sini
                  print("Janji Temu Dibuat!");
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
