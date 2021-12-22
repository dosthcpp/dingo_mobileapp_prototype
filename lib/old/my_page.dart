import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:dingo_prototype/data/user_database.dart';
import 'package:dingo_prototype/components/advertisement_frame.dart';
import 'package:dingo_prototype/animation/fade_in.dart';
import 'package:dingo_prototype/mainstages/Announcement.dart';
import 'package:dingo_prototype/mainstages/SettingsPage.dart';

import 'package:dingo_prototype/old/my_page_alternative.dart';

import 'package:dingo_prototype/old/main_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _fireStore = FirebaseFirestore.instance;
User loggedInUser;

class MyPage extends StatefulWidget {
  static const id = 'my_page';

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final _auth = FirebaseAuth.instance;
  String timeNow = DateTime.now().toString().split(" ")[0] + " ";
  int hour = int.parse(DateTime.now().toString().split(" ")[1].split(":")[0]);
  String minute = DateTime.now().toString().split(" ")[1].split(":")[1];

  String email;
  String name;
  int age;

  @override
  void initState() {
    email = 'black_s@naver.com';
    // getCurrentUser();
    if (int.parse(minute) >= 0 && int.parse(minute) < 10) {
      minute = "0" + minute;
    }
    if (hour >= 0 && hour < 10) {
      timeNow += ("0" + hour.toString() + ":" + minute + " AM");
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
      final user = await _auth.currentUser;
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              GestureDetector(
                                child: Icon(
                                  Icons.add,
                                ),
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    MyPageAlternative.id,
                                  );
                                },
                              ),
                              GestureDetector(
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
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: 20.0,
                          ),
                          child: SizedBox(
                            height: 100.0,
                            child: Row(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 40.0,
                                  ),
                                  child: Image.asset(
                                    // 공기질 아이콘
                                    'images/weather/good.png',
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
                                        child: Text(
                                          "$kindergarten 공기질",
                                          style: TextStyle(
                                            fontSize: 22.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 10.0,
                                            ),
                                            child: Text(
                                              "좋음",
                                              style: TextStyle(
                                                fontSize: 25.0,
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
                                                  fontSize: 8.0,
                                                  color: Colors.blueAccent,
                                                ),
                                              ),
                                            ],
                                          )
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
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (idx) {
          switch (idx) {
            case 0:
              Navigator.pushNamed(
                context,
                MainPage.id,
              );
              break;
            case 2:
              Navigator.pushNamed(
                context,
                AnnouncementPage.id,
              );
              break;
            case 3:
              Navigator.pushNamed(
                context,
                SettingsPage.id,
              );
              break;
          }
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            title: Text(
              "home",
            ),
            icon: Image.asset(
              'images/home.png',
              height: 35.0,
            ),
          ),
          BottomNavigationBarItem(
            title: Text(
              "message",
            ),
            icon: Image.asset(
              'images/message.png',
              height: 35.0,
            ),
          ),
          BottomNavigationBarItem(
            title: Text(
              "calendar",
            ),
            icon: Image.asset(
              'images/daily.png',
              height: 35.0,
            ),
          ),
          BottomNavigationBarItem(
            title: Text(
              "menu",
            ),
            icon: Image.asset(
              'images/others.png',
              height: 35.0,
            ),
          ),
        ],
      ),
    );
  }
}
