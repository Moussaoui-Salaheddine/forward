import 'package:flutter/material.dart';
import 'package:forward/home.dart';
import 'package:forward/login.dart';

main() {
  runApp(Forward());
}

class Forward extends StatelessWidget {
  final ThemeData lightheme = ThemeData(
    primarySwatch: Colors.deepOrange
  );
  final ThemeData darktheme = ThemeData(
    primarySwatch: Colors.grey
  );
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightheme,
      darkTheme: darktheme,
      debugShowCheckedModeBanner: false,
      home: Login(),
    );
  }
}
