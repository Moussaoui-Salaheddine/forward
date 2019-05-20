import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forward/firehelp.dart';
import 'package:forward/home.dart';
import 'package:forward/login.dart';

main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
    statusBarColor: Colors.transparent,
  ));
  runApp(Forward());
}

class Forward extends StatelessWidget {
  static bool darkthemeEnabled = false;
  final ThemeData lightheme = ThemeData(
    primarySwatch: Colors.indigo,
    brightness: Brightness.light,
    accentColorBrightness: Brightness.light,
    primaryColorBrightness: Brightness.light,
    appBarTheme: AppBarTheme(
        color: Colors.white,
        elevation: 0,
        textTheme: TextTheme(
            title: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontFamily: 'Montserrat Regular'))),
    scaffoldBackgroundColor: Colors.white,
    textTheme: TextTheme(
        body1: TextStyle(fontFamily: 'Montserrat Light', fontSize: 20)),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(color: Colors.transparent)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(color: Colors.transparent)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(color: Colors.transparent)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(color: Colors.transparent)),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(
            color: Colors.transparent,
          )),
      fillColor: Color.fromRGBO(234, 238, 255, 1.0),
      filled: true,
    ),
    errorColor: Colors.redAccent,
  );

  final ThemeData darktheme = ThemeData(
    primarySwatch: Colors.orange,
    brightness: Brightness.light,
    accentColorBrightness: Brightness.dark,
    primaryColorBrightness: Brightness.dark,
    appBarTheme: AppBarTheme(
        color: Colors.white,
        elevation: 0,
        textTheme: TextTheme(
            title: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontFamily: 'Montserrat Regular'))),
    scaffoldBackgroundColor: Colors.black45,
    textTheme: TextTheme(
        body1: TextStyle(fontFamily: 'Montserrat Light', fontSize: 20)),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(color: Colors.transparent)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(color: Colors.transparent)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(color: Colors.transparent)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(color: Colors.transparent)),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(
            color: Colors.transparent,
          )),
      fillColor: Colors.grey[900],
      filled: true,
    ),
    errorColor: Colors.redAccent,
  );
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: darkthemeEnabled ? darktheme : lightheme,
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
