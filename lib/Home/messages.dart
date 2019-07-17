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
  Widget _buildChatLayout(
      BuildContext context, DocumentSnapshot document, String imagepath) {
    return Container(
        child: InkWell(
            splashColor: DynamicTheme.darkthemeBreak,
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Chat(document, imagepath)));
            },
            onLongPress: () {
              confirmdeleteconv(document);
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
                              DateTime.fromMillisecondsSinceEpoch(DateTime.now().millisecondsSinceEpoch - snapshot.data.documents[0].data["messagetimestamp"].millisecondsSinceEpoch).hour > 24
                                  ? DateTime.fromMillisecondsSinceEpoch(
                                              DateTime.now().millisecondsSinceEpoch -
                                                  snapshot
                                                      .data
                                                      .documents[0]
                                                      .data["messagetimestamp"]
                                                      .millisecondsSinceEpoch)
                                          .day
                                          .toString() +
                                      " day ago"
                                  : DateTime.fromMillisecondsSinceEpoch(DateTime.now().millisecondsSinceEpoch - snapshot.data.documents[0].data["messagetimestamp"].millisecondsSinceEpoch).hour > 1
                                      ? DateTime.fromMillisecondsSinceEpoch(DateTime.now().millisecondsSinceEpoch -
                                                  snapshot
                                                      .data
                                                      .documents[0]
                                                      .data["messagetimestamp"]
                                                      .millisecondsSinceEpoch)
                                              .hour
                                              .toString() +
                                          " h ago"
                                      : (DateTime.fromMillisecondsSinceEpoch(DateTime.now().millisecondsSinceEpoch - snapshot.data.documents[0].data["messagetimestamp"].millisecondsSinceEpoch).minute > 1)
                                          ? DateTime.fromMillisecondsSinceEpoch(DateTime.now().millisecondsSinceEpoch - snapshot.data.documents[0].data["messagetimestamp"].millisecondsSinceEpoch).minute.toString() + " mins ago"
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
                .where('chatsender',
                    isEqualTo: Firebase.getUser().uid.toString())
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data.documents.length == 0) {
                return Container(
                  child: Center(child: Text('no chat')),
                );
              } else {
                return ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, position) {
                    return _buildChatLayout(
                        context,
                        snapshot.data.documents[position],
                        snapshot.data.documents[position]['chatimageurl']
                            .toString());
                  },
                );
              }
            }));
  }

  Future<Widget> confirmdeleteconv(DocumentSnapshot document) async {
    return showDialog(
        context: context,
        builder: (context) {
          return Theme(
            data: DynamicTheme.darkthemeEnabled
                ? DynamicTheme.darktheme
                : DynamicTheme.lightheme,
            child: AlertDialog(
              title: Text("Delete Conversation"),
              content: Text('do you really want to delete this conversation?'),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    "Delete",
                    style: TextStyle(color: Colors.redAccent),
                  ),
                  onPressed: () {
                    deleteconv(document);
                  },
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

  Future<void> deleteconv(DocumentSnapshot document) async {
    Firestore.instance.runTransaction((transaction) async {
      await transaction.delete(Firestore.instance
          .collection("chats")
          .document(document.documentID)
          .collection("message")
          .document());
      await transaction.delete(
          Firestore.instance.collection("chats").document(document.documentID));

      String s1 = document.documentID.substring(0, 28);
      String s2 = document.documentID.substring(28, 56);
      print(s1);
      String result = s2 + s1;

      await transaction.delete(Firestore.instance
          .collection("chats")
          .document(result)
          .collection("message")
          .document());

      await transaction
          .delete(Firestore.instance.collection("chats").document(result));
    });
    Navigator.of(context).pop();
  }

  @override
  bool get wantKeepAlive => false;
}
