
import 'package:flutter/material.dart';
import 'dart:async';
import 'utils.dart';

class SpellOptionItem extends StatefulWidget {
  SpellOptionItem(
      {Key key,
      this.index,
      this.selectStreamController,
      this.eventStreamController,
      this.streamController,
      this.char,
      this.unSelectIndex,
      this.selectedIndices,
      this.position,
      this.isSelected,
      this.onSelect,
      this.onUnSelectChar,
      this.nextPosition,
      this.onUnSelect})
      : super(key: key);
final StreamController<String> selectStreamController;
final StreamController<Event> eventStreamController;
  final StreamController<String> streamController;
  final String char;
  final List<int> selectedIndices;
  final int index;
  final int unSelectIndex;
  final bool isSelected;
  final Function onSelect;
  final Function onUnSelect;
  final Function onUnSelectChar;
  final Offset nextPosition;
  final Map position;

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
  double left = 0.0, bottom = 0.0, nextLeft = 0.0, nextBottom = 0.0;
  @override
  initState() {
    
    super.initState();
    widget.selectStreamController.stream.listen((data) {
      if (int.parse(data) == widget.index) {
        selectChar(widget.index, nextLeft, nextBottom);
      }
    }, onDone: () {
    }, onError: (error) {
    });
     widget.eventStreamController.stream.listen((data) {
      if (data.type == "RESET") {
        print('RESET');
        moveAnimationController.reset();
      }
    }, onDone: () {
    }, onError: (error) {
    });
    widget.streamController.stream.listen((data) {
      if (widget.selectedIndices != null &&  widget.index == widget.selectedIndices[int.parse(data)]) {
        moveAnimationController.reverse(from: 1.0);
        widget.onUnSelect(widget.selectedIndices.indexOf(widget.index));
      }
    }, onDone: () {
    }, onError: (error) {
    });
    
    moveAnimationController = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 300));
    
    moveUpAnimation = new Tween(begin: 0.0, end: 1.0).animate(new CurvedAnimation(
                parent: moveAnimationController, curve: Curves.easeOut));
    
    moveUpAnimation.addListener(() {
      setState(() {});
    });
    
    moveAnimationController.addStatusListener((status) {
      if(status == AnimationStatus.completed) {
        widget.onSelect(widget.index, nextLeft, nextBottom);
      }
    });
     
  }

  @override
  dispose() {
    super.dispose();
    moveAnimationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
   
    final RenderBox renderBox = context.findRenderObject();
    if (widget.position != null) {
      left = widget.position['left'];
      bottom = widget.position['bottom'];
    }
    
    if (renderBox != null && widget.nextPosition != null) {
      Offset current = renderBox.localToGlobal(Offset.zero);
      Offset next = widget.nextPosition;
      nextLeft = current.dx - next.dx;
      nextBottom = current.dy - next.dy;
    }
    return Container(
        padding: const EdgeInsets.all(10.0),
        child: getStack());
  }

  

  Widget getStack() {

    return Stack(
      overflow: Overflow.visible,
      children: <Widget>[
        Positioned(
            bottom: widget.isSelected ? bottom : moveUpAnimation.value * nextBottom,
            right: widget.isSelected ? left : moveUpAnimation.value * nextLeft,
            child: Opacity(
              opacity: 1.0,
              child: GestureDetector(
                onTap: () => unSelectChar(widget.index),
                child: Container(
                height: 50.0,
                width: 50.0,
                decoration: ShapeDecoration(
                  shape: CircleBorder(side: BorderSide.none),
                  color: Colors.pink,
                ),
                child: Center(
                  child: Text(
                    widget.char,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0),
                  )
                )
              )
              ) ,
            )
          ),
        GestureDetector(child: Container(
            height: 50.0,
            width: 50.0,
            decoration: ShapeDecoration(
              shape: CircleBorder(side: BorderSide.none),
              color: widget.isSelected ? Colors.lightBlueAccent[100] : Colors.grey,
            ),
            child: Center(
                child: Text(
              widget.char,
              style: TextStyle(
                  color: widget.isSelected ? Colors.black : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0),
            )
          )
        ),
        onTap: widget.isSelected
                ? () => unSelectChar(widget.index)
                : () => selectChar(widget.index, nextLeft, nextBottom),
                ) ,
        
      ],
    );
  }

  unSelectChar(index) {
    moveAnimationController.reverse(from: 1.0);
    widget.onUnSelect(widget.selectedIndices.indexOf(index));
  }

  selectChar(index, left, bottom) {
    if(widget.selectedIndices.length < 14) {
      moveAnimationController.forward(from: 0.0);
    }
  }
}