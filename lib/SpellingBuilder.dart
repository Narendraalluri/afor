import 'package:flutter/material.dart';import 'SpeakWord.dart';
import 'SpeakWord.dart';
import 'CheckButton.dart';
import 'utils.dart';
import 'dart:async';
import 'SpellOptions.dart';
import 'SpellingField.dart';

class SpellingBuilder extends StatefulWidget {
  SpellingBuilder(
      {Key key,
      this.listName,
      this.word,
      this.onComplete,
      this.index,
      this.total,
      this.options})
      : super(key: key);

  final String listName;
  final Function onComplete;
  final String word;
  final int index;
  final int total;
  final String options;

  @override
  _SpellingBuilderState createState() => _SpellingBuilderState();
}

class _SpellingBuilderState extends State<SpellingBuilder> {
  String selectedWord = '';
  List<int> selectedIndices = [];
  CHECK_STATUS checkSuccess = CHECK_STATUS.INITIAL;
  bool checkButtonEnable = false;
  var positions = Map();
GlobalKey nextPositionKey = GlobalKey();

  @mustCallSuper
  @protected
  void didUpdateWidget(SpellingBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    selectedIndices = [];
    selectedWord = '';
  }

  @mustCallSuper
  @protected
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
        floatingActionButton: Stack(
          children: <Widget>[
            Positioned(
              top: 90.0,
              right: 8.0,
              child: SpeakWord(word: widget.word),
            ),
            Positioned(
              bottom: - 40.0,
              right: 10.0,
              child: CheckButton(
                      enable: checkButtonEnable,
                      onTap: onCheckButtonTap,
                      checkSuccess: checkSuccess),
            )
          ],
        ),
        appBar: AppBar(
          title: Column(
            children: <Widget>[
              Text(widget.listName),
              Container(
                  margin: EdgeInsets.only(top: 10.0),
                  child: Text(
                    (widget.index + 1).toString() +
                        ' of ' +
                        widget.total.toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.normal, fontSize: 15.0),
                  ))
            ],
          ),
        ),
        body: SingleChildScrollView(
          
            child: ConstrainedBox(
                constraints: BoxConstraints(),
                child: Column(
                  children: <Widget>[
                    SpellingField(word: selectedWord, onClick: onUnSelect, nextPositionKey: nextPositionKey),
                    Divider(
                      height: 100.0,
                      color: Colors.blue,
                    ),
                    SpellOptions(
                        options: widget.options,
                        selectedIndices: selectedIndices,
                        positions: positions,
                        onUnSelect: onUnSelect,
                        onUnSelectChar: onUnSelectChar,
                        nextPositionKey: nextPositionKey,
                        onSelect: onSelect),
                     
                  ],
                ))
                ));
  }

  onCheckButtonTap() {
    setState(() {
      checkButtonEnable = false;
      checkSuccess = selectedWord == widget.word.toUpperCase()
          ? CHECK_STATUS.SUCCESS
          : CHECK_STATUS.FAIL;
    });
    if (selectedWord == widget.word.toUpperCase()) {
      Timer(Duration(milliseconds: 1000), () {
        widget.onComplete();
        setState(() {
          checkButtonEnable = true;
          checkSuccess = CHECK_STATUS.INITIAL;
        });
      });
    }
  }

  onUnSelectChar(String char) {
    onUnSelect(selectedWord.indexOf(char));
  }

  onUnSelect(int index) {
    String newWord =
        selectedWord.substring(0, index) + selectedWord.substring(index + 1);
    if (checkButtonEnable && newWord.length == 0) {
      setState(() {
        checkSuccess = CHECK_STATUS.INITIAL;
        checkButtonEnable = false;
      });
    } else {
      setState(() {
        checkSuccess = CHECK_STATUS.INITIAL;
        checkButtonEnable = true;
      });
    }
    setState(() {
      selectedIndices.removeAt(index);
      selectedWord = newWord;
    });
  }

  onSelect(int index, double left, double bottom) {
    String newWord = selectedWord + widget.options[index];
    if (!checkButtonEnable) {
      setState(() {
        checkSuccess = CHECK_STATUS.INITIAL;
        checkButtonEnable = true;
      });
    }
    print(left);
    setState(() {
      selectedIndices.add(index);
      selectedWord = newWord;
      positions[index] = {
        'left': left,
        'bottom': bottom
      };
    });
  }
}
