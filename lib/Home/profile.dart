import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:forward/auth/login.dart';
import 'package:forward/dynamictheme.dart';
import 'package:forward/firehelp.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:forward/widgets/coloredactiveindicator.dart';
import 'package:forward/widgets/gradientraisedbutton.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with AutomaticKeepAliveClientMixin {
  String _bioUpdate;
  GlobalKey<FormState> _changebiokey = GlobalKey<FormState>();
  DocumentSnapshot firestoreUser;
  Widget _buildProfile(BuildContext context, DocumentSnapshot document) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          ColoredActiveIndicator(document['userisactive']),
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
                  child: CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(
                        document['userimageurl'].toString()),
                  ),
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
                EdgeInsets.only(top: MediaQuery.of(context).size.height / 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
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
            return Center(child: Text('Loading...'));
          else
            return _buildProfile(context, snapshot.data);
        },
      ),
    );
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
              FlatButton(
                child: Text("Save",
                    style: TextStyle(color: DynamicTheme.darkthemeBreak)),
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
  }

  @override
  bool get wantKeepAlive => true;
}
