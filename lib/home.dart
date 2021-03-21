import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kitchencar/spot.dart';
import 'package:kitchencar/spotpage.dart';
import 'package:kitchencar/stall.dart';
import 'package:kitchencar/stallpage.dart';
import 'package:latlong/latlong.dart';

// 屋台村リスト
final spotListProvider = FutureProvider<List<Spot>>((ref) async {
  return fetchSpots();
});

// 屋台リスト
final stallListProvider = FutureProvider<List<Stall>>((ref) async {
  return fetchStalls();
});

List menuItems = [
  {"icon": Icons.landscape, "name": "屋台村"},
  {"icon": Icons.directions_car_outlined, "name": "キッチンカー"},
  {"icon": Icons.map, "name": "地図"},
  {"icon": Icons.question_answer, "name": "ご意見"},
];

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController _pageController = PageController();
  int _index = 0;
  String _title = menuItems[0]["name"];
  TextStyle style = TextStyle(color: Colors.blue[900]);

  // 地図上のマーカ
  LatLng markerCoords = LatLng(34.7676042, 137.3828518);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title, style: style),
        centerTitle: true,
      ),
      body: PageView(
        controller: _pageController,
        children: <Widget>[
          Consumer(
            builder: (context, watch, child) {
              final spotListAsyncValue = watch(spotListProvider);
              return spotListAsyncValue.map(
                data: (_) => SpotPage(spots: _.value),
                loading: (_) => Center(child: CircularProgressIndicator()),
                error: (_) => Text(
                  _.error.toString(),
                  style: TextStyle(color: Colors.red),
                ),
              );
            },
          ),
          Consumer(
            builder: (context, watch, child) {
              final stallListAsyncValue = watch(stallListProvider);
              return stallListAsyncValue.map(
                data: (_) => StallPage(stalls: _.value),
                loading: (_) => Center(child: CircularProgressIndicator()),
                error: (_) => Text(
                  _.error.toString(),
                  style: TextStyle(color: Colors.red),
                ),
              );
            },
          ),
          Consumer(builder: (context, watch, child) {
            final spotListAsyncValue = watch(spotListProvider);
            return spotListAsyncValue.map(
              data: (_) {
                List<Marker> markerList = _.value.map((spot) {
                  return Marker(
                    point: LatLng(
                      spot.lat,
                      spot.lng,
                    ),
                    builder: (BuildContext context) {
                      return Icon(
                        Icons.location_on,
                        color: Colors.white,
                        size: 30.0,
                      );
                    },
                  );
                }).toList();
                return FlutterMap(
                  options: MapOptions(
                    center: markerCoords,
                    zoom: 18,
                  ),
                  layers: [
                    TileLayerOptions(
                      urlTemplate:
                          "https://cyberjapandata.gsi.go.jp/xyz/seamlessphoto/{z}/{x}/{y}.jpg",
                      subdomains: ['a', 'b', 'c'],
                    ),
                    MarkerLayerOptions(markers: markerList),
                  ],
                );
              },
              loading: (_) => Center(child: CircularProgressIndicator()),
              error: (_) => Text(
                _.error.toString(),
                style: TextStyle(color: Colors.red),
              ),
            );
          }),
        ],
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.grey,
        currentIndex: _index,
        items: menuItems.map((menu) {
          return BottomNavigationBarItem(
            icon: Icon(menu["icon"]),
            label: menu["name"],
          );
        }).toList(),
        onTap: (index) {
          setState(() {
            _index = index;
            _title = menuItems[index]["name"];
            _pageController.jumpToPage(index);
          });
        },
      ),
    );
  }
}
