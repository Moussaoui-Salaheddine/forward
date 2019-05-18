import 'package:flutter/material.dart';
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
      ),
      body: Container(
        child: Form(
          key: _loginkey,
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
                  _email = input;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'password'),
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
              Padding(padding: EdgeInsets.only(top: 20)),
              RaisedButton(
                child: Text('Login'),
                onPressed: login,
              ),
              Padding(padding: EdgeInsets.only(top: 20)),
              RaisedButton(
                child: Text('Signup'),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Signup()));
                },
              )
            ],
          ),
        ),
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
      }).catchError((e) {
        print(e);
      });
      Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
    }
  }
}
