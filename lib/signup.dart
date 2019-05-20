import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:forward/Home/widget/gradientraisedbutton.dart';
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
      body: ListView(
        children: <Widget>[
          Container(
            margin:
                EdgeInsets.only(top: MediaQuery.of(context).size.height / 10),
            child: Center(
              child: Form(
                key: _signupkey,
                child: Column(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width / 1.2,
                      child: TextFormField(
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.mail), hintText: 'email'),
                        validator: (input) {
                          if (input.length == 0) {
                            return 'email is empty';
                          }
                        },
                        onSaved: (input) {
                          _email = input;
                        },
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height / 20)),
                    Container(
                      width: MediaQuery.of(context).size.width / 1.2,
                      child: TextFormField(
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock), hintText: 'password'),
                        obscureText: true,
                        validator: (input) {
                          if (input.length < 6) {
                            return 'password is less than 6';
                          }
                        },
                        onSaved: (input) {
                          _password = input;
                        },
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height / 20)),
                    Container(
                      width: MediaQuery.of(context).size.width / 1.2,
                      child: TextFormField(
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person), hintText: 'username'),
                        obscureText: true,
                        validator: (input) {
                          if (input.length == 0) {
                            return 'username is empty';
                          }
                        },
                        onSaved: (input) {
                          _username = input;
                        },
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height / 20)),
                    Container(
                      width: MediaQuery.of(context).size.width / 2,
                      child: RaisedGradientButton(
                        child: Text(
                          'signup',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Montserrat Medium'),
                        ),
                        gradient: LinearGradient(
                          colors: <Color>[
                            Color.fromRGBO(102, 140, 255, 1.0),
                            Color.fromRGBO(110, 62, 220, 1.0)
                          ],
                        ),
                        onPressed: signup,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
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
