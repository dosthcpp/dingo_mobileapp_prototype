import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:dingo_prototype/components/advertisement_frame.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';

extension IndexedIterable<E> on Iterable<E> {
  Iterable<T> mapIndexed<T>(T Function(E e, int i) f) {
    var i = 0;
    return map((e) => f(e, i++));
  }
}

class Main extends StatelessWidget {
  final void Function(DragStartDetails)? onVerticalDragStart;
  final double? height;
  final Widget? info;
  bool visible;

  Main({
    this.onVerticalDragStart,
    this.height,
    this.visible = false,
    this.info,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          left: 3.0,
          right: 3.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onVerticalDragStart: onVerticalDragStart!,
              child: Padding(
                padding: EdgeInsets.only(
                  left: 15.0,
                  right: 15.0,
                  top: 15.0,
                ),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  height: height,
                  width: MediaQuery.of(context).size.width,
                  child: Material(
                    elevation: 2.0,
                    color: Colors.white,
                    shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          4.0,
                        ),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Visibility(
                          visible: visible,
                          child: Text(
                            "희망유치원 공기질",
                            style: TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Visibility(
                          visible: visible,
                          child: Container(
                            width: 300.0,
                            height: 300.0,
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(
                                150.0,
                              ),
                              border: Border.all(
                                color: Colors.blue,
                                width: 4.0,
                              ),
                            ),
                            child: FutureBuilder<http.Response>(
                              future: http.get(
                                Uri.http(
                                  'korjarvis.asuscomm.com:5051',
                                  '/api',
                                ),
                              ),
                              builder: (ctx, snap) {
                                if (!snap.hasData) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                var _data = json.decode(snap.data!.body);
                                var pm10Data = new List<double>.from(
                                    _data['historical']['pm10']['data']);
                                var _d = pm10Data.mapIndexed((d, i) {
                                  return FlSpot(i.toDouble(), d);
                                });
                                var min = pm10Data.reduce(
                                    (curr, next) => curr < next ? curr : next);
                                var max = pm10Data.reduce(
                                    (curr, next) => curr > next ? curr : next);
                                return LineChart(
                                  LineChartData(
                                    backgroundColor: Colors.transparent,
                                    gridData: FlGridData(
                                      show: true,
                                      drawVerticalLine: false,
                                      getDrawingHorizontalLine: (value) {
                                        return FlLine(
                                          color: Colors.black12,
                                          strokeWidth: 1,
                                          dashArray: [5, 10],
                                        );
                                      },
                                    ),
                                    titlesData: FlTitlesData(
                                      show: false,
                                    ),
                                    borderData: FlBorderData(
                                      show: false,
                                    ),
                                    minX: 0,
                                    maxX: _d.length.toDouble() + 5,
                                    minY: min - 3.0,
                                    maxY: max + 3.0,
                                    lineBarsData: [
                                      LineChartBarData(
                                        spots: _d.toList(),
                                        isCurved: true,
                                        colors: [
                                          Colors.blue,
                                        ],
                                        barWidth: 3,
                                        isStrokeCapRound: true,
                                        dotData: FlDotData(
                                          show: false,
                                        ),
                                        belowBarData: BarAreaData(
                                          show: true,
                                          gradientTo: Offset(0, 1.2),
                                          gradientFrom: Offset(0, 0.5),
                                          colors: [
                                            Colors.blue,
                                            Colors.grey.withOpacity(0.0)
                                          ]
                                              .map((color) =>
                                                  color.withOpacity(0.3))
                                              .toList(),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: 5.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Visibility(
                                visible: !visible,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    right: 30.0,
                                  ),
                                  child: Image.asset(
                                    'images/weather/good.png',
                                    height: 60.0,
                                  ),
                                ),
                              ),
                              info!,
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 20.0,
                bottom: 25.0,
                left: 10.0,
                right: 10.0,
              ),
              child: Card(
                elevation: 2.0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 600.0,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                          top: 10.0,
                          right: 8.0,
                        ),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: GestureDetector(
                            child: Text(
                              "수정",
                              style: TextStyle(
                                fontSize: 10.0,
                                color: Colors.black54,
                              ),
                            ),
                            onTap: () {
                              // Do something
                            },
                          ),
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.0,
                            ),
                            child: CircleAvatar(
                              child: Image.asset(
                                'images/icon.png',
                              ),
                              backgroundColor: Colors.grey[200],
                              radius: 36.0,
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 3.0,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Text(
                                      "박나래",
                                      style: TextStyle(
                                        fontSize: 21.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 3.0,
                                    ),
                                    Text(
                                      "만 5세",
                                      style: TextStyle(
                                        fontSize: 13.0,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 3.0,
                                    ),
                                    Image.asset(
                                      'images/heart_2.png',
                                      height: 20.0,
                                    ),
                                  ],
                                ),
                              ),
                              Material(
                                color: Colors.greenAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 7.0,
                                    vertical: 2.0,
                                  ),
                                  child: Text(
                                    "유치원 이름",
                                    style: TextStyle(
                                      fontSize: 9.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 30.0,
                          bottom: 20.0,
                        ),
                        child: Advertisement(),
                      ),
                      Advertisement(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
