import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:forward/dynamictheme.dart';
import 'package:forward/firehelp.dart';
import 'package:scoped_model/scoped_model.dart';

class Chat extends StatefulWidget {
  final DocumentSnapshot document;
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
        ScopedModel<Firebase>(
            model: Firebase(),
            child: ScopedModelDescendant(
                builder: (context, child, Firebase model) => Expanded(
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
                              onPressed: () {
                                handleSendingMessage(model);
                              },
                            ),
                          ),
                          onSaved: (input) {
                            setState(() {
                              _textinput = input;
                            });
                          },
                        ),
                      ),
                    ))),
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
                        ScopedModel<Firebase>(
                            model: Firebase(),
                            child: ScopedModelDescendant(
                                builder: (context, child, Firebase model) =>
                                    Expanded(
                                      child: ListView.builder(
                                        controller: scrollController,
                                        itemCount:
                                            snapshot.data.documents.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          if (snapshot
                                                  .data
                                                  .documents[index]
                                                      ['messagesenderid']
                                                  .toString() ==
                                              model.user.uid.toString())
                                            return getSentMessageLayout(snapshot
                                                .data
                                                .documents[index]['messagetext']
                                                .toString());
                                          return getReceivedMessageLayout(
                                              snapshot
                                                  .data
                                                  .documents[index]
                                                      ['messagetext']
                                                  .toString());
                                        },
                                      ),
                                    ))),
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

  Future<void> handleSendingMessage(Firebase model) async {
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
            "messagesenderid": model.user.uid.toString(),
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
    return Theme(
      data: DynamicTheme.darkthemeEnabled
          ? DynamicTheme.darktheme
          : DynamicTheme.lightheme,
      child: Container(
        margin: EdgeInsets.only(top: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
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
              child: Container(
                margin: EdgeInsets.all(7),
                constraints: BoxConstraints(
                  maxWidth: 200.0,
                ),
                child: Text(
                  message,
                  style: TextStyle(
                      fontFamily: 'Montserrat Medium', color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getReceivedMessageLayout(String message) {
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
                backgroundImage:
                    CachedNetworkImageProvider(document['chatimageurl']),
              ),
            ),
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
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: 200.0,
                ),
                margin: EdgeInsets.all(7),
                child: Text(
                  message,
                  style: TextStyle(fontFamily: 'Montserrat Medium'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
