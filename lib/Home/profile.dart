import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:forward/auth/login.dart';
import 'package:forward/dynamictheme.dart';
import 'package:forward/firehelp.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:forward/widgets/coloredactiveindicator.dart';
import 'package:forward/widgets/gradientraisedbutton.dart';
import 'package:scoped_model/scoped_model.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with AutomaticKeepAliveClientMixin {
  String _bioUpdate;
  GlobalKey<FormState> _changebiokey = GlobalKey<FormState>();
  DocumentSnapshot firestoreUser;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
        builder: (context, child, Firebase model) => Container(
                child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  ColoredActiveIndicator(model.userisactive),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height / 20),
                        width: MediaQuery.of(context).size.width / 4,
                        height: MediaQuery.of(context).size.width / 4,
                        child: Card(
                          elevation: 7,
                          shape: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: model.userisactive
                                      ? Colors.greenAccent
                                      : Colors.redAccent),
                              borderRadius: BorderRadius.circular(
                                  MediaQuery.of(context).size.width / 8)),
                          child: CircleAvatar(
                            backgroundImage: CachedNetworkImageProvider(
                                model.userimageurl.toString()),
                          ),
                        ),
                      ),
                      SizedBox(width: 30),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            child: Text(
                              model.username.toString(),
                              style: TextStyle(fontFamily: 'Montserrat Medium'),
                            ),
                          ),
                          Container(
                            child: Text(
                              model.usermail.toString(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 20),
                    child: Text(model.userbio.toString()),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                            width: MediaQuery.of(context).size.width / 2,
                            height: MediaQuery.of(context).size.width / 8,
                            child: RaisedGradientButton(
                              child: Text('logout',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Montserrat Medium')),
                              gradient: LinearGradient(
                                colors: <Color>[
                                  Color.fromRGBO(102, 140, 255, 1.0),
                                  Color.fromRGBO(110, 62, 220, 1.0)
                                ],
                              ),
                              onPressed: confirmLogout,
                            )),
                        Container(
                          width: MediaQuery.of(context).size.width / 6,
                          height: MediaQuery.of(context).size.width / 8,
                          child: RaisedButton(
                            splashColor: DynamicTheme.darkthemeBreak,
                            child: Icon(Icons.create,
                                color: DynamicTheme.darkthemeEnabled
                                    ? Colors.white
                                    : Colors.black45),
                            elevation: 0,
                            onPressed: changeBioInput,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )));
  }

  Future<Widget> confirmLogout() async {
    return showDialog(
        context: context,
        builder: (context) {
          return ScopedModelDescendant(
                  builder: (context, child, Firebase model) => AlertDialog(
                        title: Text("logout"),
                        content: Text('do you really want to logout?'),
                        actions: <Widget>[
                          FlatButton(
                            child: Text("logout"),
                            onPressed: () async {
                              await Firestore.instance
                                  .runTransaction((transaction) async {
                                await transaction.update(
                                    Firestore.instance
                                        .collection("users")
                                        .document(model.user.uid.toString()),
                                    {"userisactive": false});
                              });
                              await FirebaseAuth.instance.signOut();
                              // Firebase.setUser(null);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Login()));
                            },
                          ),
                          FlatButton(
                            child: Text("Cancel"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ));
      });
  }

  Future<Widget> changeBioInput() async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("change bio"),
            content: Form(
              key: _changebiokey,
              child: TextFormField(
                validator: (input) {
                  if (input.length == 0) {
                    return 'bio cannot be empty';
                  }
                },
                onSaved: (input) {
                  setState(() {
                    _bioUpdate = input;
                  });
                },
              ),
            ),
            actions: <Widget>[
              ScopedModel<Firebase>(
                  model: Firebase(),
                  child: ScopedModelDescendant(
                      builder: (context, child, Firebase model) => FlatButton(
                          child: Text("Save",
                              style: TextStyle(
                                  color: DynamicTheme.darkthemeBreak)),
                          onPressed: () async {
                            if (_changebiokey.currentState.validate()) {
                              _changebiokey.currentState.save();
                              await Firestore.instance
                                  .runTransaction((transaction) async {
                                await transaction.update(
                                    Firestore.instance
                                        .collection("users")
                                        .document(model.user.uid),
                                    {"userbio": _bioUpdate});
                              });
                              Navigator.pop(context);
                            }
                          }))),
              FlatButton(
                child: Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  @override
  bool get wantKeepAlive => true;
}
