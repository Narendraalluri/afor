import 'package:flutter/material.dart';
import 'SpellHelperHome.dart';

void main() => runApp(new SpellHelperApp());

class SpellHelperApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: SpellHelperHome(),
    );
  }
}
