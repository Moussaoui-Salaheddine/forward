import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:forward/auth/login.dart';
import 'package:forward/dynamictheme.dart';
import 'package:forward/firehelp.dart';
import 'package:forward/widgets/gradientraisedbutton.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: DynamicTheme.darkthemeEnabled
          ? DynamicTheme.darktheme
          : DynamicTheme.lightheme,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Settings'),
          centerTitle: true,
        ),
        body: Center(
            child: Container(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('enable dark theme: '),
                    Switch(
                      activeColor: DynamicTheme.darkthemeAccent,
                      value: DynamicTheme.darkthemeEnabled,
                      onChanged: (value) {
                        setState(() {
                          DynamicTheme.darkthemeEnabled = value;
                          _save(value);
                        });
                      },
                    ),
                  ],
                ),
              ),
              Container(
                  width: MediaQuery.of(context).size.width / 2,
                  height: MediaQuery.of(context).size.width / 8,
                  child: RaisedGradientButton(
                    child: Text(
                      'Log Out',
                      style: TextStyle(
                          color: Colors.white, fontFamily: 'Montserrat Medium'),
                    ),
                    gradient: LinearGradient(
                      colors: <Color>[
                        Color.fromRGBO(102, 140, 255, 1.0),
                        Color.fromRGBO(110, 62, 220, 1.0)
                      ],
                    ),
                    onPressed: confirmLogout,
                  )),
            ]))),
      ),
    );
  }

  _save(value) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'darktheme';
    prefs.setBool(key, value);
  }

  Future<Widget> confirmLogout() async {
    return showDialog(
        context: context,
        builder: (context) {
          return Theme(
            data: DynamicTheme.darkthemeEnabled
                ? DynamicTheme.darktheme
                : DynamicTheme.lightheme,
            child: AlertDialog(
              title: Text("logout"),
              content: Text('do you really want to logout?'),
              actions: <Widget>[
                FlatButton(
                  child: Text("logout"),
                  onPressed: logout,
                ),
                FlatButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  Future<void> logout() async {
    await Firestore.instance.runTransaction((transaction) async {
      await transaction.update(
          Firestore.instance
              .collection("users")
              .document(Firebase.getUser().uid),
          {"userisactive": false});
    });
    await FirebaseAuth.instance.signOut();
    Firebase.setUser(null);
    Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
  }
}
