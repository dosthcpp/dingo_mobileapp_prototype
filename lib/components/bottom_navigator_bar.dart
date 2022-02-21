import 'package:dingo_prototype/mainstages/Announcement.dart';
import 'package:flutter/material.dart';
import 'package:dingo_prototype/mainstages/SettingsPage.dart';

class BottomNavigatorBar extends StatelessWidget {

  final void Function(int)? onTap;

  BottomNavigatorBar({this.onTap});
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      onTap: onTap!,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          label: "home",
          icon: Image.asset(
            'images/home.png',
            height: 35.0,
          ),
        ),
        BottomNavigationBarItem(
          label: "message",
          icon: Image.asset(
            'images/message.png',
            height: 35.0,
          ),
        ),
        BottomNavigationBarItem(
          label: "calendar",
          icon: Image.asset(
            'images/daily.png',
            height: 35.0,
          ),
        ),
        BottomNavigationBarItem(
          label: "calendar",
          icon: Image.asset(
            'images/agreement.png',
            height: 35.0,
          ),
        ),
        BottomNavigationBarItem(
          label: "program",
          icon: Image.asset(
            'images/business.png',
            height: 35.0,
          ),
        ),
        BottomNavigationBarItem(
          label: "menu",
          icon: Image.asset(
            'images/others.png',
            height: 35.0,
          ),
        ),
      ],
    );
  }
}
