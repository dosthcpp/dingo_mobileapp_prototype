import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dingo_prototype/components/appbar.dart';
import 'package:dingo_prototype/main.dart';
import 'package:dingo_prototype/mainstages/AgreementManagement.dart';
import 'package:dingo_prototype/mainstages/Announcement.dart';
import 'package:dingo_prototype/mainstages/Program.dart';
import 'package:dingo_prototype/mainstages/SettingsPage.dart';
import 'package:dingo_prototype/screens/notificationPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

import 'package:dingo_prototype/components/bottom_navigator_bar.dart';
import 'package:dingo_prototype/mainstages/Main.dart';
import 'package:dingo_prototype/mainstages/ChatRoom.dart';

import 'utils.dart' show today;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';

final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

final _auth = FirebaseAuth.instance;
final _col = FirebaseFirestore.instance.collection('attendance');
User? loggedInUser;

class MainPage extends StatefulWidget {
  static const id = 'main_page_alternative';

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String timeNow = DateTime.now().toString().split(" ")[0] + " ";
  int hour = DateTime.now().hour;
  String minute = DateTime.now().minute.toString();
  bool _resized = false;
  bool _visible = true;
  double _height = 485.0;
  double _textSizeStatus = 50.0;
  double _textSizeFigure = 18.0;
  double _textSizeTime = 10.0;

  int mainStageIndex = 0;
  int main = 0,
      chat = 1,
      announce = 2,
      agreement = 3,
      program = 4,
      settings = 5;

