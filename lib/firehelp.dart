import 'package:firebase_auth/firebase_auth.dart';

class Firebase {
  static FirebaseUser user;
  static String _username;
  static String _userimageurl;

  static FirebaseUser getUser() {
    return user;
  }

  static void setUser(FirebaseUser fbusr) {
    user = fbusr;
  }

  static String getUsername() => _username;
  static void setUsername(String fbusrname) {
    _username = fbusrname;
  }

  static String getUserimageurl() => _userimageurl;
  static void setUserimageurl(String fbusrimageurl) {
    _userimageurl = fbusrimageurl;
  }

  
}
