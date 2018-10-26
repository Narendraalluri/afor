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
final ScrollController controller = ScrollController();
double scrollOffset = 0.0;

  @mustCallSuper
  @protected
  void didUpdateWidget(SpellingBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    selectedIndices = [];
    selectedWord = '';
  }

 @override
  void initState() {
    controller.addListener(() {
      // always prints "scrolling = true"
      setState(() {
              scrollOffset = controller.position.pixels;
            });
    });
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
            controller: controller,
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
                      scrollOffset: scrollOffset,
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
    print('onUnSelect ' + index.toString());
    if (index != -1) {
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
      for (var i = selectedIndices.length - 1; i > index ;i--){
        positions[selectedIndices[i]] = {
          'left': positions[selectedIndices[i]]['left'] + 40.0,
          'bottom': positions[selectedIndices[i]]['bottom']
        };
        if (i % 8 == 0) {
          positions[selectedIndices[i]] = {
            'left': positions[selectedIndices[i]]['left'] - 320,
            'bottom': positions[selectedIndices[i]]['bottom'] + 50
          };
        }
      }
      positions.remove(selectedIndices[index]);
      selectedIndices.removeAt(index);
      selectedWord = newWord;
    });
    }
    
  }

  onSelect(int index, double left, double bottom) {
    String newWord = selectedWord + widget.options[index];
    if (!checkButtonEnable) {
      setState(() {
        checkSuccess = CHECK_STATUS.INITIAL;
        checkButtonEnable = true;
      });
    }
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
