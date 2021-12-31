import 'package:dingo_prototype/mainstages/Announcement.dart';
import 'package:dingo_prototype/mainstages/SettingsPage.dart';
import 'package:flutter/material.dart';
import 'package:dingo_prototype/components/general_dialog.dart';

class MenuPanel extends StatelessWidget {
  MenuPanel({
    required this.isLoggedin,
  });

  bool isLoggedin;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 10.0,
            vertical: 20.0,
          ),
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 10.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    _CustomIconButton(
                      imageName: 'images/alarm.png',
                      title: '알림장',
                      id: AnnouncementPage.id,
                      isLoggedin: isLoggedin,
                    ),
                    _CustomIconButton(
                      imageName: 'images/daily_colored.png',
                      title: '유치원 일정',
                      id: AnnouncementPage.id,
                      isLoggedin: isLoggedin,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 10.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    // _CustomIconButton(
                    //   imageName: 'images/gov_business.png',
                    //   title: '정부지원사업',
                    //   id: GovBusiness.id,
                    //   isLoggedin: isLoggedin,
                    // ),
                    _CustomIconButton(
                      imageName: 'images/settings.png',
                      title: '설정',
                      id: SettingsPage.id,
                      isLoggedin: isLoggedin,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CustomIconButton extends StatelessWidget {
  _CustomIconButton({
    this.imageName,
    this.title,
    this.id,
    this.isLoggedin = false,
  });

  final bool isLoggedin;
  final String? imageName;
  final String? title;
  final String? id;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          width: 60.0,
          height: 60.0,
          child: IconButton(
            icon: Image.asset(
              imageName!,
            ),
            onPressed: () {
              isLoggedin
                  ? Navigator.pushNamed(context, id!)
                  : showDialog(
                      context: context,
                      builder: (context) => GeneralDialog(
                        title: "로그인을 해주세요",
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    );
            },
          ),
        ),
        Text(
          title!,
          style: TextStyle(
            fontSize: 12.0,
          ),
        ),
      ],
    );
  }
}
