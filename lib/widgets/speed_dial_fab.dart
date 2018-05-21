import 'dart:math' as math;

import 'package:flutter/material.dart';

class SpeedDialFab extends StatelessWidget {
  final List<SpeedDialFabData> childFabs;
  final VoidCallback mainFabAction;
  final IconData mainFabIcon;
  final AnimationController controller;

  SpeedDialFab(
    this.mainFabIcon, {
    this.mainFabAction,
    this.controller,
    this.childFabs,
  });

  @override
  Widget build(BuildContext context) {
    return childFabs != null ? buildFabs(context) : null;
  }

  Widget buildFabs(BuildContext context) {
    var bgColor = Theme.of(context).cardColor;
    var fgColor = Theme.of(context).accentColor;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(childFabs.length, (int index) {
        Widget child = Container(
          height: 70.0,
          width: 56.0,
          alignment: FractionalOffset.topCenter,
          child: ScaleTransition(
            scale: CurvedAnimation(
              parent: controller,
              curve: Interval(0.0, 1.0 - index / childFabs.length / 2.0,
                  curve: Curves.easeOut),
            ),
            child: FloatingActionButton(
              heroTag: childFabs[index],
              backgroundColor: bgColor,
              mini: true,
              child: Icon(childFabs[index].iconData, color: fgColor),
              onPressed: childFabs[index].action,
            ),
          ),
        );
        return child;
      }).toList()
        ..add(
          buildMainFab(),
        ),
    );
  }

  Widget buildMainFab() {
    return FloatingActionButton(
      heroTag: "MainFAB",
      child: AnimatedBuilder(
        animation: controller,
        builder: (BuildContext context, Widget child) {
          return Transform(
            transform: Matrix4.rotationZ(controller.value * 0.5 * math.pi),
            alignment: FractionalOffset.center,
            child: Icon(controller.isDismissed ? mainFabIcon : Icons.close),
          );
        },
      ),
      onPressed: mainFabAction ??
          () {
            if (controller.isDismissed) {
              controller.forward();
            } else {
              controller.reverse();
            }
          },
    );
  }
}

class SpeedDialFabData {
  IconData iconData;
  VoidCallback action;
  String tooltipText;

  SpeedDialFabData({this.iconData, this.action, this.tooltipText});
}
