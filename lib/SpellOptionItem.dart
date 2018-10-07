
import 'package:flutter/material.dart';

class SpellOptionItem extends StatefulWidget {
  SpellOptionItem(
      {Key key,
      this.index,
      this.char,
      this.isSelected,
      this.onSelect,
      this.onUnSelectChar,
      this.onUnSelect})
      : super(key: key);

  final String char;
  final int index;
  final bool isSelected;
  final Function onSelect;
  final Function onUnSelect;
  final Function onUnSelectChar;

  @override
  _SpellOptionItemState createState() => new _SpellOptionItemState();
}

class _SpellOptionItemState extends State<SpellOptionItem> with TickerProviderStateMixin {
  AnimationController bounceAnimationController,
      moveAnimationController,
      moveDownAnimationController;
  Animation bounceAnimation,
      moveUpAnimation,
      opacityAnimation,
      moveDownAnimation;
  @override
  initState() {
    super.initState();
    bounceAnimationController = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 100));
    moveAnimationController = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 100));
    moveDownAnimationController = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 100));
    bounceAnimation = new Tween(begin: 0.0, end: 10.0).animate(
        new CurvedAnimation(
            parent: bounceAnimationController, curve: Curves.easeOut));
    moveUpAnimation = new Tween(begin: 0.0, end: 100.0).animate(
        new CurvedAnimation(
            parent: moveAnimationController, curve: Curves.easeOut));
    moveDownAnimation = new Tween(begin: 100.0, end: 10.0).animate(
        new CurvedAnimation(
            parent: moveAnimationController, curve: Curves.easeOut));
    opacityAnimation = new Tween(begin: 0.0, end: 1.0).animate(
        new CurvedAnimation(
            parent: bounceAnimationController, curve: Curves.easeOut));
    bounceAnimation.addListener(() {
      setState(() {});
    });
    moveUpAnimation.addListener(() {
      setState(() {});
    });
    moveDownAnimation.addListener(() {
      setState(() {});
    });
    opacityAnimation.addListener(() {
      setState(() {});
    });
    bounceAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        bounceAnimationController.reverse();
      }
    });
  }

  @override
  dispose() {
    super.dispose();
    bounceAnimationController.dispose();
    moveAnimationController.dispose();
    moveDownAnimationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(10.0),
        child: GestureDetector(
            onTap: widget.isSelected
                ? () => unSelectChar(widget.index)
                : () => selectChar(widget.index),
            child: getStack()));
  }

  Widget getStack() {
    return Stack(
      overflow: Overflow.visible,
      children: <Widget>[
        Container(
            height: 50.0 + bounceAnimation.value,
            width: 50.0 + bounceAnimation.value,
            decoration: ShapeDecoration(
              shape: CircleBorder(side: BorderSide.none),
              color: widget.isSelected ? Colors.grey : Colors.red,
            ),
            child: Center(
                child: Text(
              widget.char,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0),
            ))),
        Positioned(
            bottom: moveUpAnimation.value,
            child: Opacity(
              opacity: opacityAnimation.value,
              child: Container(
                height: 50.0,
                width: 50.0,
                decoration: ShapeDecoration(
                  shape: CircleBorder(side: BorderSide.none),
                  color: Colors.pink,
                ),
              ),
            ))
      ],
    );
  }

  unSelectChar(index) {
    moveUpAnimation =
        new Tween(begin: 100.0 + ((index / 4).floor() * 60.0), end: 0.0)
            .animate(new CurvedAnimation(
                parent: moveAnimationController, curve: Curves.easeOut));
    moveAnimationController.reverse(from: 100.0 + ((index / 4).floor() * 60.0));
    bounceAnimationController.reverse(from: 1.0);
    widget.onUnSelectChar(widget.char);
  }

  void selectChar(index) {
    moveUpAnimation =
        new Tween(begin: 0.0, end: 100.0 + ((index / 4).floor() * 60.0))
            .animate(new CurvedAnimation(
                parent: moveAnimationController, curve: Curves.easeOut));
    bounceAnimationController.forward(from: 0.0);
    moveAnimationController.forward(from: 0.0);
    widget.onSelect(widget.index);
  }
}