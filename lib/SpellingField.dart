import 'package:flutter/material.dart';

class SpellingField extends StatelessWidget {
  SpellingField({Key key, this.word, this.onClick, this.nextPositionKey})
      : super(key: key);

  final String word;
  final Function onClick;
  final GlobalKey nextPositionKey;

  partition(list, size) => list.isEmpty
      ? list
      : ([list.take(size)]..addAll(partition(list.skip(size), size)));

  @override
  Widget build(BuildContext context) {
    var numberOfRows = 3;
    var numberOfColumns = 4;
    int nextRow = (word.length / numberOfColumns).floor();
    int nextColumn = word.length % numberOfColumns;

    return Container(
        margin: EdgeInsets.only(top: 40.0),
        padding: EdgeInsets.all(20.0),
        width: MediaQuery.of(context).size.width,
        child: Column(
            children: List.generate(numberOfRows, (index) {
          return Row(
            children: List.generate(numberOfColumns, (rowIndex) {
              return Container(
                  key: (nextRow == index && nextColumn == rowIndex) ? nextPositionKey : null,
                  height: 50.0,
                  width: 50.0,
                  
                  child: Center(
                      child: Text(
                    " ",
                  )));
            }),
          );
        })));
  }
}
