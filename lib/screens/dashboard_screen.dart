import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:badges/badges.dart' as badges;
import 'notifications_screen.dart';

class DashboardScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Dashboard', style: TextStyle(color: Colors.black)),
        actions: [
          StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection('notifications').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return IconButton(
                  icon: Icon(Icons.notifications, size: 35, color: Colors.blueAccent),
                  onPressed: () {
                    Navigator.pushNamed(context, '/notifications');
                  },
                );
              }

              return badges.Badge(
                position: badges.BadgePosition.topEnd(top: 0, end: 3),
                badgeStyle: badges.BadgeStyle(
                  shape: badges.BadgeShape.circle,
                  badgeColor: Colors.red,
                  padding: EdgeInsets.all(5),
                  borderRadius: BorderRadius.circular(10),
                ),
                badgeContent: Text(
                  snapshot.data!.docs.length.toString(),
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
                child: IconButton(
                  icon: Icon(Icons.notifications, size: 35, color: Colors.blueAccent),
                  onPressed: () {
                    Navigator.pushNamed(context, '/notifications');
                  },
                ),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            Container(
              height: 100,
              color: Colors.blueAccent,
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.person, color: Colors.blueAccent),
                    title: Text('My Profile', style: TextStyle(color: Colors.black)),
                    onTap: () {
                      Navigator.pushNamed(context, '/profile');
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.settings, color: Colors.blueAccent),
                    title: Text('Settings', style: TextStyle(color: Colors.black)),
                    onTap: () {
                      Navigator.pushNamed(context, '/settings');
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.dashboard, color: Colors.blueAccent),
                    title: Text('Dashboard', style: TextStyle(color: Colors.black)),
                    onTap: () {
                      Navigator.pushNamed(context, '/dashboard');
                    },
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.blueAccent),
              title: Text('Log out', style: TextStyle(color: Colors.black)),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF64B5F6), Color(0xFF00C853)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text(
                'Hi, User!',
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              SizedBox(height: 10),
              Text(
                'Welcome back to your dashboard',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w300, color: Colors.white),
              ),
              SizedBox(height: 20),
              DashboardCard(
                icon: Icons.calendar_today,
                title: 'Event Calendar',
                onTap: () {
                  Navigator.pushNamed(context, '/event_calendar');
                },
                height: 120,
                isFullWidth: true,
              ),
              SizedBox(height: 8),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: DashboardCard(
                        icon: Icons.meeting_room,
                        title: 'Room Reservations',
                        onTap: () {
                          Navigator.pushNamed(context, '/room_reservation');
                        },
                        height: double.infinity,
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: DashboardCard(
                        icon: Icons.book,
                        title: 'Assignments & Exams',
                        onTap: () {
                          Navigator.pushNamed(context, '/assignment');
                        },
                        height: double.infinity,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final double height;
  final bool isFullWidth;

  const DashboardCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.height = 150,
    this.isFullWidth = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(15),
          splashColor: Colors.blueAccent.withOpacity(0.2),
          highlightColor: Colors.blueAccent.withOpacity(0.1),
          child: Container(
            width: isFullWidth ? double.infinity : null,
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(2, 2),
                ),
              ],
              color: Colors.white,
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 50,
                  color: Colors.blueAccent,
                ),
                SizedBox(height: 10),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
