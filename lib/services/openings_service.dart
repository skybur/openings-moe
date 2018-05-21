import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/opening.dart';

class OpeningsService {
  static const String baseUrl = "http://openings.moe";
  static const String apiUrl = "$baseUrl/api";
  static const String videoUrl = "$baseUrl/video";
  static Future<List<Opening>> getOpeningList(
      {bool shouldShuffle = false}) async {
    await Future.delayed(Duration(milliseconds: 1000));
    final api = "$apiUrl/list.php";
    final response = await http.get(api);
    final List jsonArr = json.decode(response.body);
    return jsonArr.map((openingJson) => Opening.fromJson(openingJson)).toList();
  }
}
