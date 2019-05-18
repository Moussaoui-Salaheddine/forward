import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:forward/firehelp.dart';
import 'package:forward/home.dart';
import 'package:forward/login.dart';

main() {
  runApp(Forward());
}

class Forward extends StatelessWidget {
  final ThemeData lightheme = ThemeData(primarySwatch: Colors.deepOrange);
  final ThemeData darktheme = ThemeData(primarySwatch: Colors.grey);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightheme,
      darkTheme: darktheme,
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
