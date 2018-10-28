import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'EditList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'SpellHelperHome.dart';
import 'SpellingList.dart';

class SpellingLists extends StatelessWidget {
  SpellingLists({Key key, this.lists, this.userId}) : super(key: key);

  final List lists;
  final String userId;

  void _confirmDelete(BuildContext context, String userId, int listIndex) {
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
              onPressed: () async {
                List newList = new List();
                lists.asMap().forEach((i, value) {
                    if(i != listIndex) {
                      newList.add(value);
                    }
                });
                 await Firestore.instance.collection("UserList").document(userId).updateData({
                   'lists': newList
                 });
                 Navigator.of(context).pop();
                 Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SpellHelperHome(lists: newList, userId: userId)),
                );
                
               
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
          var ds = lists[index];
          return GestureDetector(
              child: new Slidable(
                delegate: new SlidableDrawerDelegate(),
                actionExtentRatio: 0.25,
                child: new Container(
                  
                  child: new ListTile(
                    leading: new CircleAvatar(
                      backgroundColor: Colors.green,
                      child: new Text((index + 1).toString()),
                      foregroundColor: Colors.white,
                    ),
                    title: new Text(ds['name'], style: TextStyle(
                      fontWeight: FontWeight.bold
                    ),),
                    subtitle: new Text(ds['level']),
                  ),
                ),
                secondaryActions: <Widget>[
                  new IconSlideAction(
                    caption: 'Edit',
                    color: Colors.black45,
                    icon: Icons.edit,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditList(
                                name: ds['name'],
                                level: ds['level'],
                                values: ds['values'],
                                listIndex: index,
                                userId: userId,
                                lists: lists,
                                id: index.toString())),
                      );
                    },
                  ),
                  new IconSlideAction(
                    caption: 'Delete',
                    color: Colors.red,
                    icon: Icons.delete,
                    onTap: () {
                      _confirmDelete(context, userId, index);
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