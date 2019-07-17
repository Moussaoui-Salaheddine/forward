import 'package:flutter/material.dart';
import 'package:forward/Home/users.dart';
import 'package:forward/Home/messages.dart';
import 'package:forward/Home/profile.dart';
import 'package:forward/defusemassage.dart';
import 'package:forward/dynamictheme.dart';
import 'package:forward/settings.dart';
import 'package:forward/tabbar/tabbar.dart';

class Home extends StatefulWidget {
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

  String _newMessage;
  GlobalKey<FormState> _sendMessagekey = GlobalKey<FormState>();

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
                icon: Icon(Icons.reply_all),
                onPressed: defuse,
              ),
              IconButton(
                icon: Icon(Icons.more_horiz),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Settings()));
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
          body: Container(child: _handlePage())),
    );
  }

  _handlePage() {
    if (_currenttabindex == 0) {
      return Messages();
    } else if (_currenttabindex == 1) {
      return Contacts();
    } else {
      return Profile();
    }
  }

  Future<Widget> defuse() async {
    return showDialog(
        context: context,
        builder: (context) {
          return Theme(
            data: DynamicTheme.darkthemeEnabled
                ? DynamicTheme.darktheme
                : DynamicTheme.lightheme,
            child: AlertDialog(
              title: Text("defuse a message"),
              content: Form(
                key: _sendMessagekey,
                child: TextFormField(
                  validator: (input) {
                    if (input.length == 0) {
                      return 'message is empty';
                    }
                  },
                  onSaved: (input) {
                    setState(() {
                      _newMessage = input;
                    });
                  },
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text("Send",
                      style: TextStyle(color: DynamicTheme.darkthemeBreak)),
                  onPressed: createChat,
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

  Future<void> createChat() async {
    if (_sendMessagekey.currentState.validate()) {
      _sendMessagekey.currentState.save();
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => Defuse(_newMessage)));
    }
  }

  @override
  bool get wantKeepAlive => false;
}
