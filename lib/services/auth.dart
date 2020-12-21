import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_auth_ui/firebase_auth_ui.dart';
import 'package:firebase_auth_ui/providers.dart';

class AuthService {
  static auth.FirebaseAuth _auth;
  static AuthService _instance;
  auth.User _user;
  static bool _initialized = false;

  AuthService._() {
    _auth = auth.FirebaseAuth.instance;
  }

  static Future initialize() async {
    await Firebase.initializeApp();
    _initialized = true;
  }

  static AuthService get instance {
    assert(_initialized);

    if (_instance == null) {
      _instance = AuthService._();
    }

    return _instance;
  }

  //wrap the authStateChanges stream from firebase as a decoupling
  Stream<DTTUser> authChanges() async* {
    var fbs = _auth.authStateChanges();

    await for (auth.User u in fbs) {
      _user = u;
      if (_user != null) {
        var du = AuthUser(_user);
        yield du;
      } else {
        yield null;
      }
    }
  }

  Future<String> getIdToken() {
    return _user.getIdToken();
  }

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

abstract class DTTUser {
  String get displayName;
  String get email;
  String get photoURL;
  String get phoneNumber;
}

class AuthUser implements DTTUser {
  auth.User wrappedUser;
  AuthUser(this.wrappedUser);

  String get displayName => wrappedUser.displayName;
  String get email => wrappedUser.email;
  String get photoURL => wrappedUser.photoURL;
  String get phoneNumber => wrappedUser.phoneNumber;
}
