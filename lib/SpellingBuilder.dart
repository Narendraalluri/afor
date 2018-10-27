import 'package:flutter/material.dart';
import 'SpeakWord.dart';
import 'SpellHelperHome.dart';
import 'utils.dart';
import 'dart:async';
import 'SpellOptions.dart';
import 'SpellingField.dart';

class SpellingBuilder extends StatefulWidget {
  SpellingBuilder(
      {Key key,
      this.eventStreamController,
      this.listName,
      this.word,
      this.onComplete,
      this.index,
      this.total,
      this.options})
      : super(key: key);

final StreamController<Event> eventStreamController;
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
  int unSelectIndex = -1;
  StreamController<String> streamController = new StreamController.broadcast();
  StreamController<String> selectStreamController = new StreamController.broadcast();


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
      setState(() {
        scrollOffset = controller.position.pixels;
      });
    });
    super.initState();
  }

  checkWord() {

    print(widget.word);
    
    if (widget.word == selectedWord) {
      setState(() {
          checkSuccess = CHECK_STATUS.SUCCESS;   
      });
      new Future.delayed(const Duration(seconds: 1), () {
        widget.onComplete();
        setState(() {
          checkSuccess = CHECK_STATUS.INITIAL;   
        });
      });
      
      
    } else {
      setState(() {
          checkSuccess = CHECK_STATUS.FAIL;
      });
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(
            Icons.list,
            color: Colors.black,
          ),
          ) ,
          backgroundColor: Colors.greenAccent,
          elevation: 0.0,
          actions: <Widget>[
            Container(
                padding: EdgeInsets.only(right: 5.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      widget.listName,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      widget.index.toString() + ' of 10',
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.black54,
                      ),
                    )
                  ],
                )),
            Container(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SpeakWord(word: widget.word),
                  ]),
            ),
          ],
        ),
        backgroundColor: Colors.grey[200],
        bottomNavigationBar: Theme(
            data: Theme.of(context).copyWith(
                // sets the background color of the `BottomNavigationBar`
                canvasColor: Colors.greenAccent,
                // sets the active color of the `BottomNavigationBar` if `Brightness` is light
                primaryColor: Colors.black,
                textTheme: Theme.of(context).textTheme.copyWith(
                    caption: new TextStyle(
                        color: Colors
                            .black))), // sets the inactive color of the `BottomNavigationBar`
            child: BottomNavigationBar(
              items: [
                new BottomNavigationBarItem(
                  icon: GestureDetector(
                    onTap: () {
                      var selected = "";
                      for(int i=0; i < widget.word.length; i++) {
                        for(int j=0; j < widget.options.length; j++) {
                            if (widget.word[i] == widget.options[j] && !selected.contains(j.toString() + ",")) {
                              selected += j.toString() + ",";
                              new Future.delayed(Duration(milliseconds: i * 100), () {
                               selectStreamController.add(j.toString());
                              });
                              break;  
                            }
                        }
                      }
                    },
                    child:  Icon(Icons.visibility),
                  ),
                  title: new Text("Reveal"),
                ),
                new BottomNavigationBarItem(
                  icon: GestureDetector(
                    onTap: () {
                      widget.onComplete();
                      setState(() {
                        checkButtonEnable = true;
                        checkSuccess = CHECK_STATUS.INITIAL;
                      });
                    },
                    child: Icon(Icons.skip_next)
                  ) ,
                  title: new Text("Skip"),
                ),
              ],
            )),
        floatingActionButton: FloatingActionButton.extended(
          elevation: 4.0,
          backgroundColor: checkSuccess == CHECK_STATUS.INITIAL ? selectedWord.length > 0 ? Colors.orange : Colors.grey : checkSuccess == CHECK_STATUS.SUCCESS ? Colors.green : Colors.red ,
          icon: checkSuccess == CHECK_STATUS.INITIAL ? Icon(Icons.help) : checkSuccess == CHECK_STATUS.SUCCESS ? Icon(Icons.check) : Icon(Icons.cancel),
          label: const Text('CHECK'),
          onPressed: checkWord,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: new CustomScrollView(
          controller: controller,
          slivers: <Widget>[
            new SliverPadding(
              padding: new EdgeInsets.all(16.0),
              sliver: new SliverList(
                delegate: new SliverChildListDelegate([
                  SpellingField(
                      word: selectedWord,
                      onClick: onUnSelect,
                      nextPositionKey: nextPositionKey),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        child: Container(
                            child: GestureDetector(
                          onTap: () {
                            onUnSelectLast(selectedWord.length - 1);
                          },
                          child: Container(
                            child: Icon(Icons.backspace),
                          ),
                        )),
                      )
                    ],
                  ),
                  SpellOptions(
                    eventStreamController: widget.eventStreamController,
                    streamController: streamController,
                    selectStreamController: selectStreamController,
                      scrollOffset: scrollOffset,
                      options: widget.options,
                      selectedIndices: selectedIndices,
                      positions: positions,
                      unSelectIndex: unSelectIndex,
                      onUnSelect: onUnSelect,
                      onUnSelectChar: onUnSelectChar,
                      nextPositionKey: nextPositionKey,
                      onSelect: onSelect),
                ]),
              ),
            ),
          ],
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

  onUnSelectLast(int index) {
    streamController.add(index.toString());
  }

  onUnSelect(int index) {
    print(index);
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
        for (var i = selectedIndices.length - 1; i > index; i--) {
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
        print(positions);
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
      positions[index] = {'left': left, 'bottom': bottom};
    });
  }
}
