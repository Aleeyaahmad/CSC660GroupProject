import 'package:flutter/material.dart';

class FloatingText extends StatefulWidget {
  final String text;
  final TextStyle style;

  FloatingText({required this.text, required this.style});

  @override
  _FloatingTextState createState() => _FloatingTextState();
}

class _FloatingTextState extends State<FloatingText> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween(
      begin: Offset(0, -0.05),
      end: Offset(0, 0.05),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return SlideTransition(
          position: _animation,
          child: child,
        );
      },
      child: Text(widget.text, style: widget.style),
    );
  }
}

class OnboardingScreen extends StatelessWidget {
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FloatingText(
                text: 'WELCOME',
                style: TextStyle(
                  fontSize: 40.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              FloatingText(
                text: 'to EduHub',
                style: TextStyle(
                  fontSize: 40.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, // White background color for button
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // Rounded corners
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15), // Padding inside button
                ),
                child: Text(
                  "Let's Get Started",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue, // Blue color for text
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
