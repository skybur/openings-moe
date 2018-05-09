import 'package:flutter/material.dart';

class TextHero extends StatelessWidget {
  final String text;
  final TextStyle style;
  final TextOverflow overflow;
  TextHero(this.text, {this.style, this.overflow});
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: text,
      child: new Material(
        color: Colors.transparent,
        child: Text(
          text,
          style: style,
          overflow: overflow,
        ),
      ),
    );
  }
}
