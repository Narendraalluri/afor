
import 'package:flutter/material.dart';
import 'SpellOptionItem.dart';

class SpellOptions extends StatelessWidget {
  SpellOptions(
      {Key key,
      this.options,
      this.selectedIndices,
      this.onSelect,
      this.onUnSelectChar,
      this.onUnSelect})
      : super(key: key);

  final String options;
  final List<int> selectedIndices;
  final Function onSelect;
  final Function onUnSelect;
  final Function onUnSelectChar;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
      margin: EdgeInsets.only(top: 20.0, bottom: 20.0),
      child: GridView.count(
        crossAxisCount: 4,
        children: List.generate(options.length, (index) {
          return SpellOptionItem(
                index: index,
                char: options[index],
                isSelected: selectedIndices.contains(index),
                onUnSelect: onUnSelect,
                onUnSelectChar: onUnSelectChar,
                onSelect: onSelect);
        })
      ),
    )
    );
  }
}

