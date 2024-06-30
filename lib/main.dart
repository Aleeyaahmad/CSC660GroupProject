import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';
import 'screens/onboarding_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/assignment_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/room_reservation_screen.dart';
import 'screens/event_calendar_screen.dart';
import 'screens/about_us_screen.dart';
import 'screens/edit_profile_screen.dart';
import 'screens/add_room_reservation_screen.dart';
import 'screens/create_new_assignment_screen.dart';
import 'screens/edit_task_screen.dart';
import 'screens/search_room_reservation_screen.dart';
import 'screens/view_room_reservation_screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyCKcSEx0IEdSy5_fZ1-uP0pjg6RVbn3WwI",
      appId: "1:1014350006020:android:61dcbd4bb515c615a3f251",
      messagingSenderId: "1014350006020",
      projectId: "authentication660",
      storageBucket: "authentication660.appspot.com",
    )
  );
  
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: EduHubApp(),
    ),
  );
}

class EduHubApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'EduHub',
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: themeProvider.themeMode,
          debugShowCheckedModeBanner: false, // Remove debug banner
          initialRoute: '/',
          routes: {
            '/': (context) => OnboardingScreen(),
            '/login': (context) => LoginScreen(),
            '/register': (context) => RegisterScreen(),
            '/dashboard': (context) => DashboardScreen(),
            '/assignment': (context) => AssignmentScreen(),
            '/profile': (context) => ProfileScreen(),
            '/settings': (context) => SettingsScreen(),
            '/notifications': (context) => NotificationsScreen(),
            '/room_reservation': (context) => RoomReservationScreen(),
            '/event_calendar': (context) => EventCalendarScreen(),
            '/about_us': (context) => AboutUsScreen(),
            '/edit_profile': (context) => EditProfileScreen(),
            '/add_room_reservation': (context) => AddRoomReservationScreen(),
            '/create_assignment': (context) => CreateNewAssignmentScreen(),
            '/edit_task': (context) => EditTaskScreen(
              type: 'Assignment',
              title: 'Assignment #1',
              description: 'Group Project CSC660',
              dueDate: '30/5/2024',
              imageUrl: '', 
              reminder: false,
            ),
            '/search_room_reservation': (context) => SearchRoomReservationScreen(
              building: 'Building B',
              room: 'Room 101',
            ),
          },
        );
      },
    );
  }
}
