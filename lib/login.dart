import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:forward/Home/widget/gradientraisedbutton.dart';
import 'package:forward/firehelp.dart';
import 'package:forward/home.dart';
import 'package:forward/signup.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        children: <Widget>[
          Container(
            margin:
                EdgeInsets.only(top: MediaQuery.of(context).size.height / 10),
            child: Center(
              child: Form(
                key: _loginkey,
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
                      width: MediaQuery.of(context).size.width / 2,
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
                    Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height / 20)),
                    Text('OR'),
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
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> login() async {
    if (_loginkey.currentState.validate()) {
      _loginkey.currentState.save();
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: _email, password: _password)
          .then((fireBaseUser) {
        Firebase.setUser(fireBaseUser);
        Firestore.instance.runTransaction((transaction) async {
          await transaction.update(
              Firestore.instance.collection("users").document(fireBaseUser.uid),
              {"userisactive": true});
          //FirebaseAuth.instance.sendSignInWithEmailLink();
        });
      }).catchError((e) {
        print(e);
      });

      Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
    }
  }
}
