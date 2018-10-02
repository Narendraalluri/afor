import 'package:flutter/material.dart';
import 'speakword.dart';
import 'dart:math';

class SpellingBuilder extends StatefulWidget {

  SpellingBuilder({Key key, this.word, this.onComplete, this.index, this.total}) {
    this.options = getOptions(this.word);
  }

  final Function onComplete;
  final String word;
  final int index;
  final int total;
  String options;

  getOptions(String word) {
    String allAlphabets = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    for(int i=0; i<word.length; i++) {
      allAlphabets.replaceAll(word[i], '');
    }
    final _random = new Random();
    String options = word.toUpperCase();
    for(int i=0; i<word.length; i++) {
      var element = allAlphabets[_random.nextInt(allAlphabets.length)];
      options = options + element;
    }
    List<String> optionList = options.split('');
    optionList.shuffle();
    return optionList.join();
  }

  @override
  _SpellingBuilderState createState() => _SpellingBuilderState();


}
        
class _SpellingBuilderState extends State<SpellingBuilder>{

  String selectedWord = '';
  List<int> selectedIndices = [];

@mustCallSuper
@protected
void didUpdateWidget (SpellingBuilder oldWidget) {
  super.didUpdateWidget(oldWidget);
  selectedIndices = [];
  selectedWord = '';
  print('didUpdateWidget');
}

@mustCallSuper
@protected
void initState () {
  super.initState();
  print('initState');
}

  @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Spell Helper')
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListIndex(index: widget.index, total: widget.total),
            Row(children: <Widget>[
              Container(
                padding: const EdgeInsets.only(top: 30.0, left: 30.0),
                child: SpeakWord(word: widget.word),
              ),
            ]),
            Divider(),
            SpellingField(word: selectedWord),
            Divider(),
            SpellOptions(options: widget.options, selectedIndices: selectedIndices, onSelect: onSelect)
          ],
        )
        
      );
    }

  onSelect(int index) {
    String newWord = selectedWord + widget.options[index];
    if(widget.word.toUpperCase().startsWith(newWord)) {
      setState(() {
            selectedIndices.add(index);
            selectedWord = newWord;
        });
    }
    print(newWord +"  "+widget.word);
    if (newWord == widget.word.toUpperCase()) {
      widget.onComplete();
    }
    
    
  }

  

}

class ListIndex extends StatelessWidget {
  ListIndex({Key key, this.index, this.total}) : super(key: key);
  final int index;
  final int total;

  @override
    Widget build(BuildContext context) {
      return Text((index + 1).toString() + ' of ' + total.toString());
    }
}

class SpellingField extends StatelessWidget{
  SpellingField({Key key, this.word}) : super(key: key);

  final String word;

  @override
    Widget build(BuildContext context) {
      return Text(word);
    }
}


class SpellOptions extends StatelessWidget {

  SpellOptions({Key key, this.options, this.selectedIndices, this.onSelect}) : super(key: key);

  final String options;
  final List<int> selectedIndices;
  final Function onSelect;

  @override
    Widget build(BuildContext context) {
      return 
        Expanded(
          child: GridView.count(
              crossAxisCount: 5,
              children: List.generate(options.length, (index) {
              return Center(
                child: Alphabet(index: index, char: options[index], isSelected: selectedIndices.contains(index), onSelect: onSelect) 
              );
            }),
          )
        );
    }
}

class Alphabet extends StatelessWidget {
  Alphabet({Key key, this.index, this.char, this.isSelected, this.onSelect}) : super(key: key);

  final String char;
  final int index;
  final bool isSelected;
  final Function onSelect;

  @override
    Widget build(BuildContext context) {
      return Container(
        padding: const EdgeInsets.all(10.0),
        child: new RaisedButton(
          color: Theme.of(context).accentColor,
          elevation: 4.0,
          splashColor: Colors.blueGrey,
          child: new Text(char, style: new TextStyle(color: Colors.white)),
          onPressed: isSelected ? null : selectChar,
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(100.0)
          )
        ),
      );
    }
          
  void selectChar() {
    onSelect(index);
  }
}
