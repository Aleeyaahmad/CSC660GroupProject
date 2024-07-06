import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseMessagingService {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> setupFirebaseMessaging() async {
    // Get the token each time the application loads
    String? token = await _firebaseMessaging.getToken();
    print('Firebase Messaging Token: $token');

    // Handle incoming messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Foreground Message: $message');
      // Handle your messages here
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Background Message: $message');
      // Handle your background messages here
    });

    // Request permission for iOS to receive notifications
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    print('User granted permission: ${settings.authorizationStatus}');
  }
}
