
import 'package:flutter/material.dart';

class SpellingField extends StatelessWidget {
  SpellingField({Key key, this.word, this.onClick}) : super(key: key);

  final String word;
  final Function onClick;

  partition(list, size) => list.isEmpty ? list : ([list.take(size)]..addAll(partition(list.skip(size), size)));

  @override
  Widget build(BuildContext context) {

    var partitions = partition(word.split(''), 8);
    
    if (partitions.length == 1) {
      print(partitions[0]);
    }
    return Container(
        margin: EdgeInsets.only(top: 40.0),
        padding: EdgeInsets.all(20.0),
        width: MediaQuery.of(context).size.width,
        child: Column(
        children: List.generate(partitions.length, (index) {
          return Row(
            children: List.generate(partitions[index].length, (rowIndex) {
              return GestureDetector(
                onTap: () {
                  int charIndex = ((index) * 8 + rowIndex);
                  print(charIndex);
                  onClick(charIndex);
                },
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    partitions[index].join()[rowIndex],
                    style: TextStyle(color: Colors.black, fontSize: 30.0, decoration: TextDecoration.underline),
                  ),
                ),
              );
            }),
          );
        })
        )
    );
  }
}
