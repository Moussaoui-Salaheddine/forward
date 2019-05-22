import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:forward/dynamictheme.dart';
import 'package:forward/widget/gradientraisedbutton.dart';

class ContactProfile extends StatefulWidget {
  final DocumentSnapshot document;
  ContactProfile(this.document);
  @override
  _ContactProfileState createState() => _ContactProfileState(document);
}

class _ContactProfileState extends State<ContactProfile> {
  DocumentSnapshot document;
  String _newMessage;
  _ContactProfileState(this.document);
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: DynamicTheme.darkthemeEnabled
          ? DynamicTheme.darktheme
          : DynamicTheme.lightheme,
      child: Scaffold(
        appBar: AppBar(title: Text(document['username']), centerTitle: true),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height / 150,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                  document['userisactive'] ? Colors.green : Colors.red,
                  document['userisactive']
                      ? Colors.greenAccent
                      : Colors.redAccent,
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
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 20),
                child: Text(document['userbio'].toString()),
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
                          child: Text(
                            'send a message',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Montserrat Medium'),
                          ),
                          gradient: LinearGradient(
                            colors: <Color>[
                              Color.fromRGBO(255, 81, 47, 1.0),
                              Color.fromRGBO(221, 36, 118, 1.0)
                            ],
                          ),
                          onPressed: () {
                            return showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("send a message"),
                                    content: Form(
                                      child: TextFormField(
                                        validator: (input) {
                                          if (input.length == 0) {
                                            return 'message is empty';
                                          }
                                        },
                                        onSaved: (input) {
                                          setState(() {
                                            _newMessage = input;
                                          });
                                        },
                                      ),
                                    ),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text("Send"),
                                        onPressed: () {},
                                      ),
                                      FlatButton(
                                        child: Text("Cancel"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                });
                          },
                        )),
                    Container(
                      width: MediaQuery.of(context).size.width / 6,
                      height: MediaQuery.of(context).size.width / 8,
                      child: RaisedButton(
                        child: Icon(Icons.block),
                        color: Colors.amberAccent[50],
                        elevation: 0,
                        onPressed: () {
                          return showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("block"),
                                  content: Text('do you really want to block ' +
                                      document['username'] +
                                      ' ?'),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text("block",
                                          style: TextStyle(
                                              color: Colors.redAccent)),
                                      onPressed: () {},
                                    ),
                                    FlatButton(
                                      child: Text("Cancel"),
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
        ),
      ),
    );
  }
}
