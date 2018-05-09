import 'song.dart';

class Opening {
  String title;
  String source;
  String file;
  Song song;

  Opening({this.title, this.source, this.file, this.song});

  Opening.fromJson(Map<String, dynamic> json) {
    this.title = json["title"];
    this.source = json["source"];
    this.file = json["file"];
    this.song = json["song"] != null ? Song.fromJson(json["song"]) : null;
  }
}
