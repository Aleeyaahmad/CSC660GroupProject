import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String _fullName = '';
  String _email = '';
  String _password = '';
  String _confirmPassword = '';
  String? _fullNameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                ),
              ),
              Text(
                'Create Account',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 40),
              _buildTextField(
                context,
                label: 'Full Name',
                icon: Icons.person,
                onChanged: (value) => _fullName = value,
                errorText: _fullNameError,
              ),
              SizedBox(height: 20),
              _buildTextField(
                context,
                label: 'Email',
                icon: Icons.email,
                onChanged: (value) => _email = value,
                errorText: _emailError,
              ),
              SizedBox(height: 20),
              _buildTextField(
                context,
                label: 'Password',
                icon: Icons.lock,
                obscureText: true,
                onChanged: (value) => _password = value,
                errorText: _passwordError,
              ),
              SizedBox(height: 20),
              _buildTextField(
                context,
                label: 'Confirm Password',
                icon: Icons.lock,
                obscureText: true,
                onChanged: (value) => _confirmPassword = value,
                errorText: _confirmPasswordError,
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: _register,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF00C853), // Green color for the button
                  padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 5,
                ),
                child: Text(
                  'Register',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(BuildContext context, {required String label, required IconData icon, required Function(String) onChanged, bool obscureText = false, String? errorText}) {
    return TextField(
      obscureText: obscureText,
      style: TextStyle(color: Colors.white),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white),
        prefixIcon: Icon(icon, color: Colors.white),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.white),
        ),
        errorText: errorText,
        errorStyle: TextStyle(color: Colors.red),
      ),
    );
  }

  void _register() {
    setState(() {
      _fullNameError = null;
      _emailError = null;
      _passwordError = null;
      _confirmPasswordError = null;
    });

    if (_fullName.isEmpty) {
      setState(() {
        _fullNameError = 'Full Name cannot be empty';
      });
    }

    if (_email.isEmpty || !_email.contains('@')) {
      setState(() {
        _emailError = 'Enter a valid email';
      });
    }

    if (_password.isEmpty || _password.length < 6) {
      setState(() {
        _passwordError = 'Password must be at least 6 characters long';
      });
    }

    if (_confirmPassword != _password) {
      setState(() {
        _confirmPasswordError = 'Passwords do not match';
      });
    }

    if (_fullNameError == null && _emailError == null && _passwordError == null && _confirmPasswordError == null) {
      _showSuccessDialog();
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Registration Successful'),
          content: Text('Your account has been created successfully. Please log in to continue.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                Navigator.pushReplacementNamed(context, '/login'); // Navigate to login screen
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
