import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

// Googleスプレッドシートの設定
String spreadsheetId = "1coKKENV_yDSdYgv-bpLGsf1t9Zkn5bskRCGHmxESF2I";
String sheetName = "spot!A2:K1000";
String apikey = "AIzaSyCBqZ8VftKevnjx-p_s8F3VEz4BXik9CeU";
String apiUrl =
    "https://sheets.googleapis.com/v4/spreadsheets/$spreadsheetId/values/$sheetName?key=$apikey";
var apiUri = Uri.parse(apiUrl);

// GoogleスプレッドシートAPIを非同期実行してSpotリストを取得する関数
Future<List<Spot>> fetchSpots() async {
  final response = await http.Client().get(apiUri);
  List<Spot> list =
      await compute(parseSpots, response.body); // computeは非同期で別スレッドで実行
  return list;
}

// GoogleスプレッドシートAPIから得られるvaluesをSpotのリストに変換する関数
List<Spot> parseSpots(String body) {
  List<Spot> spots = [];
  List values = json.decode(body)["values"];
  values.forEach((value) {
    spots.add(
      Spot(
        id: int.parse(value[0]),
        name: value[1],
        desc: value[2],
        imgUrl: value[3],
        address: value[4],
        lat: double.parse(value[5]),
        lng: double.parse(value[6]),
        tel: value[7],
        holiday: value[8],
        businessHours: value[9],
        url: value[10],
      ),
    );
  });
  return spots;
}

// 屋台村データモデル
class Spot {
  final int id;
  final String name;
  final String desc;
  final String imgUrl;
  final String address;
  final double lat;
  final double lng;
  final String tel;
  final String holiday;
  final String businessHours;
  final String url;

  Spot({
    this.id,
    this.name,
    this.desc,
    this.imgUrl,
    this.address,
    this.lat,
    this.lng,
    this.tel,
    this.holiday,
    this.businessHours,
    this.url,
  });
}
