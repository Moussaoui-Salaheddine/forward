import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:forward/firehelp.dart';
import 'package:forward/login.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  String _email, _password, _username;
  final GlobalKey<FormState> _signupkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Signup'),
        centerTitle: true,
      ),
      body: Container(
        child: Form(
          key: _signupkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'email'),
                validator: (input) {
                  if (input.length == 0) {
                    return 'email is empty';
                  }
                },
                onSaved: (input) {
                  setState(() {
                    _email = input;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'password'),
                obscureText: true,
                validator: (input) {
                  if (input.length < 6) {
                    return 'password is < 6';
                  }
                },
                onSaved: (input) {
                  setState(() {
                    _password = input;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'username'),
                validator: (input) {
                  if (input.length == 0) {
                    return 'username is empty';
                  }
                },
                onSaved: (input) {
                  setState(() {
                    _username = input;
                  });
                },
              ),
              Padding(padding: EdgeInsets.only(top: 20)),
              RaisedButton(
                child: Text('Signup'),
                onPressed: signup,
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> signup() async {
    if (_signupkey.currentState.validate()) {
      _signupkey.currentState.save();
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: _email, password: _password)
          .then((fireBaseUser) {
        Firestore.instance.runTransaction((transaction) async {
          await transaction.set(
              Firestore.instance.collection("users").document(fireBaseUser.uid),
              {
                "username": this._username,
                "usermail": this._email,
                "userpassword": this._password,
                "userbio": "new user default bio",
                "userimageurl":
                    "https://cdn1.iconfinder.com/data/icons/ninja-things-1/720/ninja-background-512.png",
                "userisactive": true,
              });
              //FirebaseAuth.instance.sendSignInWithEmailLink();
        });
      }).catchError((e) {
        print(e);
      });

      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
    }
  }
}
