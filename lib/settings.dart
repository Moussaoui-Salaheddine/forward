import 'package:flutter/material.dart';
import 'package:forward/dynamictheme.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: DynamicTheme.darkthemeEnabled
          ? DynamicTheme.darktheme
          : DynamicTheme.lightheme,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Settings'),
          centerTitle: true,
        ),
        body: Center(
            child: Container(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
              Container(
                child: Switch(
                  value: DynamicTheme.darkthemeEnabled,
                  onChanged: (value) {
                    setState(() {
                      DynamicTheme.darkthemeEnabled = value;
                    });
                  },
                ),
              )
            ]))),
      ),
    );
  }
}
