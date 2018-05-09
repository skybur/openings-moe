import 'package:flutter/material.dart';

import '../models/opening.dart';
import '../widgets/text_hero.dart';

class OpeningDetailPage extends StatefulWidget {
  final String title;
  final Opening openingData;
  OpeningDetailPage({this.title, this.openingData});
  @override
  _OpeningDetailPageState createState() => new _OpeningDetailPageState();
}

class _OpeningDetailPageState extends State<OpeningDetailPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: new TextHero(
          widget.title,
          style: TextStyle(
            fontFamily: "Roboto",
            decoration: TextDecoration.none,
            color: Colors.white,
            fontSize: 16.0,
            fontWeight: FontWeight.normal,
          ),
          overflow: TextOverflow.fade,
        ),
      ),
      body: buildContent(),
      floatingActionButton: FloatingActionButton(
        heroTag: "MainFAB",
        child: Icon(Icons.play_arrow),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget buildContent() {
    return Text("A");
  }
}
