import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlueAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildLecturerCard('DAMIA SYAFIQAH BINTI MOHD SALLEH', 'Student ID: 2022645986', 'assets/damia.jpg'),
              SizedBox(height: 16),
              _buildLecturerCard('NUR ALIA ALESYA BINTI ABDUL AZIZ', 'Student ID: 2022484762', 'assets/alesya.jpg'),
              SizedBox(height: 16),
              _buildLecturerCard('ALEEYA BINTI AHMAD MAHMUD', 'Student ID: 2022836268', 'assets/aleeya.jpg'),
              SizedBox(height: 16),
              _buildLecturerCard('NURUL UMAIRAH BINTI MOHD BADLI', 'Student ID: 2022616642', 'assets/mairah.jpg'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLecturerCard(String name, String studentId, String imageUrl) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      elevation: 5,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        leading: CircleAvatar(
          radius: 20,
          backgroundImage: AssetImage(imageUrl),
        ),
        title: Text(
          name,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          studentId,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black54,
          ),
        ),
      ),
    );
  }
}
