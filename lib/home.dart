import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:forward/Home/contacts.dart';
import 'package:forward/Home/messages.dart';
import 'package:forward/Home/profile.dart';
import 'package:forward/about.dart';
import 'package:forward/dynamictheme.dart';
import 'package:forward/firehelp.dart';
import 'package:forward/settings.dart';
import 'package:forward/tabbar/tabbar.dart';

class Home extends StatefulWidget {
  static int _currenttabindex = 1;
  static int getCurrentTabIndex() {
    return _currenttabindex;
  }

  static void setCurrentTabIndex(int newvalue) {
     _currenttabindex = newvalue;
  }

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin {
  static int _currenttabindex = 1;
  _handleTap(int newIndex) {
    setState(() {
      _currenttabindex = newIndex;
    });
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
            title: Text('Forward'),
            centerTitle: true,
            automaticallyImplyLeading: false,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.more_horiz),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Settings()));
                },
              ),
              IconButton(
                icon: Icon(Icons.live_help),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => About()));
                },
              )
            ],
          ),
          bottomNavigationBar: FancyTabBar((nb) {
            if (nb == 0) {
              _handleTap(0);
            } else if (nb == 1) {
              _handleTap(1);
            } else {
              _handleTap(2);
            }
          }),
          body: Container(
            child: StreamBuilder<DocumentSnapshot>(
              stream: Firestore.instance
                  .collection('users')
                  .document(Firebase.getUser().uid.toString())
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(child: Text('Loading...'));
                else {
                  return _handlePage(snapshot.data);
                }
              },
            ),
          )),
    );
  }

  _handlePage(DocumentSnapshot document) {
    if (_currenttabindex == 0) {
      return Messages();
    } else if (_currenttabindex == 1) {
      return Contacts(document);
    } else {
      return Profile();
    }
  }

  @override
  bool get wantKeepAlive => true;
}
