import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:forward/chat.dart';
import 'package:forward/dynamictheme.dart';
import 'package:forward/firehelp.dart';

class Messages extends StatefulWidget {
  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages>
    with AutomaticKeepAliveClientMixin {
  Widget _buildChatLayout(BuildContext context, DocumentSnapshot document) {
    return Container(
        child: InkWell(
            splashColor: DynamicTheme.darkthemeBreak,
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Chat(document)));
            },
            child: Row(
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width / 20,
                        top: MediaQuery.of(context).size.width / 50,
                        bottom: MediaQuery.of(context).size.width / 50,
                        right: MediaQuery.of(context).size.width / 20),
                    child: StreamBuilder<DocumentSnapshot>(
                        stream: Firestore.instance
                            .collection("chats")
                            .document(document.documentID)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(child: Text('Loading...'));
                          } else {
                            return CircleAvatar(
                              backgroundImage: CachedNetworkImageProvider(
                                  snapshot.data['chatimageurl']),
                              maxRadius: 32,
                            );
                          }
                        })),
                Expanded(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                      Container(
                          child: StreamBuilder<DocumentSnapshot>(
                              stream: Firestore.instance
                                  .collection("chats")
                                  .document(document.documentID)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Center(child: Text('Loading...'));
                                } else {
                                  return Text(snapshot.data['chattitle'],
                                      overflow: TextOverflow.ellipsis);
                                }
                              })),
                      Container(
                          child: StreamBuilder<QuerySnapshot>(
                              stream: Firestore.instance
                                  .collection("chats")
                                  .document(document.documentID)
                                  .collection("message")
                                  .orderBy("messagetimestamp", descending: true)
                                  .limit(1)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Center(child: Text('Loading...'));
                                } else {
                                  return Text(
                                      snapshot.data.documents[0]
                                          .data["messagetext"],
                                      style: TextStyle(fontSize: 12),
                                      overflow: TextOverflow.ellipsis);
                                }
                              }))
                    ])),
                Container(
                    margin: EdgeInsets.only(
                        right: MediaQuery.of(context).size.width / 20),
                    child: StreamBuilder<QuerySnapshot>(
                      stream: Firestore.instance
                          .collection("chats")
                          .document(document.documentID)
                          .collection("message")
                          .orderBy("messagetimestamp", descending: true)
                          .limit(1)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: Text('Loading...'));
                        } else {
                          return Text(
                              DateTime.fromMillisecondsSinceEpoch(DateTime.now().millisecondsSinceEpoch - snapshot.data.documents[0].data["messagetimestamp"].millisecondsSinceEpoch).hour > 1
                                  ? DateTime.fromMillisecondsSinceEpoch(
                                              DateTime.now()
                                                      .millisecondsSinceEpoch -
                                                  snapshot
                                                      .data
                                                      .documents[0]
                                                      .data["messagetimestamp"]
                                                      .millisecondsSinceEpoch)
                                          .hour
                                          .toString() +
                                      " h ago"
                                  : (DateTime.fromMillisecondsSinceEpoch(DateTime.now().millisecondsSinceEpoch - snapshot.data.documents[0].data["messagetimestamp"].millisecondsSinceEpoch)
                                              .minute >
                                          1)
                                      ? DateTime.fromMillisecondsSinceEpoch(DateTime.now()
                                                      .millisecondsSinceEpoch -
                                                  snapshot
                                                      .data
                                                      .documents[0]
                                                      .data["messagetimestamp"]
                                                      .millisecondsSinceEpoch)
                                              .minute
                                              .toString() +
                                          " mins ago"
                                      : "Just now",
                              style: TextStyle(fontSize: 12));
                        }
                      },
                    ))
              ],
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance
                .collection("chats")
                .where('chatparticipants',
                    arrayContains: Firebase.getUser().uid.toString())
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: Text("no chats"));
              } else {
                return ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, position) {
                    return _buildChatLayout(
                      context,
                      snapshot.data.documents[position],
                    );
                  },
                );
              }
            }));
  }

  @override
  bool get wantKeepAlive => true;
}
