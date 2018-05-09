import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/opening.dart';

class OpeningsService {
  static const String baseUrl = "http://openings.moe/api";
  static Future<List<Opening>> getOpeningList(
      {bool shouldShuffle = false}) async {
    await Future.delayed(Duration(milliseconds: 1000));
    final apiUrl = "$baseUrl/list.php";
    final response = await http.get(apiUrl);
    final List jsonArr = json.decode(response.body);
    return jsonArr.map((openingJson) => Opening.fromJson(openingJson)).toList();
  }
}
