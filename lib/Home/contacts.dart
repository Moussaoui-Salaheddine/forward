import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:forward/Home/cantactprofile.dart';
import 'package:forward/dynamictheme.dart';
import 'package:forward/firehelp.dart';
import 'package:scoped_model/scoped_model.dart';

class Contacts extends StatefulWidget {
  @override
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<Contacts>
    with AutomaticKeepAliveClientMixin {
  Widget _buildContactlist(BuildContext context, DocumentSnapshot document) {
<<<<<<< HEAD
    return ScopedModelDescendant(
      builder: (context, child, Firebase model) => Card(
            shape: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(
                    width: MediaQuery.of(context).size.height / 70,
                    color: document['userisactive']
                        ? Colors.greenAccent
                        : Colors.redAccent)),
            child: InkWell(
              splashColor: DynamicTheme.darkthemeBreak,
              onTap: () {
                if (document['useruid'].toString() ==
                    model.user.uid.toString()) {
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ContactProfile(document)));
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
=======
    return Card(
      shape: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(
              width: MediaQuery.of(context).size.height / 70,
              color: document['userisactive']
                  ? Colors.greenAccent
                  : Colors.redAccent)),
      child: InkWell(
        splashColor: DynamicTheme.darkthemeBreak,
        onTap: () {
          if (document['useruid'].toString() ==
              Firebase.getUser().uid.toString()) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Theme(
                          data: DynamicTheme.darkthemeEnabled
                              ? DynamicTheme.darktheme
                              : DynamicTheme.lightheme,
                          child: Scaffold(
                            appBar: AppBar(
                              title: Text(document['username']),
                              centerTitle: true,
                            ),
                            body: Profile(),
                          ),
                        )));
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ContactProfile(document)));
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
>>>>>>> parent of 0de1103... 0.0.3 beta
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
              addAutomaticKeepAlives: true,
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
              itemBuilder: (context, index) {
                return _buildContactlist(
                    context, snapshot.data.documents[index]);
              },
            ),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
