
import 'package:flutter/material.dart';

class BodyProgress extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
            child: new Stack(
              children: <Widget>[
                new Container(
                  alignment: AlignmentDirectional.center,
                  decoration: new BoxDecoration(
                    color: Colors.white70,
                  ),
                  child: new Container(
                    decoration: new BoxDecoration(
                      borderRadius: new BorderRadius.circular(10.0)
                    ),
                    width: 1000.0,
                    height: 1000.0,
                    alignment: AlignmentDirectional.center,
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Center(
                          child: new SizedBox(
                            height: 50.0,
                            width: 50.0,
                            child: new CircularProgressIndicator(
                              value: null,
                              strokeWidth: 7.0,
                            ),
                          ),
                        ),
                        new Container(
                          margin: const EdgeInsets.only(top: 25.0),
                          child: new Center(
                            child: new Text(
                              "loading.. wait...",
                              style: new TextStyle(
                                color: Colors.white
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
  }
} 
