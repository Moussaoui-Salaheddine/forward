import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:forward/dynamictheme.dart';
import 'package:forward/firehelp.dart';

class Defuse extends StatefulWidget {
  String _messagedefuse;
  Defuse(this._messagedefuse);
  @override
  _DefuseState createState() => _DefuseState(_messagedefuse);
}

class _DefuseState extends State<Defuse> {
  String _messagedefuse;
  List<bool> _selected = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];
  _DefuseState(this._messagedefuse);
  Widget _buildDefuselist(
      BuildContext context, DocumentSnapshot document, int index) {
    return Card(
      shape: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(
              width: MediaQuery.of(context).size.height / 70,
              color: _selected[index]
                  ? DynamicTheme.darkthemeBreak
                  : Colors.transparent)),
      child: InkWell(
        splashColor: DynamicTheme.darkthemeBreak,
        onTap: () {
          if (document['useruid'] != Firebase.getUser().uid.toString()) {
            if (_selected[index] == false) {
              setState(() {
                _selected[index] = true;
              });
              createChat(document);
            }
          }
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              CircleAvatar(
                radius: MediaQuery.of(context).size.width / 14,
                backgroundImage: CachedNetworkImageProvider(
                    document['userimageurl'].toString()),
              ),
              Text(document['username'].toString(),
                  style: TextStyle(fontFamily: 'Montserrat Regular')),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: DynamicTheme.darkthemeEnabled
            ? DynamicTheme.darktheme
            : DynamicTheme.lightheme,
        child: Scaffold(
          resizeToAvoidBottomPadding: false,
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text('choose user'),
            centerTitle: true,
            automaticallyImplyLeading: false,
          ),
          body: Container(
            child: StreamBuilder(
              stream: Firestore.instance.collection('users').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(child: Text('Loading...'));
                else {
                  return Container(
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 20),
                    child: GridView.builder(
                      itemCount: snapshot.data.documents.length,
                      addAutomaticKeepAlives: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3),
                      itemBuilder: (context, index) {
                        if (snapshot.data.documents[index]['useruid'] !=
                            Firebase.getUser().uid.toString()) {
                          return _buildDefuselist(
                              context, snapshot.data.documents[index], index);
                        }
                      },
                    ),
                  );
                }
              },
            ),
          ),
        ));
  }

  Future<void> createChat(DocumentSnapshot document) async {
    Firestore.instance.runTransaction((transaction) async {
      await transaction.set(
          Firestore.instance.collection("chats").document(
              Firebase.getUser().uid.toString() +
                  document['useruid'].toString()),
          {
            "chattitle": document['username'].toString(),
            "chatsender": Firebase.getUser().uid.toString(),
            "chatimageurl": document['userimageurl'].toString(),
          });
      await transaction.set(
          Firestore.instance
              .collection("chats")
              .document(Firebase.getUser().uid.toString() +
                  document['useruid'].toString())
              .collection("message")
              .document(),
          {
            "messagetext": _messagedefuse,
            "messagetimestamp": DateTime.now(),
            "messagesender": Firebase.getUser().uid.toString()
          });
    });

    Firestore.instance.runTransaction((transaction) async {
      await transaction.set(
          Firestore.instance.collection("chats").document(
              document['useruid'].toString() +
                  Firebase.getUser().uid.toString()),
          {
            "chattitle": Firebase.getUsername().toString(),
            "chatsender": document['useruid'].toString(),
            "chatimageurl": Firebase.getUserimageurl().toString(),
          });
      await transaction.set(
          Firestore.instance
              .collection("chats")
              .document(document['useruid'].toString() +
                  Firebase.getUser().uid.toString())
              .collection("message")
              .document(),
          {
            "messagetext": _messagedefuse,
            "messagetimestamp": DateTime.now(),
            "messagesender": Firebase.getUser().uid.toString()
          });
    });
  }
}