  String email = 'black_s@naver.com';

  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
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
          email = loggedInUser!.email!;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  renderAppBar() {
    switch (mainStageIndex) {
      case 0:
        return PreferredSize(
          preferredSize: Size.fromHeight(30.0),
          child: MainAppbar(),
        );
      case 1:
        return PreferredSize(
          preferredSize: Size.fromHeight(
            120.0,
          ),
          child: ChatRoomAppbar(),
        );
      case 3:
        return PreferredSize(
          child: AppBar(
            backgroundColor: Colors.white,
            elevation: 5.0,
            centerTitle: true,
            title: Text(
              "동의서 관리",
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
              textAlign: TextAlign.center,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
          ),
          preferredSize: Size.fromHeight(
            60.0,
          ),
        );
      case 4:
        return PreferredSize(
          child: AppBar(
            backgroundColor: Colors.white,
            elevation: 5.0,
            centerTitle: true,
            title: Text(
              "지원 프로그램",
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
              textAlign: TextAlign.center,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
          ),
          preferredSize: Size.fromHeight(
            60.0,
          ),
        );
      case 5:
        return PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: AppBarDesign(
            isMainScreen: false,
            onTap: () {
              Navigator.pop(context);
            },
          ),
        );
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _col
          .where("원아 이름", isEqualTo: "백도연")
          // .where("날짜", isLessThanOrEqualTo: today)
          .snapshots(includeMetadataChanges: true)
          .asyncMap((snapshot) {
        snapshot.docChanges.forEach((element) async {
          // const AndroidNotificationDetails androidPlatformChannelSpecifics =
          //     AndroidNotificationDetails('your channel id', 'your channel name',
          //         channelDescription: 'your channel description',
          //         importance: Importance.max,
          //         priority: Priority.high,
          //         ticker: 'ticker');
          const NotificationDetails platformChannelSpecifics =
              NotificationDetails(
                  // android: androidPlatformChannelSpecifics,
                  );
          final _data = element.doc.data()!;
          if (_data['isNotified'] == false) {
            final Map<String, dynamic> notiContent = {
              "content":
                  '백도연 원아의 출결상태가 ${_data['출석'] == true ? '출석' : '결석'}으로 변경되었습니다.',
              "time": _data['날짜'].toDate(),
            };
            if (_data['출석'] == true) {
              await flutterLocalNotificationsPlugin.show(0, '출결상태 변경',
                  notiContent['content'], platformChannelSpecifics,
                  payload: '[출결상태 변경] ${notiContent['content']}');
            } else {
              await flutterLocalNotificationsPlugin.show(0, '출결상태 변경',
                  notiContent['content'], platformChannelSpecifics,
                  payload: '[출결상태 변경] ${notiContent['content']}');
            }
            _col.doc(element.doc.id).update({
              'isNotified': true,
            });
            pushNotificationProvider.addNotification(notiContent);
          }
        });
        return snapshot;
      }),
      builder: (context, _) {
        return Scaffold(
          appBar: renderAppBar(),
          body: Stack(
            children: [
              Offstage(
                offstage: mainStageIndex != main,
                child: TickerMode(
                  enabled: mainStageIndex == main,
                  child: Main(
                    info: Column(
                      children: <Widget>[
                        Text(
                          "좋음",
                          style: TextStyle(
                            color: Colors.blue[800],
                            fontSize: _textSizeStatus,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "통합치수: 15",
                          style: TextStyle(
                              color: Colors.blue[800],
                              fontSize: _textSizeFigure,
                              fontWeight: FontWeight.bold,
                              height: 1.3),
                        ),
                        Text(
                          timeNow,
                          style: TextStyle(
                              color: Colors.blue[800],
                              fontSize: _textSizeTime,
                              height: 1.2),
                        )
                      ],
                    ),
                    height: _height,
                    visible: _visible,
                    onVerticalDragStart: (v) {
                      if (_resized) {
                        Future.delayed(Duration(milliseconds: 200), () {
                          setState(() {
                            _resized = false;
                            _visible = true;
                            _height = 500;
                            _textSizeStatus = 50.0;
                            _textSizeFigure = 18.0;
                            _textSizeTime = 10.0;
                          });
                        });
                      } else {
                        setState(() {
                          _resized = true;
                          _visible = false;
                          _height = 85;
                          _textSizeStatus = 30.0;
                          _textSizeFigure = 12.0;
                          _textSizeTime = 8.0;
                        });
                      }
                    },
                  ),
                ),
              ),
              Offstage(
                offstage: mainStageIndex != chat,
                child: TickerMode(
                  enabled: mainStageIndex == chat,
                  child: ChatRoom(
                    email: email,
                  ),
                ),
              ),
              Offstage(
                offstage: mainStageIndex != announce,
                child: TickerMode(
                  enabled: mainStageIndex == announce,
                  child: AnnouncementPage(),
                ),
              ),
              Offstage(
                offstage: mainStageIndex != agreement,
                child: TickerMode(
                  enabled: mainStageIndex == agreement,
                  child: AgreementManagement(),
                ),
              ),
              Offstage(
                offstage: mainStageIndex != program,
                child: TickerMode(
                  enabled: mainStageIndex == program,
                  child: Program(),
                ),
              ),
              Offstage(
                offstage: mainStageIndex != settings,
                child: TickerMode(
                  enabled: mainStageIndex == settings,
                  child: SettingsPage(),
                ),
              )
            ],
          ),
          bottomNavigationBar: BottomNavigatorBar(
            onTap: (idx) {
              switch (idx) {
                case 0:
                  setState(() {
                    mainStageIndex = main;
                  });
                  break;
                case 1:
                  setState(() {
                    mainStageIndex = chat;
                  });
                  break;
                case 2:
                  setState(() {
                    mainStageIndex = announce;
                  });
                  break;
                case 3:
                  setState(() {
                    mainStageIndex = agreement;
                  });
                  break;
                case 4:
                  setState(() {
                    mainStageIndex = program;
                  });
                  break;
                case 5:
                  setState(() {
                    mainStageIndex = settings;
                  });
                  break;
                default:
                  break;
              }
            },
          ),
        );
      },
    );
  }
}

class MainAppbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0.0,
      backgroundColor: Colors.white,
      title: Align(
        alignment: Alignment.topRight,
        child: IconButton(
          onPressed: () {
            Navigator.pushNamed(context, NotificationPage.id);
          },
          icon: Image.asset(
            'images/alarm_setting.png',
            height: 28.0,
          ),
        ),
      ),
    );
  }
}
