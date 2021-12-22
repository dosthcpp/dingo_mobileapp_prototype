import 'dart:ui';

import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';

final _store = FirebaseFirestore.instance;

class AnnouncementPage extends StatefulWidget {
  static const id = 'announcement_page';

  @override
  _AnnouncementPageState createState() => _AnnouncementPageState();
}

class _AnnouncementPageState extends State<AnnouncementPage> {
  int selected = 0;
  String menuTitle = "알림장";

  List<_AnnouncementCard> _announcementCardList = [
    _AnnouncementCard(
      date: "${DateTime.now().year}년 ${DateTime.now().month}월",
    ),
    _AnnouncementCard(
      date: "${DateTime.now().year}년 ${DateTime.now().month - 1}월",
    ),
  ];

  List<_FoodMenuCard> _foodMenuCardList = [
    _FoodMenuCard(
      kinderName: "희망유치원",
      morningSnackMenu: "호박죽, 블루베리 우유",
      lunchMenu: "볶음밥, 김치, 두부된장찌개",
      afternoonSnackMenu: "꿀떡, 오렌지 주스",
      date: DateTime(2021, 05, 30),
    ),
    _FoodMenuCard(
      kinderName: "희망유치원",
      morningSnackMenu: "두유, 감자스프",
      lunchMenu: "돈까스, 숙주나물, 미역국",
      afternoonSnackMenu: "떡볶이",
      date: DateTime(2021, 05, 29),
    ),
    _FoodMenuCard(
      kinderName: "희망유치원",
      morningSnackMenu: "딸기우유, 샌드위치",
      lunchMenu: "감자수제비국, 배추김치, 깍두기",
      afternoonSnackMenu: "짜먹는요구르트",
      date: DateTime(2021, 05, 28),
    ),
  ];

  List<Widget> _calendarCard = [
    _Calendar(),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 30.0,
      ),
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Container(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                      top: 30.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        buildLocalMenuPanel(0, "알림장", 'announce_card'),
                        buildLocalMenuPanel(1, "식단표", 'food_menu_card'),
                        buildLocalMenuPanel(2, "가정통신문", 'alert_card'),
                        buildLocalMenuPanel(3, "일정표", 'calendar_card'),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 20.0,
                    ),
                    child: Container(
                      width: MediaQuery.of(context).size.width - 30.0,
                      height: 50.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.grey[200],
                        ),
                      ),
                      child: Center(
                        child: Text(
                          menuTitle,
                          style: TextStyle(
                            color: Colors.blue[800],
                            fontSize: 28.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 8,
            child: Stack(
              children: [
                Offstage(
                  offstage: selected != 0,
                  child: TickerMode(
                    enabled: selected == 0,
                    child: Container(
                      width: MediaQuery.of(context).size.width - 30,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            10.0,
                          ),
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: _announcementCardList,
                        ),
                      ),
                    ),
                  ),
                ),
                Offstage(
                  offstage: selected != 1,
                  child: TickerMode(
                    enabled: selected == 1,
                    child: Container(
                      width: MediaQuery.of(context).size.width - 30,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            10.0,
                          ),
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: _foodMenuCardList,
                        ),
                      ),
                    ),
                  ),
                ),
                Offstage(
                  offstage: selected != 2,
                  child: TickerMode(
                    enabled: selected == 2,
                    child: Container(
                      width: MediaQuery.of(context).size.width - 30,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            10.0,
                          ),
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: StreamBuilder<DocumentSnapshot>(
                          stream: _store
                              .collection('user')
                              .doc('black_s@naver.com')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            List cardList = [];
                            if((snapshot.data.data() as Map).containsKey('가정통신문')) {
                              for (var i = 0;
                              i <
                                  (snapshot.data.data() as Map)['가정통신문']
                                      .length;
                              ++i) {
                                Map<String, dynamic> map =
                                (snapshot.data.data() as Map)['가정통신문'][i];
                                map['type'] = '가정통신문';
                                cardList.add(map);
                              }
                            }
                            if((snapshot.data.data() as Map).containsKey('알림장')) {
                              for (var i = 0;
                              i < (snapshot.data.data() as Map)['알림장'].length;
                              ++i) {
                                Map<String, dynamic> map =
                                (snapshot.data.data() as Map)['알림장'][i];
                                map['type'] = '알림장';
                                cardList.add(map);
                              }
                            }
                            cardList.sort((a, b) {
                              var aTime = a['createdAt'].toDate();
                              var bTime = b['createdAt'].toDate();
                              return -aTime.compareTo(bTime);
                            });

                            List<Widget> _alertCardList = [];
                            for (var i = 0; i < cardList.length; ++i) {
                              _alertCardList.add(_AlertCard(
                                alertType: cardList[i]['type'],
                                className: "희망유치원 희망반",
                                date: cardList[i]['createdAt'].toDate(),
                                title: cardList[i]['title'],
                                content: cardList[i]['contents'],
                              ));
                            }
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: _alertCardList,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                Offstage(
                  offstage: selected != 3,
                  child: TickerMode(
                    enabled: selected == 3,
                    child: Container(
                      width: MediaQuery.of(context).size.width - 30,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            10.0,
                          ),
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: _calendarCard,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  GestureDetector buildLocalMenuPanel(
      int menuNumber, String title, String imageName) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          border: selected == menuNumber
              ? Border.all(
                  color: Colors.blue,
                  width: 2.0,
                )
              : null,
          borderRadius: BorderRadius.all(
            Radius.circular(
              5.0,
            ),
          ),
        ),
        width: 70.0,
        height: 50.0,
        child: Image.asset(
          'images/announcementMenu/$imageName.png',
        ),
      ),
      onTap: () {
        setState(() {
          selected = menuNumber;
          menuTitle = title;
        });
      },
    );
  }
}

