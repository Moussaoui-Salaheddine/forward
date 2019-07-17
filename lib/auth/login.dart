import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:forward/auth/resetpassword.dart';
import 'package:forward/dynamictheme.dart';
import 'package:forward/firehelp.dart';
import 'package:forward/home.dart';
import 'package:forward/widgets/gradientraisedbutton.dart';
import 'signup.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String _email, _password;
  final GlobalKey<FormState> _loginkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: DynamicTheme.lightheme,
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/asset1.png'), fit: BoxFit.cover)),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Container(
              child: ListView(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 1.8),
                    child: Center(
                      child: Form(
                        key: _loginkey,
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width / 1.2,
                              child: TextFormField(
                                decoration: InputDecoration(
                                    fillColor: Colors.white,
                                    prefixIcon: Icon(Icons.mail),
                                    hintText: 'email'),
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
                                    top: MediaQuery.of(context).size.height /
                                        40)),
                            Container(
                              width: MediaQuery.of(context).size.width / 1.2,
                              child: TextFormField(
                                decoration: InputDecoration(
                                    fillColor: Colors.white,
                                    prefixIcon: Icon(Icons.lock),
                                    hintText: 'password'),
                                obscureText: true,
                                validator: (input) {
                                  if (input.length < 6) {
                                    return 'password cannot be less than 6 characters long';
                                  }
                                },
                                onSaved: (input) {
                                  _password = input;
                                },
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height /
                                        30)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Container(
                                  width: MediaQuery.of(context).size.width / 3,
                                  child: RaisedGradientButton(
                                    child: Text(
                                      'login',
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
                                    onPressed: login,
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width / 3,
                                  child: RaisedGradientButton(
                                    child: Text(
                                      'signup',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Montserrat Medium'),
                                    ),
                                    gradient: LinearGradient(
                                      colors: <Color>[
                                        Color.fromRGBO(249, 83, 198, 1.0),
                                        Color.fromRGBO(185, 29, 115, 1.0)
                                      ],
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Signup()));
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                                padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height /
                                        35)),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ResetPassword()));
                              },
                              child: Container(
                                child: Center(
                                  child: Text(
                                    'forgot password?',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> login() async {
    if (_loginkey.currentState.validate()) {
      _loginkey.currentState.save();
      showDialog(
          context: context,
          builder: (dcontext) {
            return SimpleDialog(
              title: Text("Loading..."),
              titlePadding: EdgeInsets.all(12),
              contentPadding: EdgeInsets.all(16),
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 20, bottom: 20),
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                  ),
                )
              ],
            );
          });
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: _email, password: _password)
          .then((fireBaseUser) {
        Firebase.setUser(fireBaseUser);
        Firestore.instance.runTransaction((transaction) async {
          await transaction.update(
              Firestore.instance.collection("users").document(fireBaseUser.uid),
              {"userisactive": true});
        });
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Home()));
      }).catchError((e) {
        showDialog(
            context: context,
            builder: (context) {
              print(e.toString());
              return AlertDialog(
                  title: Text("Login Error"),
                  content: Text(e.toString() ==
                          "PlatformException(ERROR_USER_NOT_FOUND, There is no user record corresponding to this identifier. The user may have been deleted., null)"
                      ? "User does not exist !"
                      : e.toString() ==
                              "PlatformException(ERROR_WRONG_PASSWORD, The password is invalid or the user does not have a password., null)"
                          ? "Password Incorrect !"
                          : e.toString() ==
                                  "PlatformException(ERROR_NETWORK_REQUEST_FAILED, A network error (such as timeout, interrupted connection or unreachable host) has occurred., null)"
                              ? "Not Network Connection !"
                              : e.toString()),
                  actions: <Widget>[
                    FlatButton(
                        child: Text("Close"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        })
                  ]);
            });
      });
      
    }
  }
}
