import 'package:flutter/material.dart';

class DoctorList extends StatefulWidget {
  @override
  _DoctorListState createState() => _DoctorListState();
}

class _DoctorListState extends State<DoctorList> {
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
                'assets/images/doctor.png',
                width: 30,
                height: 30,
              ), // Ikon pengaturan
              SizedBox(width: 10),
              Text(
                'Daftar Dokter',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFB1F0F7), Color(0xFF81BFDA)],
          ),
        ),
        child: ListView(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Nama Dokter ...',
                      hintStyle: TextStyle(
                        color: Colors.grey.shade500.withOpacity(1),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Image.asset(
                  'assets/images/magnifying-glass.png',
                  width: 40,
                ), // ikon pencarian
              ],
            ),
            const SizedBox(height: 20),
            // Dokter 1
            _buildDoctorCard(
              image: 'assets/images/doctor1.png',
              name: 'dr. John Smith',
              specialization: 'Bedah Umum',
              field: 'Spesialisasi Bedah',
            ),
            const SizedBox(height: 16),
            // Dokter 2
            _buildDoctorCard(
              image: 'assets/images/doctor2.png',
              name: 'dr. Anne',
              specialization: 'Kedokteran Umum',
              field: 'Dokter Umum',
            ),
            const SizedBox(height: 16),
            // Dokter 3
            _buildDoctorCard(
              image: 'assets/images/doctor3.png',
              name: 'dr. Albert Simpsons',
              specialization: 'Onkologi (Kanker)',
              field: 'Spesialisasi Penyakit Dalam',
            ),
            const SizedBox(height: 16),
            // Dokter 3
            _buildDoctorCard(
              image: 'assets/images/doctor1.png',
              name: 'dr. Albert Simpsons',
              specialization: 'Onkologi (Kanker)',
              field: 'Spesialisasi Penyakit Dalam',
            ),
            const SizedBox(height: 16),
            // Dokter 3
            _buildDoctorCard(
              image: 'assets/images/doctor2.png',
              name: 'dr. Albert Simpsons',
              specialization: 'Onkologi (Kanker)',
              field: 'Spesialisasi Penyakit Dalam',
            ),
            const SizedBox(height: 16),
            // Dokter 3
            _buildDoctorCard(
              image: 'assets/images/doctor3.png',
              name: 'dr. Albert Simpsons',
              specialization: 'Onkologi (Kanker)',
              field: 'Spesialisasi Penyakit Dalam',
            ),
            const SizedBox(height: 16),
            // Dokter 3
            _buildDoctorCard(
              image: 'assets/images/doctor1.png',
              name: 'dr. Albert Simpsons',
              specialization: 'Onkologi (Kanker)',
              field: 'Spesialisasi Penyakit Dalam',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorCard({
    required String image,
    required String name,
    required String specialization,
    required String field,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.yellow[100],
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Image.asset(image, width: 80, height: 100),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(specialization),
                  Text(field),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
