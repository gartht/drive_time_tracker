import 'package:flutter/material.dart';
import 'screens/HomeScreen.dart';
import 'screens//DriveList.dart';

void main() {
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
      home: HomeScreen(title: 'Drive Time Tracker'),
      routes: {
        DriveList.routeName: (context) => DriveList(),
      },
    );
  }
}
