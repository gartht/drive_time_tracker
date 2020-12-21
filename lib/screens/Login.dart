import 'package:flutter/material.dart';
//import 'package:drive_time_tracker/Konstants.dart';
//import 'package:drive_time_tracker/screens/HomeScreen.dart';
import 'package:drive_time_tracker/widgets/dtt_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:drive_time_tracker/services/auth.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'loginScreen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email, password;
  final _auth = AuthService(); //FirebaseAuth.instance;
  final TextEditingController pController = TextEditingController();
  final TextEditingController eController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: 48.0,
            ),
            DTTButton(
                color: Colors.lightBlueAccent,
                onPressed: () async {
                  try {
                    _auth.presentLogin();
                  } catch (e) {
                    print(e);
                  }
                },
                text: 'Log In / Register'),
          ],
        ),
      ),
    );
  }
}