class _FoodMenuCard extends StatelessWidget {
  _FoodMenuCard(
      {@required this.kinderName,
      @required this.morningSnackMenu,
      @required this.lunchMenu,
      @required this.afternoonSnackMenu,
      @required this.date});

  final String kinderName;
  final String morningSnackMenu;
  final String lunchMenu;
  final String afternoonSnackMenu;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 10.0,
      ),
      child: Container(
        height: 220.0,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(
              4.0,
            ),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 15.0,
            horizontal: 8.0,
          ),
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 6.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      kinderName,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: 5.0,
                      ),
                      child: Row(
                        children: <Widget>[
                          Visibility(
                            visible: date.toString().split(" ")[0] ==
                                DateTime.now().toString().split(" ")[0],
                            child: Material(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  color: Colors.red,
                                ),
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(1.5),
                                child: Text(
                                  "NEW",
                                  style: TextStyle(
                                    fontSize: 5.5,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 2.0,
                          ),
                          Text(
                            "${date.toString().split(" ")[0].split("-").join(".")}",
                            style: TextStyle(
                                fontSize: 9.0,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.4),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  buildMenuPanel(context, "오전간식"),
                  buildMenuPanel(context, "점심"),
                  buildMenuPanel(context, "오후간식"),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 6.0,
                  right: 6.0,
                  top: 10.0,
                ),
                child: Container(
                  height: 45.0,
                  width: MediaQuery.of(context).size.width - 30,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        5.0,
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 4.0,
                      horizontal: 6.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text(
                          "오전간식: $morningSnackMenu",
                          style: TextStyle(
                            fontSize: 8.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "점심: $lunchMenu",
                          style: TextStyle(
                            fontSize: 8.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "오후간식: $afternoonSnackMenu",
                          style: TextStyle(
                            fontSize: 8.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Padding buildMenuPanel(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        width: (MediaQuery.of(context).size.width - 90) / 3,
        height: 100.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(
              4.0,
            ),
          ),
          border: Border.all(
            width: 3.0,
            color: Colors.grey[200],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 2.0,
            horizontal: 2.0,
          ),
          child: Column(
            children: <Widget>[
              Container(
                height: 70.0,
                color: Colors.grey[200],
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 4.0,
                ),
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12.0,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _AlertCard extends StatelessWidget {
  _AlertCard({
    @required this.alertType,
    @required this.className,
    @required this.date,
    this.title,
    @required this.content,
  });

  final String alertType;
  final String className;
  final DateTime date;
  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    bool isToday = date.toString().split(" ")[0] ==
        DateTime.now().toString().split(" ")[0];
    bool isYesterday = date.toString().split(" ")[0] ==
        DateTime(DateTime.now().year, DateTime.now().month,
                DateTime.now().day - 1)
            .toString()
            .split(" ")[0];
    int timeDiff = DateTime.now().difference(date).inDays;
    return Padding(
      padding: EdgeInsets.only(
        top: 13.0,
        right: 5.0,
        left: 5.0,
      ),
      child: Card(
        elevation: 8.0,
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 20.0,
            horizontal: 15.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          alertType,
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          className,
                          style: TextStyle(
                            fontSize: 10.0,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Visibility(
                        visible: isToday || isYesterday,
                        child: Material(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: Colors.red,
                            ),
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(1.5),
                            child: Text(
                              "NEW",
                              style: TextStyle(
                                fontSize: 7.5,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Text(
                        isToday
                            ? "오늘"
                            : (isYesterday
                                ? "어제"
                                : ((timeDiff >= 2 && timeDiff <= 7)
                                    ? "$timeDiff일 전"
                                    : date
                                        .toString()
                                        .split(" ")[0]
                                        .split("-")
                                        .join("."))),
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          fontSize: 10.0,
                          fontWeight:
                              isToday || isYesterday ? FontWeight.bold : null,
                        ),
                      ),
                    ],
                  )),
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              alertType == "가정통신문"
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Html(
                          data: content,
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        GestureDetector(
                            child: Text(
                              "더보기 >",
                              style: TextStyle(
                                fontSize: 11.0,
                                color: Colors.blueAccent,
                              ),
                            ),
                            onTap: () {
                              // TODO: load more..
                            }),
                        SizedBox(
                          height: 20.0,
                        ),
                      ],
                    )
                  : Column(
                      children: <Widget>[
                        Html(
                          data: content,
                        ),
                      ],
                    )
            ],
          ),
        ),
      ),
    );
  }
}

class _AnnouncementCard extends StatelessWidget {
  _AnnouncementCard({@required this.date});

  final String date;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 15.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              width: 90.0,
              height: 15.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    4.0,
                  ),
                ),
              ),
              child: Center(
                child: Text(
                  date,
                  style: TextStyle(
                    letterSpacing: -0.3,
                    fontSize: 10.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )),
          buildAnnouncementPanel(context),
          buildAnnouncementPanel(context),
          buildAnnouncementPanel(context),
        ],
      ),
    );
  }

  Padding buildAnnouncementPanel(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 6.0,
      ),
      child: Container(
        width: MediaQuery.of(context).size.width - 30,
        height: 80.0,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(
              4.0,
            ),
          ),
        ),
      ),
    );
  }
}

