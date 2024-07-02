import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  final String name;
  final String phoneNumber;
  final String email;
  final String areaOfExpertise;
  final String socialMedia;

  EditProfileScreen({
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.areaOfExpertise,
    required this.socialMedia,
  });

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _expertiseController;
  late TextEditingController _socialMediaController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _phoneController = TextEditingController(text: widget.phoneNumber);
    _emailController = TextEditingController(text: widget.email);
    _expertiseController = TextEditingController(text: widget.areaOfExpertise);
    _socialMediaController = TextEditingController(text: widget.socialMedia);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF64B5F6), // Blue
              Color(0xFF00C853), // Green
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Name', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: 'Enter your name',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text('Phone number', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                TextField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    hintText: 'Enter your phone number',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text('Email', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'Enter your email',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text('Password', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide.none,
                    ),
                    suffix: TextButton(
                      onPressed: () {
                        // Change password logic
                      },
                      child: Text('Change password', style: TextStyle(color: Colors.blue)),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text('Area of Expertise', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                TextField(
                  controller: _expertiseController,
                  decoration: InputDecoration(
                    hintText: 'Enter your area of expertise',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text('Social Media/Connect', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                TextField(
                  controller: _socialMediaController,
                  decoration: InputDecoration(
                    hintText: 'Enter your social media or connect info',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text('Links', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter URL media',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orangeAccent,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Back'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[800],
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context, {
                          'name': _nameController.text,
                          'phoneNumber': _phoneController.text,
                          'email': _emailController.text,
                          'areaOfExpertise': _expertiseController.text,
                          'socialMedia': _socialMediaController.text,
                        });
                      },
                      child: Text('Update'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
