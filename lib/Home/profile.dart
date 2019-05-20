import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:forward/Home/widget/gradientraisedbutton.dart';
import 'package:forward/firehelp.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:forward/login.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String _bioUpdate;
  GlobalKey<FormState> _changebiokey = GlobalKey<FormState>();
  DocumentSnapshot firestoreUser;
  Widget _buildProfile(BuildContext context, DocumentSnapshot document) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height / 150,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              document['userisactive'] ? Colors.green : Colors.red,
              document['userisactive'] ? Colors.greenAccent : Colors.redAccent,
            ])),
          ),
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
                          color: document['userisactive']
                              ? Colors.greenAccent
                              : Colors.redAccent),
                      borderRadius: BorderRadius.circular(
                          MediaQuery.of(context).size.width / 8)),
                  child: CachedNetworkImage(
                      imageUrl: document['userimageurl'].toString()),
                ),
              ),
              SizedBox(width: 30),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Text(
                      document['username'].toString(),
                      style: TextStyle(fontFamily: 'Montserrat Medium'),
                    ),
                  ),
                  Container(
                    child: Text(
                      document['usermail'].toString(),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            margin:
                EdgeInsets.only(top: MediaQuery.of(context).size.height / 20),
            child: Text(document['userbio'].toString()),
          ),
          Container(
            margin:
                EdgeInsets.only(top: MediaQuery.of(context).size.height / 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                    width: MediaQuery.of(context).size.width / 2,
                    height: MediaQuery.of(context).size.width / 8,
                    child: RaisedGradientButton(
                      child: Text(
                        'logout',
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
                      onPressed: logout,
                    )),
                Container(
                  width: MediaQuery.of(context).size.width / 6,
                  height: MediaQuery.of(context).size.width / 8,
                  child: RaisedButton(
                    child: Icon(Icons.create, color: Colors.black45),
                    color: Colors.amberAccent[50],
                    elevation: 0,
                    onPressed: () {
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
                                FlatButton(
                                  child: Text("Save"),
                                  onPressed: updatebio,
                                ),
                                FlatButton(
                                  child: Text("Close"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          });
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance
            .collection('users')
            .document(Firebase.getUser().uid.toString())
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Text('Loading..');
          else
            return _buildProfile(context, snapshot.data);
        },
      ),
    );
  }

  Future<void> logout() async {
    await Firestore.instance.runTransaction((transaction) async {
      await transaction.update(
          Firestore.instance
              .collection("users")
              .document(Firebase.getUser().uid),
          {"userisactive": false});
      //FirebaseAuth.instance.sendSignInWithEmailLink();
    });
    await FirebaseAuth.instance.signOut();
    Firebase.setUser(null);
    Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
  }

  Future<void> updatebio() async {
    if (_changebiokey.currentState.validate()) {
      _changebiokey.currentState.save();
      await Firestore.instance.runTransaction((transaction) async {
        await transaction.update(
            Firestore.instance
                .collection("users")
                .document(Firebase.getUser().uid),
            {"userbio": _bioUpdate});
      });
      Navigator.pop(context);
    }
  }
}
