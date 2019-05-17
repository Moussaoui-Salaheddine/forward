import 'package:flutter/material.dart';

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
  void signup(){
    if(_signupkey.currentState.validate())
    {
      _signupkey.currentState.save();
    }
  }
}
