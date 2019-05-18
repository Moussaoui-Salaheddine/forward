import 'package:flutter/material.dart';
import 'package:forward/firehelp.dart';

class Messages extends StatefulWidget {
  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(Firebase.getUser().uid),
      ),
    );
  }
}