import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:forward/dynamictheme.dart';
import 'package:forward/firehelp.dart';

class Chat extends StatefulWidget {
  DocumentSnapshot document;
  Chat(this.document);
  @override
  State<StatefulWidget> createState() {
    return _StateChat(document);
  }
}

class _StateChat extends State<Chat> {
  DocumentSnapshot document;
  _StateChat(this.document);

  GlobalKey<FormState> _sendMessagekey = GlobalKey<FormState>();
  TextEditingController _textFieldController = new TextEditingController();
  ScrollController scrollController;
  String _textinput;

  @override
  void initState() {
    scrollController = ScrollController();
    super.initState();
  }

  Widget build(BuildContext context) {
    var textinput = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Expanded(
          child: Form(
            key: _sendMessagekey,
            child: TextFormField(
              controller: _textFieldController,
              decoration: InputDecoration(
                hintText: 'Aa',
                prefixIcon: IconButton(
                  splashColor: Colors.transparent,
                  icon: Icon(
                    Icons.apps,
                  ),
                  onPressed: () {},
                ),
                suffixIcon: IconButton(
                  splashColor: Colors.transparent,
                  icon: Icon(
                    Icons.send,
                  ),
                  onPressed: handleSendingMessage,
                ),
              ),
              onSaved: (input) {
                setState(() {
                  _textinput = input;
                });
              },
            ),
          ),
        ),
      ],
    );
    return Theme(
        data: DynamicTheme.darkthemeEnabled
            ? DynamicTheme.darktheme
            : DynamicTheme.lightheme,
        child: Scaffold(
          resizeToAvoidBottomPadding: true,
          appBar: AppBar(title: Text(document['chattitle']), centerTitle: true),
          body: Container(
            margin:
                EdgeInsets.only(top: MediaQuery.of(context).size.width / 20),
            child: StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance
                    .collection("chats")
                    .document(document.documentID)
                    .collection("message")
                    .orderBy("messagetimestamp", descending: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  return Column(
                    children: <Widget>[
                      Expanded(
                        child: ListView.builder(
                          controller: scrollController,
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (BuildContext context, int index) {
                            if (snapshot
                                    .data.documents[index]['messagesenderid']
                                    .toString() ==
                                Firebase.getUser().uid.toString())
                              return getSentMessageLayout(snapshot
                                  .data.documents[index]['messagetext']
                                  .toString());
                            return getReceivedMessageLayout(snapshot
                                .data.documents[index]['messagetext']
                                .toString());
                          },
                        ),
                      ),
                      Divider(
                        height: 2.0,
                      ),
                      Container(
                        child: textinput,
                      )
                    ],
                  );
                }),
          ),
        ));
  }

  Future<void> handleSendingMessage() async {
    _sendMessagekey.currentState.save();
    setState(() {
      var text = _textFieldController.value.text.toString();
      if (text.isNotEmpty) {
        _textFieldController.clear();
      }
    });

    Firestore.instance.runTransaction((transaction) async {
      await transaction.set(
          Firestore.instance
              .collection("chats")
              .document(document.documentID)
              .collection("message")
              .document(),
          {
            "messagereceiverid": "",
            "messagesenderid": Firebase.getUser().uid.toString(),
            "messagetext": _textinput,
            "messagetimestamp": DateTime.now(),
          });
    });

    Future.delayed(Duration(milliseconds: 50), () {
      scrollController.animateTo(scrollController.position.maxScrollExtent,
          curve: Curves.easeOut, duration: Duration(milliseconds: 400));
    });
  }

  Widget getSentMessageLayout(String message) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Card(
            color: DynamicTheme.darkthemeBreak,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40.0),
                    bottomRight: Radius.circular(0),
                    topRight: Radius.circular(40.0),
                    topLeft: Radius.circular(40.0))),
            margin: EdgeInsets.only(right: 10),
            child: Container(
              margin: EdgeInsets.all(10),
              constraints: BoxConstraints(
                maxWidth: 200.0,
              ),
              child: Text(
                message,
                style: TextStyle(fontFamily: 'Montserrat Medium '),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getReceivedMessageLayout(String message) {
    return Container(
      margin: EdgeInsets.only(top: 10, left: 10),
      child: Row(
        children: <Widget>[
          Container(
            width: 35,
            height: 35,
            child: CircleAvatar(),
          ),
          Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(0),
                    bottomRight: Radius.circular(40.0),
                    topRight: Radius.circular(40.0),
                    topLeft: Radius.circular(40.0))),
            margin: EdgeInsets.only(left: 10),
            child: Container(
              constraints: BoxConstraints(
                maxWidth: 200.0,
              ),
              margin: EdgeInsets.all(10),
              child: Text(
                message,
                style: TextStyle(fontFamily: 'Montserrat Medium'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
