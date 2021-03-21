import 'package:flutter/material.dart';

import 'stall.dart';

// 屋台のGridView
class StallPage extends StatelessWidget {
  final List<Stall> stalls;
  const StallPage({this.stalls});

  @override
  Widget build(BuildContext context) {
    if (stalls.isNotEmpty) {
      return GridView(
        children: stalls.map((stall) => StallCard(stall: stall)).toList(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
      );
    } else {
      return Container(child: Center(child: Text("Empty...")));
    }
  }
}

// 屋台のGridViewのカード画面
class StallCard extends StatelessWidget {
  StallCard({this.stall});
  final Stall stall;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => StallDetail(stall: stall)),
      ),
      splashColor: Colors.blue.withAlpha(30),
      child: Card(
        child: Container(
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: Image.asset(stall.imgUrl).image,
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: null),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            stall.name,
                            style: Theme.of(context).textTheme.subtitle2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        stall.desc,
                        maxLines: 1,
                        style: Theme.of(context).textTheme.caption,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 屋台詳細画面
class StallDetail extends StatefulWidget {
  StallDetail({this.stall});
  final Stall stall;

  @override
  _StallDetailState createState() => _StallDetailState();
}

class _StallDetailState extends State<StallDetail> {
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(children: <Widget>[
        // 全体の背景
        Container(
            height: screenHeight,
            width: screenWidth,
            color: Colors.transparent),
        // 上半分はお店のロゴ
        Container(
          height: screenHeight / 2.5,
          width: screenWidth,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(widget.stall.imgUrl), fit: BoxFit.cover),
          ),
        ),
        Align(
            // 画面左上は戻るボタン
            alignment: Alignment.topLeft,
            child: Padding(
                padding: EdgeInsets.only(left: 15.0, top: 20.0),
                child: InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                      height: 40.0,
                      width: 40.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey,
                      ),
                      child: Center(
                          child: Icon(Icons.arrow_back,
                              size: 20.0, color: Colors.white))),
                ))),
        Positioned(
            // 下半分は屋台名と説明
            top: screenHeight / 2.5,
            child: Container(
              padding: EdgeInsets.all(10),
              width: screenWidth,
              height: screenHeight,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 屋台名
                    Text(
                      widget.stall.name,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 10),
                    // 屋台の説明
                    Text(
                      widget.stall.desc,
                      maxLines: 10,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: Colors.black),
                      strutStyle: StrutStyle(fontSize: 12, height: 1.2),
                    ),
                  ]),
            ))
      ]),
    );
  }
}
