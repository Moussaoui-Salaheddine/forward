import 'package:flutter/material.dart';
import 'package:forward/dynamictheme.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: DynamicTheme.darkthemeEnabled
          ? DynamicTheme.darktheme
          : DynamicTheme.lightheme,
      child: Scaffold(
        appBar: AppBar(
          title: Text('About us'),
          centerTitle: true,
        ),
        body: Center(
          child: Text('about us'),
        ),
      ),
    );
  }
}
