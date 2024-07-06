import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:badges/badges.dart' as badges;

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _deleteNotification(DocumentSnapshot doc) async {
    await _firestore.collection('notifications').doc(doc.id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        actions: [
          StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection('notifications').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Container();
              }

              return badges.Badge(
                badgeContent: Text(
                  snapshot.data!.docs.length.toString(),
                  style: TextStyle(color: Colors.white),
                ),
                child: IconButton(
                  icon: Icon(Icons.notifications),
                  onPressed: () {},
                ),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('notifications').orderBy('timestamp', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final notifications = snapshot.data!.docs;

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];

              return Dismissible(
                key: Key(notification.id),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  _deleteNotification(notification);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Notification deleted')),
                  );
                },
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Icon(Icons.delete, color: Colors.white),
                ),
                child: NotificationCard(
                  icon: Icons.event,
                  title: notification['title'],
                  subtitle: notification['subtitle'],
                  onDelete: () => _deleteNotification(notification),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onDelete;

  const NotificationCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onDelete,
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
        trailing: IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: onDelete,
        ),
        onTap: () {
          // Define onTap functionality here
        },
      ),
    );
  }
}
