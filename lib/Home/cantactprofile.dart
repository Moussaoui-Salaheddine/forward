import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:forward/dynamictheme.dart';
import 'package:forward/firehelp.dart';
import 'package:forward/widgets/coloredactiveindicator.dart';
import 'package:forward/widgets/gradientraisedbutton.dart';

class ContactProfile extends StatefulWidget {
  final DocumentSnapshot document;
  ContactProfile(this.document);
  @override
  _ContactProfileState createState() => _ContactProfileState(document);
}

class _ContactProfileState extends State<ContactProfile>
    with AutomaticKeepAliveClientMixin {
  DocumentSnapshot document;
  String _newMessage;
  _ContactProfileState(this.document);
  GlobalKey<FormState> _sendMessagekey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: DynamicTheme.darkthemeEnabled
          ? DynamicTheme.darktheme
          : DynamicTheme.lightheme,
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text(document['username']),
          centerTitle: true,
          actions: <Widget>[
            PopupMenuButton<Menu>(
              icon: Icon(Icons.more_horiz),
              onSelected: (Menu result) {
                _handleMenuSelection(result);
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
                    PopupMenuItem<Menu>(
                      value: Menu.setting1,
                      child: Text('block'),
                    )
                  ],
            )
          ],
        ),
        body: Container(
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
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 20),
                child: Text(document['userbio'].toString()),
              ),
              Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 5),
                child: Container(
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
                      onPressed: sendMessage,
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Widget> sendMessage() async {
    return showDialog(
        context: context,
        builder: (context) {
          return Theme(
            data: DynamicTheme.darkthemeEnabled
                ? DynamicTheme.darktheme
                : DynamicTheme.lightheme,
            child: AlertDialog(
              title: Text("send a message"),
              content: Form(
                key: _sendMessagekey,
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
                  child: Text("Send",
                      style: TextStyle(color: DynamicTheme.darkthemeBreak)),
                  onPressed: createChat,
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

  Future<Widget> blockUser() async {
    return showDialog(
        context: context,
        builder: (context) {
          return Theme(
            data: DynamicTheme.darkthemeEnabled
                ? DynamicTheme.darktheme
                : DynamicTheme.lightheme,
            child: AlertDialog(
              title: Text("block"),
              content: Text(
                  'do you really want to block ' + document['username'] + ' ?'),
              actions: <Widget>[
                FlatButton(
                  child:
                      Text("block", style: TextStyle(color: Colors.redAccent)),
                  onPressed: () {},
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

  Future<void> createChat() async {
    if (_sendMessagekey.currentState.validate()) {
      _sendMessagekey.currentState.save();
      Firestore.instance.runTransaction((transaction) async {
        await transaction.set(
            Firestore.instance.collection("chats").document(
                document['useruid'].toString() +
                    Firebase.getUser().uid.toString()),
            {
              "chattitle": document['username'].toString() + ', ',
              "chatparticipants": [
                document['useruid'].toString(),
                Firebase.getUser().uid.toString()
              ],
              "chatimageurl":
                  "https://www.neolutionesport.com/wp-content/uploads/2017/03/default-avatar-knives-ninja.png",
            });
        await transaction.set(
            Firestore.instance
                .collection("chats")
                .document(document['useruid'].toString() +
                    Firebase.getUser().uid.toString())
                .collection("message")
                .document(),
            {
              "messagereceiverid": document['useruid'].toString(),
              "messagesenderid": Firebase.getUser().uid.toString(),
              "messagetext": _newMessage,
              "messagetimestamp": DateTime.now(),
            });
      });
      Navigator.pop(context);
    }
  }

  void _handleMenuSelection(Menu index) {
    if (index == Menu.setting1) {
      blockUser();
    }
  }

  @override
  bool get wantKeepAlive => true;
}

enum Menu { setting1, setting2, setting3 }
