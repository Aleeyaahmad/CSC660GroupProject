import 'package:flutter/material.dart';

class EditProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Name', style: TextStyle(fontWeight: FontWeight.bold)),
              TextField(
                decoration: InputDecoration(hintText: 'Enter your name'),
              ),
              SizedBox(height: 10),
              Text('Phone number', style: TextStyle(fontWeight: FontWeight.bold)),
              TextField(
                decoration: InputDecoration(hintText: 'Enter your phone number'),
              ),
              SizedBox(height: 10),
              Text('Username', style: TextStyle(fontWeight: FontWeight.bold)),
              TextField(
                decoration: InputDecoration(hintText: 'Enter your username'),
              ),
              SizedBox(height: 10),
              Text('Email', style: TextStyle(fontWeight: FontWeight.bold)),
              TextField(
                decoration: InputDecoration(hintText: 'Enter your email'),
              ),
              SizedBox(height: 10),
              Text('Password', style: TextStyle(fontWeight: FontWeight.bold)),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Enter your password',
                  suffix: TextButton(
                    onPressed: () {
                      // Change password logic
                    },
                    child: Text('Change password', style: TextStyle(color: Colors.blue)),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text('Description', style: TextStyle(fontWeight: FontWeight.bold)),
              TextField(
                decoration: InputDecoration(hintText: 'Enter a brief description'),
              ),
              SizedBox(height: 10),
              Text('Campus', style: TextStyle(fontWeight: FontWeight.bold)),
              TextField(
                decoration: InputDecoration(hintText: 'Enter your campus name'),
              ),
              SizedBox(height: 10),
              Text('Area of Expertise', style: TextStyle(fontWeight: FontWeight.bold)),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Enter your area of expertise',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      // Add area of expertise logic
                    },
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text('Social Media/Connect', style: TextStyle(fontWeight: FontWeight.bold)),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Enter your social media or connect info',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      // Add social media logic
                    },
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text('Links', style: TextStyle(fontWeight: FontWeight.bold)),
              TextField(
                decoration: InputDecoration(hintText: 'Enter URL media'),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Back'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Update profile logic
                    },
                    child: Text('Update'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
