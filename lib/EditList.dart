import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'SpellHelperHome.dart';

class EditList extends StatefulWidget {
  EditList({Key key, this.name, this.level, this.values, this.listIndex, this.userId, this.lists, this.id})
      : super(key: key);

  final String name;
  final String level;
  final String id;
  final String userId;
  final int listIndex;
  final List lists;
  final List<dynamic> values;

  @override
  EditListState createState() => EditListState();
}

class EditListState extends State<EditList> {
  String name;
  String level;
  List<String> words = List.generate(10, (_) => "");

  @override
  initState() {
    super.initState();
    setState(() {
      name = widget.name;
      level = widget.level;
      words = List.generate(10, (index) => widget.values[index]);
    });
  }

  List<Widget> getWords() {
    return List<Container>.generate(
        10,
        (int index) => Container(
            margin: EdgeInsets.only(top: 15.0, bottom: 15.0),
            child: TextField(
              controller: TextEditingController(text: words[index]),
              textAlign: TextAlign.center,
              textCapitalization: TextCapitalization.characters,
              decoration: InputDecoration(
                  labelText: 'Word ' + (index + 1).toString(),
                  hintText: 'Enter the word'),
              onChanged: (value) {
                setState(() {
                  words[index] = value;
                });
              },
            )));
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> formCells = [
      Container(
        margin: EdgeInsets.only(top: 15.0, bottom: 15.0),
        child: TextField(
          controller: TextEditingController(
            text: name,
          ),
          onChanged: (value) {
            print(value);
            setState(() {
              name = value;
            });
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
        appBar: AppBar(title: Text('Edit List')),
        body: Container(
          margin: EdgeInsets.all(20.0),
          child: ListView(
            children: formCells,
          ),
        ),
        floatingActionButton: Container(
          child: FloatingActionButton(
            onPressed: () async {
              List newList = new List();
                widget.lists.asMap().forEach((i, value) {
                    if(i != widget.listIndex) {
                      newList.add(value);
                    } else {
                      newList.add({
                        "level": level,
                        "name": name,
                        "order": widget.lists[widget.listIndex]['order'],
                        "values": words,
                      });
                    }
                });
              await Firestore.instance.collection("UserList").document(widget.userId).updateData({
                   'lists': newList
                 });
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SpellHelperHome(lists: newList, userId: widget.userId)),
              );
            },
            child: Icon(Icons.save),
          ),
        ));
  }
}
