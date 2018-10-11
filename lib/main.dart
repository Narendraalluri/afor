import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';

import 'LoginScreen.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Auth Demo',
      home: SpellHelperApp(title: 'Firebase Auth Demo'),
    );
  }
}

class SpellHelperApp extends StatefulWidget {
   SpellHelperApp({Key key, this.title}) : super(key: key);

  final String title;
  @override
    SpellHelperAppState createState() => SpellHelperAppState();
}

class SpellHelperAppState extends State<SpellHelperApp> {

    Future<String> _message = Future<String>.value('');
  TextEditingController _smsCodeController = TextEditingController();
  String verificationId;
  final String testSmsCode = '888888';
  final String testPhoneNumber = '+1 408-555-6969';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoginScreen3(),
    );
  }
}
