import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

// Googleスプレッドシートの設定
String spreadsheetId = "1coKKENV_yDSdYgv-bpLGsf1t9Zkn5bskRCGHmxESF2I";
String sheetName = "stall!A2:K1000";
String apikey = "AIzaSyCBqZ8VftKevnjx-p_s8F3VEz4BXik9CeU";
String apiUrl =
    "https://sheets.googleapis.com/v4/spreadsheets/$spreadsheetId/values/$sheetName?key=$apikey";
var apiUri = Uri.parse(apiUrl);

// GoogleスプレッドシートAPIを非同期実行してStallリストを取得する関数
Future<List<Stall>> fetchStalls() async {
  final response = await http.Client().get(apiUri);
  List<Stall> list =
      await compute(parseStalls, response.body); // computeは非同期で別スレッドで実行
  return list;
}

// GoogleスプレッドシートAPIから得られるvaluesをStallのリストに変換する関数
List<Stall> parseStalls(String body) {
  List<Stall> stalls = [];
  List values = json.decode(body)["values"];
  values.forEach((value) {
    stalls.add(
      Stall(
        id: int.parse(value[0]),
        name: value[1],
        desc: value[2],
        menu: value[3],
        imgUrl: value[4],
        holiday: value[5],
        businessHours: value[6],
        url: value[7],
      ),
    );
  });
  return stalls;
}

// キッチンカーデータモデル
class Stall {
  final int id;
  final String name;
  final String desc;
  final String menu;
  final String imgUrl;
  final String holiday;
  final String businessHours;
  final String url;

  Stall({
    this.id,
    this.name,
    this.desc,
    this.menu,
    this.imgUrl,
    this.holiday,
    this.businessHours,
    this.url,
  });
}
