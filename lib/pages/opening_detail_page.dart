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
      if (_videoPlayerController.value.hasError) {
        debugPrint(_videoPlayerController.value.errorDescription);
      }
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
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 48.0,
          child: Row(
            children: <Widget>[
              Icon(Icons.loop),
              Icon(Icons.details),
              Icon(Icons.playlist_add),
            ],
          ),
        ),
        color: Theme.of(context).primaryColor,
        hasNotch: true,
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "MainFAB",
        onPressed: () {
          if (!_videoPlayerController.value.initialized) {
            return null;
          }
          return _videoPlayerController.value.isPlaying
              ? _videoPlayerController.pause()
              : _videoPlayerController.play();
        },
        child: fabIcon(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget buildContent() {
    return Center(
      child: AspectRatio(
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
            ),
          ],
        ),
      ),
    );
  }

  Widget fabIcon() {
    if (!_videoPlayerController.value.initialized) {
      return Container(
        height: 20.0,
        width: 20.0,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }
    return (_videoPlayerController?.value?.isPlaying ?? false)
        ? Icon(Icons.pause)
        : Icon(Icons.play_arrow);
  }
}
