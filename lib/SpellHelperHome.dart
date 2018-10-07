import 'package:flutter/material.dart';
import 'SpellingBuilder.dart';
import 'CreateList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'EditList.dart';

class SpellHelperHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('A For....')),
      body: StreamBuilder(
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
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}

class SpellingList extends StatefulWidget {
  SpellingList({Key key, this.list, this.name}) : super(key: key);

  final List<String> list;
  final String name;

  @override
  _SpellingListState createState() => _SpellingListState();
}

class _SpellingListState extends State<SpellingList> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SpellingBuilder(
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
      setState(() {
        currentIndex = currentIndex + 1;
      });
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SpellHelperHome()),
      );
    }
  }
}

class SpellingLists extends StatelessWidget {
  SpellingLists({Key key, this.lists}) : super(key: key);

  final List lists;

  void _confirmDelete(BuildContext context, String id) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Are you sure you want to delete?"),
          content: new Text("This will delete the list permanently"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Delete"),
              onPressed: () {
                Firestore.instance.collection("Lists").document(id).delete();
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
        itemCount: lists.length,
        padding: EdgeInsets.only(top: 10.0),
        itemBuilder: (context, index) {
          DocumentSnapshot ds = lists[index];
          return GestureDetector(
              child: new Slidable(
                delegate: new SlidableDrawerDelegate(),
                actionExtentRatio: 0.25,
                child: new Container(
                  color: Colors.white,
                  child: new ListTile(
                    leading: new CircleAvatar(
                      backgroundColor: Colors.indigoAccent,
                      child: new Text((index + 1).toString()),
                      foregroundColor: Colors.white,
                    ),
                    title: new Text(ds['name']),
                    subtitle: new Text(ds['level']),
                  ),
                ),
                secondaryActions: <Widget>[
                  new IconSlideAction(
                    caption: 'Edit',
                    color: Colors.black45,
                    icon: Icons.edit,
                    onTap: () {
                      print(ds.documentID);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditList(
                                name: ds['name'],
                                level: ds['level'],
                                values: ds['values'],
                                id: ds.documentID)),
                      );
                    },
                  ),
                  new IconSlideAction(
                    caption: 'Delete',
                    color: Colors.red,
                    icon: Icons.delete,
                    onTap: () {
                      _confirmDelete(context, ds.documentID);
                    },
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SpellingList(
                          name: ds['name'],
                          list: new List<String>.from(ds['values']))),
                );
              });
        });
  }
}
