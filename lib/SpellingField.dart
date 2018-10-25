
import 'package:flutter/material.dart';

class SpellingField extends StatelessWidget {
  SpellingField({Key key, this.word, this.onClick, this.nextPositionKey}) : super(key: key);

  final String word;
  final Function onClick;
  final GlobalKey nextPositionKey;

  partition(list, size) => list.isEmpty ? list : ([list.take(size)]..addAll(partition(list.skip(size), size)));

  @override
  Widget build(BuildContext context) {
    var numberOfRows = 3;
    var numberOfColumns = 4;
    var partitions = partition(word.split(''), numberOfColumns - 1);
    print(partitions);
    return Container(
        margin: EdgeInsets.only(top: 40.0),
        padding: EdgeInsets.all(20.0),
        width: MediaQuery.of(context).size.width,
        child: Column(
        children: List.generate(numberOfRows, (index) {
          return Row(
            children: List.generate(numberOfColumns, (rowIndex) {
              if (partitions.length == 0 && index == 0 && rowIndex == 0) {
                return GestureDetector(
                  key: nextPositionKey,
                  child: const Icon(Icons.backspace),
                  onTap: () {
                    onClick(word.length - 1);
                  },
                );
              }
              if ((index >= partitions.length || rowIndex > partitions[index].length)) {
                return Container(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    " ",
                    style: TextStyle(color: Colors.black, fontSize: 30.0),
                  )
                );
              }
              return rowIndex == partitions[index].length ? 
                index == partitions.length - 1 ? GestureDetector(
                  key: nextPositionKey,
                  child: const Icon(Icons.backspace),
                  onTap: () {
                    onClick(word.length - 1);
                  },
                ) : Container()
              : GestureDetector(
                onTap: () {
                  int charIndex = ((index) * numberOfColumns + rowIndex);
                  onClick(charIndex);
                },
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    " ",
                    style: TextStyle(color: Colors.black, fontSize: 30.0),
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
