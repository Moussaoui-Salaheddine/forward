import 'package:flutter/material.dart';

class ColoredActiveIndicator extends StatefulWidget {
  final bool _active;
  ColoredActiveIndicator(this._active);
  @override
  _ColoredActiveIndicatorState createState() =>
      _ColoredActiveIndicatorState(_active);
}

class _ColoredActiveIndicatorState extends State<ColoredActiveIndicator> {
  bool _active;
  _ColoredActiveIndicatorState(this._active);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 150,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
        _active ? Colors.green : Colors.red,
        _active ? Colors.greenAccent : Colors.redAccent,
      ])),
    );
  }
}
