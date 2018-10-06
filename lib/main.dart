import 'package:flutter/material.dart';
import 'SpellingBuilder.dart';
import 'CreateList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

void main() => runApp(new SpellHelperApp());

class SpellHelperApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
      return new MaterialApp(
        home: SpellHelperHome(),
      );
  }
  
}

class SpellingList extends StatefulWidget {

  SpellingList({Key key, this.list}) : super(key: key);

  final List<String> list;

  @override
    _SpellingListState createState() => _SpellingListState();
}

class _SpellingListState extends State<SpellingList> {

  int currentIndex = 0;

   @override
    Widget build(BuildContext context) {
      return SpellingBuilder(index: currentIndex, total: widget.list.length,word: widget.list[currentIndex], onComplete: nextPage, options: getOptions(widget.list[currentIndex]));
    }

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
      return optionList.join() ;
    }

  nextPage() {
    if (currentIndex + 1 < widget.list.length) {
      setState(() {
          currentIndex = currentIndex + 1 ;
        });
    } else {
       Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Results()),
                );
    }
  }
}

class Results extends StatelessWidget {
  @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Spell Helper - Results')
        ),
        body: Column(
          children: <Widget>[
            new RaisedButton(
              child: const Text('See Results'),
              color: Theme.of(context).accentColor,
              elevation: 4.0,
              splashColor: Colors.blueGrey,
              onPressed: null
            ),
          ],
        )
        
      );
    }
}

class SpellingLists extends StatelessWidget {
  SpellingLists({Key key, this.lists}) : super(key: key);

  final List lists;

  @override
    Widget build(BuildContext context) {
      return new ListView.builder(
              itemCount: lists.length,
              padding: EdgeInsets.only(top: 10.0),
              itemBuilder: (context, index) {
                DocumentSnapshot ds = lists[index];
                return Container(
                  padding: EdgeInsets.all(10.0),
                  child: RaisedButton(
                    child: new Text(" ${ds['name']}", style: TextStyle(color: Colors.white),),
                    color: Theme.of(context).accentColor,
                    elevation: 4.0,
                    splashColor: Colors.blueGrey,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SpellingList(list: new List<String>.from(ds['values']))),
                      );
                    },
                  ),
                );
              }
            );
    }
}

class SpellHelperHome extends StatelessWidget {
  @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('A For....')
        ),
        body:  StreamBuilder(
          stream: Firestore.instance.collection('Lists').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Text('Loading...');
            return SpellingLists(lists: snapshot.data.documents);
          }),
        floatingActionButton: Container(
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CreateList()),
                  );
            },
            child:  Icon(Icons.add),
          ),
        ),
      );
    }
} 
