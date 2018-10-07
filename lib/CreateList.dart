import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'SpellHelperHome.dart';

class CreateList extends StatefulWidget {
  @override
  CreateListState createState() => CreateListState();
}

class CreateListState extends State<CreateList> {
  String name;
  String level;
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
              level = value;
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
                    width: 300.0,
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
            onPressed: () {
              print(name);
              print(level);
              print(words);
              CollectionReference x = Firestore.instance.collection("Lists");
              Firestore.instance.runTransaction((Transaction tx) async {
                await x.add({
                  "level": level,
                  "name": name,
                  "values": words,
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SpellHelperHome()),
                );
              });
            },
            child: Icon(Icons.save),
          ),
        ));
  }
}
