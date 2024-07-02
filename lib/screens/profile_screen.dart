import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:edu_hub/screens/edit_profile_screen.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = 'DEFAULT NAME';
  String phoneNumber = '1234567890';
  String email = 'example@email.com';
  String areaOfExpertise = 'No information.';
  String socialMedia = 'No information.';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userProfile = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (userProfile.exists) {
        setState(() {
          name = userProfile['name'];
          phoneNumber = userProfile['phoneNumber'];
          email = userProfile['email'];
          areaOfExpertise = userProfile['areaOfExpertise'];
          socialMedia = userProfile['socialMedia'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Profile',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF64B5F6), Color(0xFF00C853)], // Blue and sage green gradient colors
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Color(0xFF64B5F6), // Blue color
                        child: Icon(Icons.person, size: 40, color: Colors.white),
                      ),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '$phoneNumber  |  Staff',
                            style: TextStyle(fontSize: 16, color: Colors.black54),
                          ),
                        ],
                      ),
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.edit, color: Color(0xFF64B5F6)), // Blue color
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditProfileScreen(
                                name: name,
                                phoneNumber: phoneNumber,
                                email: email,
                                areaOfExpertise: areaOfExpertise,
                                socialMedia: socialMedia,
                              ),
                            ),
                          );

                          if (result != null) {
                            setState(() {
                              name = result['name'];
                              phoneNumber = result['phoneNumber'];
                              email = result['email'];
                              areaOfExpertise = result['areaOfExpertise'];
                              socialMedia = result['socialMedia'];
                            });
                            _updateProfileInFirestore();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Personal Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Name:', style: TextStyle(fontSize: 16)),
                    Text(name, style: TextStyle(fontSize: 16)),
                    SizedBox(height: 10),
                    Text('Mobile:', style: TextStyle(fontSize: 16)),
                    Text(phoneNumber, style: TextStyle(fontSize: 16)),
                    SizedBox(height: 10),
                    Text('Email:', style: TextStyle(fontSize: 16)),
                    Text(email, style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Additional Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Areas of Expertise',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(areaOfExpertise, style: TextStyle(fontSize: 16)),
                    SizedBox(height: 10),
                    Text(
                      'Connect',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(socialMedia, style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _updateProfileInFirestore() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'name': name,
        'phoneNumber': phoneNumber,
        'email': email,
        'areaOfExpertise': areaOfExpertise,
        'socialMedia': socialMedia,
      });
    }
  }
}
