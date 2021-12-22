import 'package:flutter/services.dart';
import 'package:dingo_prototype/old/custom_login_popup.dart';

import 'package:dingo_prototype/components/appbar.dart';
import 'package:dingo_prototype/components/child_card.dart';
import 'package:dingo_prototype/components/menu_panel.dart';
import 'package:dingo_prototype/components/advertisement_frame.dart';
import 'package:dingo_prototype/animation/fade_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class MainPage extends StatelessWidget {
  static const id = 'fade_in_ui';

  @override
  Widget build(BuildContext context) {
    List childList = <Widget>[
      ChildCard(
        childName: "미등록",
        age: 0,
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBarDesign(
          isMainScreen: true,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 30.0,
            horizontal: 15.0,
          ),
          child: Column(
            children: <Widget>[
              FadeIn(
                1,
                GestureDetector(
                  child: Row(
                    children: <Widget>[
                      Material(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.asset(
                          'images/icon.png',
                        ),
                      ),
                      SizedBox(
                        width: 8.0,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "이곳을 눌러 로그인을 해주세요.",
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "이메일 등록이 아직 되지 않았습니다.",
                            style: TextStyle(
                              fontSize: 10.0,
                              color: Colors.black45,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => CustomLoginPopUp(),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              FadeIn(
                2,
                Container(
                  width: 500.0,
                  height: 40.0,
                  child: Material(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8.0),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.0,
                      ),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: childList,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              FadeIn(
                3,
                MenuPanel(
                  isLoggedin: false,
                ),
              ),
              FadeIn(
                4,
                Advertisement(),
              ),
              FadeIn(
                5,
                Advertisement(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
