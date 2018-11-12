import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'SpellHelperHome.dart';

class CreateList extends StatefulWidget {

CreateList({Key key, this.userId, this.lists})
      : super(key: key);
  final String userId;
  final List lists;

  @override
  CreateListState createState() => CreateListState();
}

class CreateListState extends State<CreateList> {
  String name;
  String level;
  String formError;
  List<String> words = List.generate(10, (_) => "");

  List<Widget> getWords() {
    return List<Container>.generate(
        10,
        (int index) => Container(
            margin: EdgeInsets.only(top: 15.0, bottom: 15.0),
            child: TextField(
              textAlign: TextAlign.center,
              textCapitalization: TextCapitalization.characters,
              decoration: InputDecoration(
                  labelText: 'Word ' + (index + 1).toString(),
                  hintText: 'Enter the word'),
              onChanged: (value) {
                words[index] = value;
              },
            )));
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> formCells = [
      new Row(
            children: <Widget>[
              new Expanded(
                child: new Padding(
                  padding: const EdgeInsets.only(left: 20.0, bottom: 50.0),
                  child: new Text(
                    formError == null ? '' : formError,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.lightGreen,
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
      Container(
        margin: EdgeInsets.only(top: 15.0, bottom: 15.0),
        child: TextField(
          onChanged: (value) {
            name = value;
          },
          decoration:
              InputDecoration(labelText: 'Name', hintText: 'Name of the List'),
        ),
      ),
      Container(
          margin: EdgeInsets.only(top: 15.0, bottom: 15.0),
          child: DropdownButton(
            value: level,
            hint: Text('Select the Level'),
            onChanged: (value) {
              setState(() {
                level = value;  
              });
            },
            isDense: true,
            items: <String>[
              'Very Easy',
              'Easy',
              'Intermediate',
              'Hard',
              'Very Hard'
            ].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Container(
                    width: MediaQuery.of(context).size.width - 65.0,
                    child: Text(
                      value,
                    )),
              );
            }).toList(),
          )),
    ];
    formCells.addAll(getWords());
    return Scaffold(
        appBar: AppBar(title: Text('Create new List')),
        body: Container(
          margin: EdgeInsets.all(20.0),
          child: ListView(
            children: formCells,
          ),
        ),
        floatingActionButton: Container(
          child: FloatingActionButton(
            onPressed: () async {
              bool invalid = words.any((x) {
               return x == null || x.length == 0;
              });
              if (level == '' || name == '' || words.length < 0 || invalid) {
                  setState(() {
                      formError = 'All the below fields should be completed';
                  });
                return;
              }
             
             List newList = new List();
                widget.lists.asMap().forEach((i, value) {
                      newList.add(value);
                });
              newList.add({
                        "level": level,
                        "name": name,
                        "order": widget.lists.length,
                        "values": words,
                      });
              Firestore.instance.runTransaction((Transaction tx) async {
                await Firestore.instance.collection("UserList").document(widget.userId).updateData({
                   'lists': newList
                 });
              }
              );
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SpellHelperHome(
                    lists: newList,
                    userId: widget.userId
                  )),
                );
            },
            child: Icon(Icons.save),
          ),
        ));
  }
}
