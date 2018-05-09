class Song {
  String title;
  String artist;

  Song.fromJson(Map<String, dynamic> json) {
    this.title = json["title"];
    this.artist = json[artist];
  }
}
