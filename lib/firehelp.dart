import 'package:firebase_auth/firebase_auth.dart';

class Firebase {
  static FirebaseUser user;
  static String _username;

  static FirebaseUser getUser() {
    return user;
  }

  static void setUser(FirebaseUser fbusr) {
    user = fbusr;
  }

  static get username => _username;
  static set username(String fbusrname) {
    _username = fbusrname;
  }
}
