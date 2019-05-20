import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Contacts extends StatefulWidget {
  @override
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  Widget _buildContactlist(BuildContext context, DocumentSnapshot document) {
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width / 10,
            height: MediaQuery.of(context).size.width / 10,
            child: CachedNetworkImage(
              imageUrl: document['userimageurl'].toString(),
            ),
          ),
          Text(document['usermail'].toString()),
          document['userisactive']
              ? Text('active', style: TextStyle(color: Colors.greenAccent))
              : Text(
                  'not active',
                  style: TextStyle(color: Colors.redAccent),
                ),
          Padding(
            padding:
                EdgeInsets.only(bottom: MediaQuery.of(context).size.height / 12),
          )
        ],
      ),
      trailing: Text(document['userpassword'].toString()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
        stream: Firestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Text('Loading...');
          return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) =>
                _buildContactlist(context, snapshot.data.documents[index]),
          );
        },
      ),
    );
  }
}
