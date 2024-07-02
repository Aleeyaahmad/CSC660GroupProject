import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String? _emailError;
  String? _passwordError;

  @override
  void initState() {
    super.initState();
    // Check if user is already logged in
    if (FirebaseAuth.instance.currentUser != null) {
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/dashboard');
      });
    }
  }

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
              Text(
                'Welcome Back!',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 40),
              _buildTextField(
                context,
                label: 'Email',
                icon: Icons.email,
                onChanged: (value) {
                  setState(() {
                    _email = value;
                    _emailError = null; // Clear previous error
                  });
                },
                errorText: _emailError,
              ),
              SizedBox(height: 20),
              _buildTextField(
                context,
                label: 'Password',
                icon: Icons.lock,
                obscureText: true,
                onChanged: (value) {
                  setState(() {
                    _password = value;
                    _passwordError = null; // Clear previous error
                  });
                },
                errorText: _passwordError,
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF00C853), // Green color for the button
                  padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 5,
                ),
                child: Text(
                  'Sign In',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/register');
                },
                child: Text(
                  'Don\'t have an account? Sign up',
                  style: TextStyle(color: Colors.white),
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

  void _login() async {
    setState(() {
      _emailError = null;
      _passwordError = null;
    });

    if (_email.isEmpty || !_email.contains('@')) {
      setState(() {
        _emailError = 'Enter a valid email';
      });
      return; // Exit early if email is invalid
    }

    if (_password.isEmpty) {
      setState(() {
        _passwordError = 'Password cannot be empty';
      });
      return; // Exit early if password is empty
    }

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _email,
        password: _password,
      );
      Navigator.pushReplacementNamed(context, '/dashboard');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        setState(() {
          _emailError = 'No user found for that email';
        });
      } else if (e.code == 'wrong-password') {
        setState(() {
          _passwordError = 'Wrong password provided';
        });
      }
    } catch (e) {
      print(e); // Print other errors to console
    }
  }
}
