import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_auth_ui/firebase_auth_ui.dart';
import 'package:firebase_auth_ui/providers.dart';

class AuthService {
  auth.FirebaseAuth _auth;
  auth.User _user;

  AuthService() {
    _auth = auth.FirebaseAuth.instance;

    _auth.authStateChanges().listen((auth.User user) {
      _user = user;
    });
  }

  auth.User get user => _user;

  void presentLogin() {
    FirebaseAuthUi.instance()
        .launchAuth(
          [
            AuthProvider.email(), // Login/Sign up with Email and password
            AuthProvider.google(), // Login with Google
            // AuthProvider.facebook(), // Login with Facebook
            // AuthProvider.twitter(), // Login with Twitter
            // AuthProvider.phone(), // Login with Phone number
          ],
          tosUrl: "", // Optional
          privacyPolicyUrl: "", // Optional,
        )
        .then((fbuser) => {if (fbuser != null) {}})
        .catchError((error) => print(
            "Error $error")); //the above authStateChanges should get the logged in user
  }
}
