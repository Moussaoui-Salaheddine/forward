import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:forward/Home/cantactprofile.dart';

class Contacts extends StatefulWidget {
  @override
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  Widget _buildContactlist(BuildContext context, DocumentSnapshot document) {
    return Card(
      shape: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(
              width: 5,
              color: document['userisactive']
                  ? Colors.greenAccent
                  : Colors.redAccent)),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ContactProfile(document)));
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
    return Container(
      child: StreamBuilder(
        stream: Firestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: Text('Loading...'));
          return Container(
            margin:
                EdgeInsets.only(top: MediaQuery.of(context).size.height / 20),
            child: GridView.builder(
              itemCount: snapshot.data.documents.length,
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
              itemBuilder: (context, index) =>
                  _buildContactlist(context, snapshot.data.documents[index]),
            ),
          );
        },
      ),
    );
  }
}
