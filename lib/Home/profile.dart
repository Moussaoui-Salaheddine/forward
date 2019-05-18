import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:forward/firehelp.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:forward/login.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  DocumentSnapshot firestoreUser;
  Widget _buildProfile(BuildContext context, DocumentSnapshot document) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              width: 300,
              height: 300,
              child: CachedNetworkImage(
                imageUrl: document['userimageurl'],
              ),
            ),
            Container(
              child: Text(document['usermail']),
            ),
            Container(
              child: Text(document['username']),
            ),
            Container(
              child: Text(document['userbio']),
            ),
            Container(
              child: RaisedButton(
                child: Text('logout'),
                onPressed: logout,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance
            .collection('users')
            .document(Firebase.getUser().uid.toString())
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Text('Loading..');
          else
            return _buildProfile(context, snapshot.data);
        },
      ),
    );
  }

  Future<void> logout() async {
    FirebaseAuth.instance.signOut();
    Firebase.setUser(null);
    Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
  }
}