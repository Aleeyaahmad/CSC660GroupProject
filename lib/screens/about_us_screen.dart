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
              _buildLecturerCard('Lecturer 1', 'Student ID: 123456', 'assets/damia.jpg'),
              SizedBox(height: 16),
              _buildLecturerCard('Lecturer 2', 'Student ID: 234567', 'assets/alesya.jpg'),
              SizedBox(height: 16),
              _buildLecturerCard('Lecturer 3', 'Student ID: 345678', 'assets/aleeya.jpg'),
              SizedBox(height: 16),
              _buildLecturerCard('Lecturer 4', 'Student ID: 456789', 'assets/mairah.jpg'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLecturerCard(String name, String studentId, String imageUrl) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        leading: CircleAvatar(
          radius: 30,
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
