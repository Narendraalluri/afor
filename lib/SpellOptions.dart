
import 'package:flutter/material.dart';
import 'SpellOptionItem.dart';

class SpellOptions extends StatelessWidget {
  SpellOptions(
      {Key key,
      this.options,
      this.selectedIndices,
      this.positions,
      this.onSelect,
      this.onUnSelectChar,
      this.nextPositionKey,
      this.onUnSelect})
      : super(key: key);

  final String options;
  final List<int> selectedIndices;
  final Function onSelect;
  final Function onUnSelect;
  final Function onUnSelectChar;
  final GlobalKey nextPositionKey;
  final Map positions;

  getChunks(String options, int size) {
    var chunks = [];
    for (var i = 0; i < options.length; i += size) {
      int endIndex = (i + size) >= options.length ? options.length : (i + size);
      chunks.add(options.substring(i, endIndex));
    }
    return chunks;
  }
  getItem(int index,  Offset nextPosition) {
    return SpellOptionItem(
                index: index,
                char: options[index],
                position: positions[index],
                isSelected: selectedIndices.contains(index),
                onUnSelect: onUnSelect,
                nextPosition: nextPosition,
                onUnSelectChar: onUnSelectChar,
                onSelect: onSelect);
  }

  getRow(int rowIndex, int chunkSize, String rowString, Offset nextPosition) {
    return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(rowString.length, (char) {
              return getItem(rowIndex*chunkSize + char, nextPosition);
            }),
    );
  }

  @override
  Widget build(BuildContext context) {
    var chunkSize = 4;
    var chunks = getChunks(options, chunkSize);
    Offset nextPosition = Offset(-9.0, 176.0);
    if (nextPositionKey.currentContext != null && selectedIndices.length > 0) {
      final RenderBox renderBoxRed = nextPositionKey.currentContext.findRenderObject();
      nextPosition = renderBoxRed != null ? renderBoxRed.localToGlobal(Offset.zero) : null;
    }
    print(nextPosition);
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: List.generate(chunks.length, (x) {
          return getRow(x, chunkSize, chunks[x], nextPosition);
        }) 
      ),
    );
  }
}

