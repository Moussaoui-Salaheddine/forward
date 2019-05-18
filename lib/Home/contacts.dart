import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Contacts extends StatefulWidget {
  @override
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  Widget _buildContactlist(BuildContext context, DocumentSnapshot document){
    return ListTile(
      title: Text(document['usermail']),
      trailing: Text(document['userpassword']),
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
            itemBuilder: (context, index) => _buildContactlist(context, snapshot.data.documents[index]),
          );
        },
      ),
    );
  }
}
