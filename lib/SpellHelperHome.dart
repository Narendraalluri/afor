import 'package:flutter/material.dart';
import 'CreateList.dart';
import 'SpellingLists.dart';
import 'main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();

const List<Choice> choices = const <Choice>[
  const Choice(title: 'Logout', icon: Icons.link_off),
];

class SpellHelperHome extends StatelessWidget {
  SpellHelperHome({Key key, this.lists, this.userId}) : super(key: key);

  final List lists;
  final String userId;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        actions: <Widget>[
           PopupMenuButton<Choice>(
             onSelected: (choice) async {
                await _auth.signOut();
                GoogleSignInAccount account = await _googleSignIn.disconnect();
                print(account);
                account = await _googleSignIn.signOut();
                print(account);

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SpellHelperApp()),
                );
             },
              itemBuilder: (BuildContext context) {
                return choices.map((Choice choice) {
                  return PopupMenuItem<Choice>(
                    value: choice,
                    child: Text(choice.title),
                  );
                }).toList();
              },
            ),
        ],
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


