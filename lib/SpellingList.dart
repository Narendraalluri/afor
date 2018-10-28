
import 'package:flutter/material.dart';
import 'dart:async';
import 'utils.dart';
import 'SpellingBuilder.dart';
import 'dart:math';

class SpellingList extends StatefulWidget {
  SpellingList({Key key, this.list, this.name}) : super(key: key);

  final List<String> list;
  final String name;
    StreamController<Event> eventStreamController = new StreamController.broadcast();


  @override
  _SpellingListState createState() => _SpellingListState();
}

class _SpellingListState extends State<SpellingList> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SpellingBuilder(
      eventStreamController: widget.eventStreamController,
        listName: widget.name,
        index: currentIndex,
        total: widget.list.length,
        word: widget.list[currentIndex],
        onComplete: nextPage,
        options: getOptions(widget.list[currentIndex]));
  }

  getOptions(String word) {
    String allAlphabets = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    for (int i = 0; i < word.length; i++) {
      allAlphabets.replaceAll(word[i], '');
    }
    final _random = new Random();
    String options = word.toUpperCase();
    for (int i = 0; i < word.length; i++) {
      var element = allAlphabets[_random.nextInt(allAlphabets.length)];
      options = options + element;
    }
    List<String> optionList = options.split('');
    optionList.shuffle();
    return optionList.join();
  }

  nextPage() {
    if (currentIndex + 1 < widget.list.length) {
      widget.eventStreamController.add(Event('RESET'));
        setState(() {
          currentIndex = currentIndex + 1;
        });
      
    } else {
      Navigator.of(context).pop();
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => SpellHelperHome()),
      // );
    }
  }
}
