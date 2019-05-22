import 'package:flutter/material.dart';
import 'package:forward/Home/contacts.dart';
import 'package:forward/Home/messages.dart';
import 'package:forward/Home/profile.dart';
import 'package:forward/about.dart';
import 'package:forward/dynamictheme.dart';
import 'package:forward/settings.dart';
import 'package:forward/tabbar/tabbar.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _index = 1;
  _handleTap(int newIndex) {
    setState(() {
      _index = newIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: DynamicTheme.darkthemeEnabled
          ? DynamicTheme.darktheme
          : DynamicTheme.lightheme,
      child: Scaffold(
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
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => About()));
              },
            )
          ],
        ),
        bottomNavigationBar: FancyTabBar((int nb) {
          if (nb == 0) {
            _handleTap(0);
          } else if (nb == 1) {
            _handleTap(1);
          } else {
            _handleTap(2);
          }
        }),
        body: Container(
          child: _handlePage(),
        ),
      ),
    );
  }

  _handlePage() {
    if (_index == 0) {
      return Messages();
    } else if (_index == 1) {
      return Contacts();
    } else {
      return Profile();
    }
  }
}
