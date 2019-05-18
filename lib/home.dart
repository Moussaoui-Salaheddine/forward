import 'package:flutter/material.dart';
import 'package:forward/Home/contacts.dart';
import 'package:forward/Home/messages.dart';
import 'package:forward/Home/profile.dart';
import 'package:forward/about.dart';
import 'package:forward/settings.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<BottomNavigationBarItem> _bottomNavigationBarItems = [
    BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('home')),
    BottomNavigationBarItem(icon: Icon(Icons.people), title: Text('contacts')),
    BottomNavigationBarItem(icon: Icon(Icons.person), title: Text('profile')),
  ];
  int _index = 0;
  _handleTap(int newIndex) {
    setState(() {
      _index = newIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forward'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Settings()));
            },
          ),
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => About()));
            },
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: _bottomNavigationBarItems,
        currentIndex: _index,
        onTap: (index) {
          _handleTap(index);
        },
      ),
      body: Container(
        child: _handlePage(),
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
