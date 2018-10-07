import 'package:flutter/material.dart';
import 'package:tts/tts.dart';
import 'dart:async';

class SpeakWord extends StatefulWidget {
  SpeakWord({Key key, this.word}) : super(key: key);

  final String word;

  @override
  _SpeakWordState createState() => _SpeakWordState();
}

class _SpeakWordState extends State<SpeakWord> with RouteAware {
  Timer _timer;
  bool _isSpeaking = false;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: speak,
      child: Icon(Icons.volume_up, color: _isSpeaking ? Colors.yellow : Colors.red),
      shape: new CircleBorder(),
      elevation: 2.0,
      fillColor: _isSpeaking ? Colors.red : Colors.yellow,
      padding: const EdgeInsets.all(15.0),
    );
  }

  @mustCallSuper
  @protected
  void didUpdateWidget(SpeakWord oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.word.toUpperCase() != widget.word.toUpperCase()) {
      speak();
    }
  }

  @override
  void initState() {
    super.initState();
    speak();
  }

  @override
  void dispose() {
    //  routeObserver.unsubscribe(this);
    super.dispose();
    _timer.cancel();
  }

  speak() {
    setState(() {
      _isSpeaking = true;
    });
    Tts.speak(widget.word);
    _timer = new Timer(const Duration(milliseconds: 1000), () {
      setState(() {
        _isSpeaking = false;
      });
    });
  }
}
