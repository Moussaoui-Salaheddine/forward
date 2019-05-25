import 'package:flutter/material.dart';

class DynamicTheme {
  static Color darkthemePrimary = Color.fromRGBO(20, 29, 38, 1.0);
  static Color darkthemeSecondary = Color.fromRGBO(36, 52, 71, 1.0);
  static Color darkthemeAccent = Color.fromRGBO(150, 177, 209, 1.0);
  static Color darkthemeBreak = Color.fromRGBO(29, 161, 242, 1.0);
  static bool darkthemeEnabled = false;
  static final ThemeData lightheme = ThemeData(
    primarySwatch: Colors.indigo,
    primaryColor: Colors.indigo,
    accentColor: Colors.indigo,
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
    cardTheme: CardTheme(elevation: 7),
  );

  static final ThemeData darktheme = ThemeData(
    primarySwatch: Colors.indigo,
    primaryColor: Colors.indigo,
    accentColor: darkthemeAccent,
    brightness: Brightness.dark,
    accentColorBrightness: Brightness.dark,
    primaryColorBrightness: Brightness.dark,
    appBarTheme: AppBarTheme(
        color: darkthemePrimary,
        elevation: 0,
        textTheme: TextTheme(
            title: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontFamily: 'Montserrat Regular'))),
    scaffoldBackgroundColor: darkthemePrimary,
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
      fillColor: darkthemePrimary,
      filled: true,
    ),
    errorColor: Colors.redAccent,
    cardTheme: CardTheme(elevation: 0, color: darkthemeSecondary),
    cardColor: darkthemeSecondary,
    buttonColor: darkthemeSecondary,
    dialogTheme: DialogTheme(
      backgroundColor: darkthemeSecondary,
      elevation: 4,
    ),
  );
}
