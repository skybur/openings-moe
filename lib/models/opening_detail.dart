import 'opening.dart';

class OpeningDetail extends Opening {
  String success;
  String comment;
  String subtitles;

  OpeningDetail.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    this.success = json["success"];
    this.comment = json["comment"];
    this.subtitles = json["subtitles"];
  }
}