class _Calendar extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<_Calendar> {
  static const String noEventText = '이 날은 일정이 없습니다.';
  static String calendarText = noEventText;
  bool isCalendarEmpty = false;
  String day;

  EventList<Event> _markedDateMap = EventList<Event>(
    events: {
      DateTime(2021, 3, 20): [
        Event(
          date: DateTime(2021, 3, 20),
          title: '봄 소풍',
          icon: _eventIcon,
        ),
      ],
    },
  );

  static Widget _eventIcon = Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(
        Radius.circular(1000),
      ),
      border: Border.all(color: Colors.blue, width: 2.0),
    ),
    child: Icon(
      Icons.person,
      color: Colors.amber,
    ),
  );

  Map<int, String> dayPlan = {};

  @override
  void initState() {
//    DateTime today = DateTime(DateTime.now().year, DateTime.now().month + 1, 0);
//    print(today.day);
    calendarText = '날짜를 선택해 주세요.';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 600.0,
      child: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 20.0,
                    ),
                    child: Container(
                      height: 400.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      margin: EdgeInsets.symmetric(
                        horizontal: 8.0,
                      ),
                      child: CalendarCarousel(
                        thisMonthDayBorderColor: Colors.transparent,
                        todayButtonColor: Colors.transparent,
//        todayBorderColor: Colors.transparent,
                        dayCrossAxisAlignment: CrossAxisAlignment.start,
                        todayTextStyle: TextStyle(
                          color: Colors.black,
                        ),
                        height: 420.0,
                        daysHaveCircularBorder: false,
                        weekendTextStyle: TextStyle(
                          color: Colors.red,
                        ),
                        headerTextStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                        iconColor: Colors.black,
                        markedDatesMap: _markedDateMap,
                        locale: 'KOR',
                        markedDateWidget: Text(
                          // TODO: need to be fixed
                          "봄 소풍",
                          style: TextStyle(
                            fontSize: 10.0,
                            color: Colors.green,
                          ),
                        ),
                        onDayPressed: (date, events) {
                          this.setState(
                            () => refresh(date),
                          );
                        },
                        // onCalendarChanged: ,
//          weekDays: null, /// for pass null when you do not want to render weekDays
//          headerText: Container( /// Example for rendering custom header
//            child: Text('Custom Header'),
//          ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                      color: Colors.white,
                    ),
                    margin: EdgeInsets.symmetric(
                      horizontal: 8.0,
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 20.0,
                        horizontal: 20.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "이날의 일정",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                          ),
                          Divider(),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 5.0,
                            ),
                            child: Row(
                              children: <Widget>[
                                day != null
                                    ? Row(
                                        children: <Widget>[
                                          Text(
                                            "$day일 - ",
                                            style: TextStyle(
                                              fontSize: 15.0,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Text(
                                            calendarText,
                                            style: TextStyle(
                                              fontSize: 15.0,
                                              color: Colors.green,
                                            ),
                                          ),
                                        ],
                                      )
                                    : Text(
                                        calendarText,
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          color: Colors.black,
                                        ),
                                      ),
                              ],
                            ),
                          ),
                          isCalendarEmpty
                              ? Text(
                                  '* 코로나로 인하여 일정이 변경 및 취소될 수 있습니다.',
                                  style: TextStyle(
                                    fontSize: 10.0,
                                    color: Colors.red,
                                  ),
                                )
                              : SizedBox(),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void refresh(date) {
    isCalendarEmpty = _markedDateMap
        .getEvents(DateTime(date.year, date.month, date.day))
        .isNotEmpty;
    if (isCalendarEmpty) {
      calendarText = _markedDateMap
          .getEvents(DateTime(date.year, date.month, date.day))[0]
          .title;
      day = _markedDateMap
          .getEvents(DateTime(date.year, date.month, date.day))[0]
          .date
          .toString()
          .split(" ")[0]
          .split("-")[2];
    } else {
      calendarText = noEventText;
      day = null;
    }
  }
}
