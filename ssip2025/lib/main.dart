import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ssip2025/pages/splashscreen.dart';

Future<void> main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize notifications but don't request permissions yet
  await initNotifications();

  runApp(MyApp());
}

// Initialize notifications
Future<void> initNotifications() async {
  await AwesomeNotifications().initialize(
    null, // No icon for this example, use your app icon path for production
    [
      NotificationChannel(
        channelKey: 'geofence_channel',
        channelName: 'Geofence Notifications',
        channelDescription: 'Notifications for geofence entry and exit',
        defaultColor: Colors.blue,
        ledColor: Colors.blue,
        importance: NotificationImportance.High,
        channelShowBadge: true,
        playSound: true,
        enableVibration: true,
      )
    ],
  );

  // We'll handle permission requests elsewhere - don't request here
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}