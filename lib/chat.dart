import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:forward/dynamictheme.dart';
import 'package:forward/firehelp.dart';

class Chat extends StatefulWidget {
  final DocumentSnapshot document;
  final String imagpath;
  Chat(this.document, this.imagpath);
  @override
  State<StatefulWidget> createState() {
    return _StateChat(document, imagpath);
  }
}

class _StateChat extends State<Chat> {
  DocumentSnapshot document;
  String imagpath;
  _StateChat(this.document, this.imagpath);

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
                  if (!snapshot.hasData) {
                    return Center(child: Text('Loading...'));
                  } else {
                    return Column(
                      children: <Widget>[
                        Expanded(
                          child: ListView.builder(
                            controller: scrollController,
                            itemCount: snapshot.data.documents.length,
                            itemBuilder: (BuildContext context, int index) {
                              if (snapshot
                                      .data.documents[index]['messagesender']
                                      .toString() ==
                                  Firebase.getUser().uid.toString())
                                return getSentMessageLayout(
                                    snapshot.data.documents[index]);
                              return getReceivedMessageLayout(
                                  snapshot.data.documents[index]);
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
                  }
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
            "messagetext": _textinput,
            "messagetimestamp": DateTime.now(),
            "messagesender": Firebase.getUser().uid.toString()
          });

      String s1 = document.documentID.substring(0, 28);
      String s2 = document.documentID.substring(28, 56);
      print(s1);
      String result = s2 + s1;

      await transaction.set(
          Firestore.instance
              .collection("chats")
              .document(result)
              .collection("message")
              .document(),
          {
            "messagetext": _textinput,
            "messagetimestamp": DateTime.now(),
            "messagesender": Firebase.getUser().uid.toString()
          });
    });

    Future.delayed(Duration(milliseconds: 50), () {
      scrollController.animateTo(scrollController.position.maxScrollExtent,
          curve: Curves.easeOut, duration: Duration(milliseconds: 400));
    });
  }

  Widget getSentMessageLayout(DocumentSnapshot document) {
    return Theme(
      data: DynamicTheme.darkthemeEnabled
          ? DynamicTheme.darktheme
          : DynamicTheme.lightheme,
      child: Container(
        margin: EdgeInsets.only(top: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 10, top: 15),
              child: Text(
                DateTime.fromMillisecondsSinceEpoch(
                            document['messagetimestamp'].millisecondsSinceEpoch)
                        .hour
                        .toString() +
                    ':' +
                    DateTime.fromMillisecondsSinceEpoch(
                            document['messagetimestamp'].millisecondsSinceEpoch)
                        .minute
                        .toString(),
                style: TextStyle(fontSize: 18),
              ),
            ),
            Card(
              elevation: 0,
              color: DynamicTheme.darkthemeBreak,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40.0),
                      bottomRight: Radius.circular(0),
                      topRight: Radius.circular(40.0),
                      topLeft: Radius.circular(40.0))),
              margin: EdgeInsets.only(right: 10),
              child: InkWell(
                onLongPress: () {
                  confirmDeleteMessage(document.documentID.toString());
                },
                child: Container(
                  margin: EdgeInsets.all(10),
                  constraints: BoxConstraints(
                    maxWidth: 200.0,
                  ),
                  child: Text(
                    document['messagetext'],
                    style: TextStyle(
                        fontFamily: 'Montserrat Medium', color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Widget> confirmDeleteMessage(String messageID) async {
    return showDialog(
        context: context,
        builder: (context) {
          return Theme(
            data: DynamicTheme.darkthemeEnabled
                ? DynamicTheme.darktheme
                : DynamicTheme.lightheme,
            child: SimpleDialog(
              title: Text("Delete Message"),
              children: <Widget>[
                Padding(padding: EdgeInsets.only(top: 20)),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        deleteforme(messageID);
                      },
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('Delete for myself'),
                            Icon(Icons.delete)
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        deleteforall(messageID);
                      },
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('Delete for everyone'),
                            Icon(Icons.delete)
                          ],
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          );
        });
  }

  Future<void> deleteforall(String messageID) async {
    Firestore.instance.runTransaction((transaction) async {
      await transaction.delete(Firestore.instance
          .collection("chats")
          .document(document.documentID)
          .collection("message")
          .document(messageID));

      String s1 = document.documentID.substring(0, 28);
      String s2 = document.documentID.substring(28, 56);
      print(s1);
      String result = s2 + s1;

      await transaction.delete(Firestore.instance
          .collection("chats")
          .document(result)
          .collection("message")
          .document(messageID));
    });
    Navigator.of(context).pop();
  }

  Future<void> deleteforme(String messageID) async {
    Firestore.instance.runTransaction((transaction) async {
      await transaction.delete(Firestore.instance
          .collection("chats")
          .document(document.documentID)
          .collection("message")
          .document(messageID));
    });
    Navigator.of(context).pop();
  }

  Widget getReceivedMessageLayout(DocumentSnapshot document) {
    return Theme(
      data: DynamicTheme.darkthemeEnabled
          ? DynamicTheme.darktheme
          : DynamicTheme.lightheme,
      child: Container(
        margin: EdgeInsets.only(top: 15, left: 10),
        child: Row(
          children: <Widget>[
            Container(
              child: CircleAvatar(
                maxRadius: 18,
                backgroundColor: Colors.blue,
                backgroundImage: CachedNetworkImageProvider(imagpath.toString(),
                    errorListener: () {}),
              ),
            ),
            Column(
              children: <Widget>[
                Card(
                  elevation: 0,
                  color: DynamicTheme.darkthemeEnabled
                      ? DynamicTheme.darkthemeSecondary
                      : Colors.grey[350],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(0),
                          bottomRight: Radius.circular(20.0),
                          topRight: Radius.circular(20.0),
                          topLeft: Radius.circular(20.0))),
                  margin: EdgeInsets.only(left: 10),
                  child: InkWell(
                    onLongPress: () {
                      confirmDeleteMessage(document.documentID.toString());
                    },
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: 200.0,
                      ),
                      margin: EdgeInsets.all(10),
                      child: Text(
                        document['messagetext'].toString(),
                        style: TextStyle(fontFamily: 'Montserrat Medium'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(left: 10, top: 15),
              child: Text(
                DateTime.fromMillisecondsSinceEpoch(
                            document['messagetimestamp'].millisecondsSinceEpoch)
                        .hour
                        .toString() +
                    ':' +
                    DateTime.fromMillisecondsSinceEpoch(
                            document['messagetimestamp'].millisecondsSinceEpoch)
                        .minute
                        .toString(),
                style: TextStyle(fontSize: 18),
              ),
            )
          ],
        ),
      ),
    );
  }
}
