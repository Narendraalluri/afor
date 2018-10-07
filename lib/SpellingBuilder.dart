import 'package:flutter/material.dart';
import 'speakword.dart';
import 'CheckButton.dart';
import 'utils.dart';
import 'dart:async';

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
        appBar: AppBar(
          title: Column(
            children: <Widget>[
              Text(widget.listName),
              Container(
                margin: EdgeInsets.only(top: 10.0),
                 child: Text((widget.index + 1).toString() + ' of ' + widget.total.toString(), style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 15.0
              ),
              )
              )
              
            ],
          ),
          ),
        body: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
            Row(children: <Widget>[
              Container(
                padding: const EdgeInsets.only(top: 30.0, left: 30.0),
                child: SpeakWord(word: widget.word),
              ),
            ]),
            Divider(),
            SpellingField(word: selectedWord, onClick: null),
            Divider()
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 100.0),
              child: SpellOptions(
                options: widget.options,
                selectedIndices: selectedIndices,
                onUnSelect: onUnSelect,
                onSelect: onSelect)
              ),
              CheckButton(enable: checkButtonEnable, onTap: onCheckButtonTap, checkSuccess: checkSuccess)
                   
                  ],
                ) 
            
        );
  }

  onCheckButtonTap() {
    setState(() {
              checkButtonEnable = false;
              checkSuccess = selectedWord == widget.word.toUpperCase() ? CHECK_STATUS.SUCCESS : CHECK_STATUS.FAIL;
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

  onUnSelect(String char) {
    int index = selectedWord.indexOf(char);
    String newWord = selectedWord.substring(0, index) + selectedWord.substring(index + 1);
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
    //if (widget.word.toUpperCase().startsWith(newWord)) {
      setState(() {
        selectedIndices.removeAt(index);
        selectedWord = newWord;
      }); 
  }

  onSelect(int index) {
    String newWord = selectedWord + widget.options[index];
    if (!checkButtonEnable) {
        setState(() {
          checkSuccess = CHECK_STATUS.INITIAL;
          checkButtonEnable = true;
        });
    }
    
    //if (widget.word.toUpperCase().startsWith(newWord)) {
      setState(() {
        selectedIndices.add(index);
        selectedWord = newWord;
      });
    //}
    // if (newWord == widget.word.toUpperCase()) {
    //   widget.onComplete();
    // }
  }
}

class SpellingField extends StatelessWidget {
  SpellingField({Key key, this.word, this.onClick}) : super(key: key);

  final String word;
  final Function onClick;

  @override
  Widget build(BuildContext context) {
    List<Widget> selectedChars = List.generate(word.length, (index) {
              return 
              GestureDetector(
                onTap: () {
                  onClick(index);
                },
                child: Container(
                height: 50.0,
                width: 50.0,
                margin: EdgeInsets.all(3.0),
                decoration: ShapeDecoration(
                  color: Colors.green,
                  shape: CircleBorder(side: BorderSide.none),
                ),
                child: Center(
                    child: Text(
                      word[index],
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30.0),
                    ))),
              );
            });
    return Container(
        padding: EdgeInsets.all(20.0),
        child: Row(
          children: selectedChars,
        )
    );
  }
}

class SpellOptions extends StatelessWidget {
  SpellOptions({Key key, this.options, this.selectedIndices, this.onSelect, this.onUnSelect})
      : super(key: key);

  final String options;
  final List<int> selectedIndices;
  final Function onSelect;
  final Function onUnSelect;

  @override
  Widget build(BuildContext context) {
    
    return Stack(
      children: List.generate(options.length, (index) {
        return Positioned(
            left: (index * 100.0) % 400,
            top: 150.0 + ((index / 4 ).floor() * 60.0),
            child: new Alphabet(
                index: index,
                char: options[index],
                isSelected: selectedIndices.contains(index),
                onUnSelect: onUnSelect,
                onSelect: onSelect));
      }),
    );
  }
}

class Alphabet extends StatefulWidget {
  Alphabet({Key key, this.index, this.char, this.isSelected, this.onSelect, this.onUnSelect})
      : super(key: key);

  final String char;
  final int index;
  final bool isSelected;
  final Function onSelect;
  final Function onUnSelect;

  @override
  _AlphabetState createState() => new _AlphabetState();
}

class _AlphabetState extends State<Alphabet> with TickerProviderStateMixin {
  AnimationController bounceAnimationController, moveAnimationController, moveDownAnimationController;
  Animation bounceAnimation, moveUpAnimation, opacityAnimation, moveDownAnimation;
  @override
  initState() {
    super.initState();
    bounceAnimationController = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 100));
    moveAnimationController = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 100));    
    moveDownAnimationController = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 100));    
    bounceAnimation = new Tween(begin: 0.0, end: 10.0).animate(
      new CurvedAnimation(parent: bounceAnimationController, curve: Curves.easeOut)
    );
    moveUpAnimation = new Tween(begin: 0.0, end: 100.0).animate(
      new CurvedAnimation(parent: moveAnimationController, curve: Curves.easeOut)
    );
    moveDownAnimation = new Tween(begin: 100.0, end: 10.0).animate(
      new CurvedAnimation(parent: moveAnimationController, curve: Curves.easeOut)
    );
    opacityAnimation = new Tween(begin: 0.0, end: 1.0).animate(
      new CurvedAnimation(parent: bounceAnimationController, curve: Curves.easeOut)
    );
    bounceAnimation.addListener((){
      setState(() {});
    });
    moveUpAnimation.addListener((){
      setState(() {});
    });
    moveDownAnimation.addListener((){
      setState(() {});
    });
    opacityAnimation.addListener((){
      setState(() {});
    });
    bounceAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        bounceAnimationController.reverse();
      }
    });
    
  }

  @override
  dispose() {
    super.dispose();
    bounceAnimationController.dispose();
    moveAnimationController.dispose();
    moveDownAnimationController.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
        padding: const EdgeInsets.all(10.0),
        child: GestureDetector(
          onTap: widget.isSelected ? () => unSelectChar(widget.index) : () => selectChar(widget.index),
          child: getStack()
        ));
  }

  Widget getStack() {
    return Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              Container(
                height: 50.0 + bounceAnimation.value,
                width: 50.0 + bounceAnimation.value,
                decoration: ShapeDecoration(
                  shape: CircleBorder(side: BorderSide.none),
                  color: widget.isSelected ? Colors.grey : Colors.pink,
                ),
                child: Center(
                    child: Text(
                      widget.char,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0),
                    ))),
                Positioned(
                  bottom: moveUpAnimation.value,
                  child: Opacity(
                    opacity: opacityAnimation.value,
                    child: Container(
                      height: 50.0,
                      width: 50.0,
                      decoration: ShapeDecoration(
                        shape: CircleBorder(side: BorderSide.none),
                        color: Colors.pink,
                      ),
                      ),
                  ) 
                )
            ],
          );
  }

  unSelectChar(index) {
    moveUpAnimation = new Tween(begin: 100.0  + ((index / 4).floor() * 60.0), end: 0.0).animate(
      new CurvedAnimation(parent: moveAnimationController, curve: Curves.easeOut)
    );
    moveAnimationController.reverse(from: 100.0  + ((index / 4).floor() * 60.0));
    bounceAnimationController.reverse(from: 1.0);
    widget.onUnSelect(widget.char);
  }

  void selectChar(index) {
    moveUpAnimation = new Tween(begin: 0.0, end: 100.0 + ((index / 4).floor() * 60.0)).animate(
      new CurvedAnimation(parent: moveAnimationController, curve: Curves.easeOut)
    );
    bounceAnimationController.forward(from: 0.0);
    moveAnimationController.forward(from: 0.0);
    widget.onSelect(widget.index);
  }
}
