import 'package:flutter/material.dart';
import 'CreateList.dart';
import 'SpellingLists.dart';

class SpellHelperHome extends StatelessWidget {
  SpellHelperHome({Key key, this.lists, this.userId}) : super(key: key);

  final List lists;
  final String userId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        leading: Container(),
        title: Text('A For....', style: TextStyle(color: Colors.black),), 
        backgroundColor: Colors.lightGreen
        ),
      body: SpellingLists(lists: lists, userId: userId),
      floatingActionButton: Container(
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CreateList(
                userId: userId,
                lists: lists,
              )),
            );
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}


