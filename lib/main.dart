import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forward/auth/login.dart';
import 'package:forward/firehelp.dart';
import 'package:forward/home.dart';
import 'package:scoped_model/scoped_model.dart';

main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
    statusBarColor: Colors.transparent,
  ));
  runApp(Forward());
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
    return ScopedModel<Firebase>(
      model: Firebase(),
      child: ScopedModelDescendant(
        builder: (context, child, Firebase model) =>
            StreamBuilder<FirebaseUser>(
              stream: FirebaseAuth.instance.onAuthStateChanged,
              builder: (context, snapShot) {
                if (snapShot.connectionState == ConnectionState.waiting)
                  return Material(
                    child: Center(child: Text('Loading...')),
                  );
                else if (!snapShot.hasData) {
                  return Login();
                } else {
                  model.setuser(snapShot.data);
                  return Home();
                }
              },
            ),
      ),
    );
  }
}
