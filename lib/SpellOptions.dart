
import 'package:flutter/material.dart';
import 'SpellOptionItem.dart';
import 'dart:async';
import 'utils.dart';

class SpellOptions extends StatelessWidget {
  SpellOptions(
      {Key key,
      this.scrollOffset,
      this.selectStreamController,
      this.eventStreamController,
      this.streamController,
      this.options,
      this.unSelectIndex,
      this.selectedIndices,
      this.positions,
      this.onSelect,
      this.onUnSelectChar,
      this.nextPositionKey,
      this.onUnSelect})
      : super(key: key);

  final StreamController<String> selectStreamController;
  final StreamController<String> streamController;
  final StreamController<Event> eventStreamController;
  final int unSelectIndex;
  final String options;
  final double scrollOffset;
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
                selectStreamController: selectStreamController,
                eventStreamController: eventStreamController,
                streamController: streamController,
                unSelectIndex: unSelectIndex,
                char: options[index],
                position: positions[index],
                selectedIndices: selectedIndices,
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
    var numberOfColumns = MediaQuery.of(context).size.width < 330 ? 7 : 8;
    int nextRow = (selectedIndices.length / numberOfColumns).floor();
    int nextColumn = selectedIndices.length % numberOfColumns;
    Offset nextPosition = Offset(10.0 + (nextColumn*40), (150.0 - scrollOffset)  + (nextRow*50));

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

