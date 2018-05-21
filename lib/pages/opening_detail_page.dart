import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../models/opening.dart';
import '../services/openings_service.dart';
import '../widgets/text_hero.dart';

class OpeningDetailPage extends StatefulWidget {
  final String title;
  final Opening openingData;
  OpeningDetailPage({this.title, this.openingData});
  @override
  _OpeningDetailPageState createState() => new _OpeningDetailPageState();
}

class _OpeningDetailPageState extends State<OpeningDetailPage> {
  VideoPlayerController _videoPlayerController;
  VoidCallback _controllerListener;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _controllerListener = () {
      _initialized = _videoPlayerController.value.initialized;
      setState(() {});
    };

    _videoPlayerController = VideoPlayerController
        .network("${OpeningsService.videoUrl}/${widget.openingData.file}")
          ..addListener(_controllerListener)
          ..initialize()
          ..play();
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController.removeListener(_controllerListener);
    if (_videoPlayerController.value.isPlaying) {
      _videoPlayerController.pause();
    }
    _videoPlayerController.dispose();
  }

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
      floatingActionButton: _initialized
          ? FloatingActionButton(
              heroTag: "MainFAB",
              onPressed: _videoPlayerController.value.isPlaying
                  ? _videoPlayerController.pause
                  : _videoPlayerController.play,
              child: (_videoPlayerController?.value?.isPlaying ?? false)
                  ? Icon(Icons.pause)
                  : Icon(Icons.play_arrow),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget buildContent() {
    return Center(
      child: _initialized
          ? AspectRatio(
              aspectRatio: 1280 / 720,
              child: new Stack(
                fit: StackFit.passthrough,
                children: <Widget>[
                  VideoPlayer(
                    _videoPlayerController,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: _initialized
                        ? VideoProgressIndicator(
                            _videoPlayerController,
                            allowScrubbing: true,
                          )
                        : null,
                  ),
                  Center(
                    child: _videoPlayerController.value.isBuffering
                        ? CircularProgressIndicator()
                        : null,
                  )
                ],
              ),
            )
          : CircularProgressIndicator(),
    );
  }

  Widget buildProgressIndicator() {
    return new Center(
      child: _videoPlayerController.value.isPlaying &&
              _videoPlayerController.value.isBuffering
          ? CircularProgressIndicator()
          : null,
    );
  }
}
