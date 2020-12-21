import 'package:flutter/material.dart';
import 'screens/HomeScreen.dart';
import 'screens/DriveList.dart';
import 'screens/Settings.dart';
import 'screens/LoadingScreen.dart';
import 'screens/Login.dart';
import 'package:drive_time_tracker/services/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(DriveTimeTracker());
}

class DriveTimeTracker extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Drive Time Tracker',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (_, _snapshot) {
            if (_snapshot.connectionState == ConnectionState.waiting) {
              return LoadingScreen();
            } else if (_snapshot.data is User && _snapshot.data != null) {
              return HomeScreen(
                title: "Drive Time Tracker",
              );
            } else {
              //AuthService().presentLogin();
              return LoginScreen();
            }
          }),
      routes: {
        DriveList.routeName: (context) => DriveList(),
        Settings.routeName: (context) => Settings(),
        HomeScreen.routeName: (context) => HomeScreen(),
      },
    );
  }
}
