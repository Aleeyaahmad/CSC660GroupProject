import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            NotificationCard(
              icon: Icons.check_circle,
              title: 'Reservation completed',
              subtitle: 'Your reservation is confirmed.',
            ),
            NotificationCard(
              icon: Icons.person,
              title: 'Complete your personal information',
              subtitle: 'Please update your profile details.',
            ),
            NotificationCard(
              icon: Icons.event,
              title: 'High Jarman Hall event',
              subtitle: 'Join us for the event at High Jarman Hall.',
            ),
            NotificationCard(
              icon: Icons.assignment,
              title: 'Assignment Due',
              subtitle: 'The due date for Assignment 2 is approaching.',
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const NotificationCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 3,
      child: ListTile(
        leading: Icon(
          icon,
          size: 40,
          color: Colors.blue,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(subtitle),
        contentPadding: EdgeInsets.all(16),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Colors.grey,
        ),
        onTap: () {
          // Define onTap functionality here
        },
      ),
    );
  }
}
