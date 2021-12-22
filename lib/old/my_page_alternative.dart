import 'package:dingo_prototype/components/bottom_navigator_bar.dart';
import 'package:dingo_prototype/data/user_database.dart';
import 'package:dingo_prototype/components/advertisement_frame.dart';
import 'package:dingo_prototype/animation/fade_in.dart';
import 'package:dingo_prototype/mainstages/Announcement.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:core';

final _fireStore = FirebaseFirestore.instance;
User loggedInUser;

class MyPageAlternative extends StatefulWidget {
  static const id = 'my_page_alternative';

  @override
  _MyPageAlternativeState createState() => _MyPageAlternativeState();
}

class _MyPageAlternativeState extends State<MyPageAlternative> {
  final _auth = FirebaseAuth.instance;
  String timeNow = DateTime.now().toString().split(" ")[0] + " ";
  int hour = DateTime.now().hour;
  String minute = DateTime.now().minute.toString();

  String email;
  String name;
  int age;

  static List<charts.Series<_Pollution, int>> _airPollutionData() {
    final data = [
      _Pollution(0, 5),
      _Pollution(1, 20),
      _Pollution(2, 12),
      _Pollution(3, 10),
    ];

    return [
      charts.Series<_Pollution, int>(
        id: 'Pollution',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (_Pollution pollution, _) => pollution.time,
        measureFn: (_Pollution pollution, _) => pollution.airPollutionFactor,
        data: data,
      )
    ];
  }

  @override
  void initState() {
    email = 'black_s@naver.com';
    // getCurrentUser();
    if (int.parse(minute) >= 0 && int.parse(minute) < 10) {
      minute = "0" + minute;
    }
    if (hour >= 0 && hour < 10) {
      timeNow += (hour.toString() + ":" + minute + " AM");
    } else if (hour == 10 || hour == 11) {
      timeNow += (hour.toString() + ":" + minute + " AM");
    } else if (hour == 12) {
      timeNow += (hour.toString() + ":" + minute + " PM");
    } else if (hour >= 13 && hour < 22) {
      timeNow += ("0" + (hour - 12).toString() + ":" + minute + " PM");
    } else if (hour == 22 || hour == 23) {
      timeNow += ((hour - 12).toString() + ":" + minute + " PM");
    }
  }

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        setState(() {
          loggedInUser = user;
          // email = loggedInUser.email;
          email = 'black_s@naver.com';
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<DocumentSnapshot>(
        stream: _fireStore.collection('user').doc(email).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.lightBlueAccent,
              ),
            );
          }
          print(snapshot.data.data());
          final String childName = snapshot.data[userDataItem[2]].toString();
          final String childAge = snapshot.data[userDataItem[4]].toString();
          final String kindergarten = snapshot.data[userDataItem[5]].toString();
          final String className = snapshot.data[userDataItem[6]].toString();
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: 30.0,
                horizontal: 15.0,
              ),
              child: Column(
                children: <Widget>[
                  FadeIn(
                    1.0,
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                            top: 10.0,
                          ),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: GestureDetector(
                              child: Image.asset(
                                'images/alarm_setting.png',
                                height: 30.0,
                              ),
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  AnnouncementPage.id,
                                );
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: 20.0,
                          ),
                          child: SizedBox(
                            height: 485.0,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 30.0,
                                  ),
                                  child: Text(
                                    "$kindergarten 공기질",
                                    style: TextStyle(
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 40.0,
                                  ),
                                  child: Container(
                                    height: 200.0,
                                    width: 200.0,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.blue,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                        100.0,
                                      ),
                                    ),
                                    child: _SimpleLineChart(
                                      _airPollutionData(),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: 15.0,
                                  ),
                                  child: Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 10.0,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 10.0,
                                        ),
                                        child: Text(
                                          "좋음",
                                          style: TextStyle(
                                            fontSize: 48.0,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0XFF2060DA),
                                          ),
                                        ),
                                      ),
                                      Column(
                                        children: <Widget>[
                                          Text(
                                            "통합치수: 15",
                                            style: TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blueAccent,
                                            ),
                                          ),
                                          Text(
                                            timeNow,
                                            style: TextStyle(
                                              fontSize: 10.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blueAccent,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  FadeIn(
                    2.0,
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: 25.0,
                      ),
                      child: Container(
                        height: 110.0,
                        child: Card(
                          elevation: 0.0,
                          color: Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10.0,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 3.0,
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: <Widget>[
                                            Text(
                                              childName,
                                              style: TextStyle(
                                                fontSize: 21.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 3.0,
                                            ),
                                            Text(
                                              "만 $childAge세",
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
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 7.0,
                                            vertical: 2.0,
                                          ),
                                          child: Text(
                                            "$kindergarten $className",
                                            style: TextStyle(
                                              fontSize: 9.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    bottom: 5.0,
                                    right: 5.0,
                                  ),
                                  child: GestureDetector(
                                    child: Text(
                                      "수정",
                                      style: TextStyle(
                                        fontSize: 10.0,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.lightBlue[50],
                              blurRadius: 10.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  FadeIn(3.0, Advertisement()),
                  FadeIn(4.0, Advertisement()),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigatorBar(),
    );
  }
}

/// Sample linear data type.
class _Pollution {
  final int time;
  final int airPollutionFactor;

  _Pollution(this.time, this.airPollutionFactor);
}

class _SimpleLineChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  _SimpleLineChart(this.seriesList, {this.animate});
  @override
  Widget build(BuildContext context) {
    return charts.LineChart(
      seriesList,
      animate: animate,
      primaryMeasureAxis: charts.NumericAxisSpec(
        showAxisLine: false,
        renderSpec: charts.NoneRenderSpec(),
      ),
      domainAxis: charts.NumericAxisSpec(
        showAxisLine: false,
        renderSpec: charts.NoneRenderSpec(),
      )
    );
  }

  /// Create one series with sample hard coded data.
}
