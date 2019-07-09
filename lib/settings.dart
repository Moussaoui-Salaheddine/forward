import 'package:flutter/material.dart';
import 'package:forward/dynamictheme.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('enable dark theme: '),
                    Switch(
                      activeColor: DynamicTheme.darkthemeAccent,
                      value: DynamicTheme.darkthemeEnabled,
                      onChanged: (value) {
                        setState(() {
                          DynamicTheme.darkthemeEnabled = value;
                          _save(value);
                        });
                      },
                    ),
                  ],
                ),
              )
            ]))),
      ),
    );
  }

  _save(value) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'darktheme';
    prefs.setBool(key, value);
  }
}
