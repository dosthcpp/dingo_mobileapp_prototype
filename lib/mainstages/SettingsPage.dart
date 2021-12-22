import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  static const id = 'settings_page';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 5.0,
              vertical: 10.0,
            ),
            child: Card(
              elevation: 8.0,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 10.0,
                ),
                child: Column(
                  children: <Widget>[
                    _SettingsMenuItem(
                      imageName: 'announcement_setting',
                      title: '공지사항',
                      isAnnounceButton: true,
                    ),
                    _SettingsMenuItem(
                      imageName: 'version_setting',
                      title: '버전정보',
                      versionInfo: "1.0.0",
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 5.0,
              vertical: 10.0,
            ),
            child: Card(
              elevation: 8.0,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 10.0,
                ),
                child: Column(
                  children: <Widget>[
                    _SettingsMenuItem(
                      imageName: 'security_setting',
                      title: '개인/보안',
                    ),
                    _SettingsMenuItem(
                      imageName: 'alarm_setting',
                      title: '공지사항',
                    ),
                    _SettingsMenuItem(
                      imageName: 'chatting_setting',
                      title: '채팅 기록',
                    ),
                    _SettingsMenuItem(
                      imageName: 'screen_setting',
                      title: '화면',
                    ),
                    _SettingsMenuItem(
                      imageName: 'profile_setting',
                      title: '프로필',
                    ),
                    _SettingsMenuItem(
                      imageName: 'others_setting',
                      title: '기타',
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 5.0,
              vertical: 10.0,
            ),
            child: Card(
              elevation: 8.0,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 10.0,
                ),
                child: Column(
                  children: <Widget>[
                    _SettingsMenuItem(
                      imageName: 'contact_setting',
                      title: '문의하기/도움말',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsMenuItem extends StatelessWidget {
  _SettingsMenuItem({
    @required this.imageName,
    @required this.title,
    this.versionInfo,
    this.isAnnounceButton = false,
    this.onTap,
  });

  final String imageName;
  final String title;
  final String versionInfo;
  final bool isAnnounceButton;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 5.0,
      ),
      child: MaterialButton(
        color: Colors.black54,
        child: Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Image.asset(
                'images/$imageName.png',
                height: 30.0,
              ),
            ),
            Row(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    versionInfo != null ? Text(
                      versionInfo,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 10.0,
                      ),
                    ) : SizedBox(),
                  ],
                ),
                isAnnounceButton == true
                    ? Padding(
                  padding: EdgeInsets.only(
                    left: 5.0,
                  ),
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
                ) : SizedBox(),
              ],
            ),
          ],
        ),
        onPressed: onTap,
      ),
    );
  }
}
