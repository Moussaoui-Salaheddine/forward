import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forward/auth/login.dart';
import 'package:forward/dynamictheme.dart';
import 'package:forward/firehelp.dart';
import 'package:forward/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

main() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
    statusBarColor: Colors.transparent,
  ));
  await _read();
  runApp(Forward());
}

_read() async {
  final prefs = await SharedPreferences.getInstance();
  final key = 'darktheme';
  DynamicTheme.darkthemeEnabled = prefs.getBool(key) ?? false;
}

class Forward extends StatefulWidget {
  @override
  _ForwardState createState() => _ForwardState();
}

class _ForwardState extends State<Forward> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: UserStateHandler(),
    );
  }
}

class UserStateHandler extends StatefulWidget {
  @override
  _UserStateHandlerState createState() => _UserStateHandlerState();
}

class _UserStateHandlerState extends State<UserStateHandler> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (context, snapShot) {
        if (snapShot.connectionState == ConnectionState.waiting)
          return Material(
            child: Center(child: Text('Loading...')),
          );
        else if (snapShot.connectionState == ConnectionState.none ||
            snapShot.connectionState == ConnectionState.done)
          return Material(
            child: Center(child: Text('No Internet Connection !')),
          );
        else if (!snapShot.hasData) {
          return Login();
        } else {
          Firebase.setUser(snapShot.data);
          return Home();
        }
      },
    );
  }
}
