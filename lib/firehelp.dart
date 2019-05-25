import 'package:firebase_auth/firebase_auth.dart';

class Firebase {
  static FirebaseUser user;
  static FirebaseUser getUser() {
    return user;
  }

  static void setUser(FirebaseUser fbusr) {
    user = fbusr;
  }
}
