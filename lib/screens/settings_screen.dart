import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../theme_provider.dart'; // Import the theme provider

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('About Us'),
            leading: Icon(Icons.info_outline),
            onTap: () {
              Navigator.pushNamed(context, '/about_us');
            },
          ),
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return ListTile(
                title: Text('Dark Mode'),
                leading: Icon(Icons.dark_mode),
                trailing: Switch(
                  value: themeProvider.isDarkMode,
                  onChanged: (bool value) {
                    themeProvider.toggleTheme(value);
                  },
                ),
              );
            },
          ),
          ListTile(
            title: Text('Logout'),
            leading: Icon(Icons.exit_to_app),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushNamedAndRemoveUntil(
                  context, '/login', (Route<dynamic> route) => false);
            },
          ),
        ],
      ),
    );
  }
}
