import 'package:flutter/material.dart';
import 'SpellingBuilder.dart';

void main() => runApp(new SpellHelperApp());

class SpellHelperApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
      return new MaterialApp(
        title: 'Spell Helper',
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
      print(widget.list[currentIndex]);
      return SpellingBuilder(index: currentIndex, total: widget.list.length,word: widget.list[currentIndex], onComplete: nextPage);
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

class SpellHelperHome extends StatelessWidget {
  @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Spell Helper')
        ),
        body: Column(
          children: <Widget>[
            new RaisedButton(
              child: const Text('Start Learning'),
              color: Theme.of(context).accentColor,
              elevation: 4.0,
              splashColor: Colors.blueGrey,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SpellingList(list: ['Cat', 'Dog', 'This'])),
                );
              },
            ),
            new RaisedButton(
              child: const Text('Show Lists'),
              color: Theme.of(context).accentColor,
              elevation: 4.0,
              splashColor: Colors.blueGrey,
              onPressed: () {
                // Perform some action
              },
            ),
            new RaisedButton(
              child: const Text('Create New List'),
              color: Theme.of(context).accentColor,
              elevation: 4.0,
              splashColor: Colors.blueGrey,
              onPressed: () {
                // Perform some action
              },
            ),
          ],
        )
        
      );
    }
} 
