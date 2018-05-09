import 'dart:math' as math;

import 'package:flutter/material.dart';

class SpeedDialFab extends StatelessWidget {
  final List<SpeedDialFabData> childFabs;
  final IconData mainFabIcon;
  final AnimationController controller;

  SpeedDialFab(this.mainFabIcon, this.childFabs, this.controller);

  @override
  Widget build(BuildContext context) {
    var bgColor = Theme.of(context).cardColor;
    var fgColor = Theme.of(context).accentColor;
    return new Column(
      mainAxisSize: MainAxisSize.min,
      children: new List.generate(childFabs.length, (int index) {
        Widget child = new Container(
          height: 70.0,
          width: 56.0,
          alignment: FractionalOffset.topCenter,
          child: new ScaleTransition(
            scale: new CurvedAnimation(
              parent: controller,
              curve: new Interval(0.0, 1.0 - index / childFabs.length / 2.0,
                  curve: Curves.easeOut),
            ),
            child: new FloatingActionButton(
              heroTag: childFabs[index],
              backgroundColor: bgColor,
              mini: true,
              child: new Icon(childFabs[index].iconData, color: fgColor),
              onPressed: childFabs[index].action,
            ),
          ),
        );
        return child;
      }).toList()
        ..add(
          new FloatingActionButton(
            heroTag: "MainFAB",
            child: new AnimatedBuilder(
              animation: controller,
              builder: (BuildContext context, Widget child) {
                return new Transform(
                  transform:
                      new Matrix4.rotationZ(controller.value * 0.5 * math.pi),
                  alignment: FractionalOffset.center,
                  child: new Icon(
                      controller.isDismissed ? mainFabIcon : Icons.close),
                );
              },
            ),
            onPressed: () {
              if (controller.isDismissed) {
                controller.forward();
              } else {
                controller.reverse();
              }
            },
          ),
        ),
    );
  }
}

class SpeedDialFabData {
  IconData iconData;
  VoidCallback action;
  String tooltipText;

  SpeedDialFabData({this.iconData, this.action, this.tooltipText});
}
