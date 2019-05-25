import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forward/dynamictheme.dart';

class Chat extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _StateChat();
  }
}

class _StateChat extends State<Chat> {
  List<String> _messages;

  TextEditingController _textFieldController = new TextEditingController();

  ScrollController scrollController;

  @override
  void initState() {
    _messages = List<String>();
    _messages.add("Hey what's up");
    _messages.add("hey");
    _messages.add("how are you");
    _messages.add("fine thx how ab u");

    scrollController = ScrollController();

    super.initState();
  }

  void handleSendingMessage() {
    setState(() {
      var text = _textFieldController.value.text.toString();
      if (text.isNotEmpty) {
        _textFieldController.clear();
        _messages.add(text);
      }
    });
    Future.delayed(Duration(milliseconds: 50), () {
      scrollController.animateTo(scrollController.position.maxScrollExtent,
          curve: Curves.easeOut, duration: Duration(milliseconds: 400));
    });
  }

  Widget build(BuildContext context) {
    var textinput = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Expanded(
          child: TextField(
            controller: _textFieldController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[500], width: 0.5),
                  borderRadius: BorderRadius.circular(30.0)),
              disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[500], width: 0.5),
                  borderRadius: BorderRadius.circular(30.0)),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[500], width: 0.5),
                  borderRadius: BorderRadius.circular(30.0)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[500], width: 0.5),
                  borderRadius: BorderRadius.circular(30.0)),
              hintText: 'Aa',
              hintStyle: TextStyle(color: Colors.grey[500]),
              prefixIcon: IconButton(
                icon: Icon(
                  Icons.camera_alt,
                ),
                onPressed: () {},
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  Icons.send,
                ),
                onPressed: handleSendingMessage,
              ),
            ),
            onSubmitted: (text) {
              handleSendingMessage();
            },
          ),
        ),
      ],
    );
    return Theme(
        data: DynamicTheme.darkthemeEnabled
            ? DynamicTheme.darktheme
            : DynamicTheme.lightheme,
        child: Scaffold(
          resizeToAvoidBottomPadding: true,
          appBar: AppBar(title: Text('chat name'), centerTitle: true),
          body: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: _messages.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (index % 2 == 0) {
                        return getSentMessageLayout(index);
                      } else {
                        return getReceivedMessageLayout(index);
                      }
                    },
                  ),
                ),
                Divider(
                  height: 2.0,
                ),
                Container(
                  child: textinput,
                )
              ],
            ),
          ),
        ));
  }

  Widget getSentMessageLayout(int index) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40.0),
                    bottomRight: Radius.circular(0),
                    topRight: Radius.circular(40.0),
                    topLeft: Radius.circular(40.0))),
            margin: EdgeInsets.only(right: 10),
            child: Container(
              margin: EdgeInsets.all(10),
              constraints: BoxConstraints(
                maxWidth: 200.0,
              ),
              child: Text(
                _messages[index],
                style: TextStyle(color: Colors.grey[200]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getReceivedMessageLayout(int index) {
    return Container(
      margin: EdgeInsets.only(top: 10, left: 10),
      child: Row(
        children: <Widget>[
          Container(
            width: 35,
            height: 35,
            child: CircleAvatar(),
          ),
          Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(0),
                    bottomRight: Radius.circular(40.0),
                    topRight: Radius.circular(40.0),
                    topLeft: Radius.circular(40.0))),
            margin: EdgeInsets.only(left: 10),
            child: Container(
              constraints: BoxConstraints(
                maxWidth: 200.0,
              ),
              margin: EdgeInsets.all(10),
              child: Text(_messages[index]),
            ),
          ),
        ],
      ),
    );
  }
}
