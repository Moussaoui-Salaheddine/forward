import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:forward/dynamictheme.dart';
import 'package:forward/widgets/gradientraisedbutton.dart';
import 'login.dart';

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  String _email;
  final GlobalKey<FormState> _signupkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: DynamicTheme.lightheme,
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/asset3.png'), fit: BoxFit.cover)),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Color.fromRGBO(241, 239, 241, 1.0),
          ),
          body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: ListView(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 1.8),
                  child: Center(
                    child: Form(
                      key: _signupkey,
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
                                  top:
                                      MediaQuery.of(context).size.height / 20)),
                          Container(
                            width: MediaQuery.of(context).size.width / 2.5,
                            child: RaisedGradientButton(
                              child: Text(
                                'reset password',
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
                              onPressed: reset,
                            ),
                          ),
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
    );
  }

  Future<void> reset() async {
    if (_signupkey.currentState.validate()) {
      _signupkey.currentState.save();
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
          .sendPasswordResetEmail(email: _email)
          .catchError((e) {
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

      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
    }
  }
}
