import 'package:dingo_prototype/providers/pushNotificationProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationPage extends StatelessWidget {
  static const id = 'notification_page';

  getTime(DateTime _d) {
    DateTime n = DateTime.now();
    if(n.difference(_d).inHours == 0 && (n.difference(_d).inMinutes >= 0 && n.difference(_d).inMinutes < 60)) {
      return "${n.difference(_d).inMinutes}분 전";
    } else if (n.difference(_d).inHours == 1) {
      return "1시간 전";
    } else if (n.difference(_d).inHours == 2) {
      return "2시간 전";
    } else {
      return "${_d.year}-${_d.month >= 10 ? _d.month : '0${_d.month}'}-${_d.day >= 10 ? _d.day : '0${_d.day}'} ${_d.hour >= 10 ? _d.hour : '0${_d.hour}'}:${_d.minute >= 10 ? _d.minute : '0${_d.minute}'}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PushNotificationProvider>(builder: (ctx, push, __) {
      var notifications = push.getNotification();
      return Scaffold(
        body: ListView.builder(
          itemBuilder: (context, index) {
            String s = notifications[index]['content'];
            DateTime t = notifications[index]['time'];
            String _f = "원아";
            int idx = s.indexOf(_f);
            List parts = [
              s.substring(0, idx + _f.length).trim(),
              s.substring(idx + _f.length).trim()
            ];
            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 15.0,
              ),
              child: ListTile(
                contentPadding: EdgeInsets.all(16.0),
                leading: Image.asset('images/icon.png'),
                minLeadingWidth: 60.0,
                title: SizedBox(
                  height: 100.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: parts[0],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                ),
                              ),
                              TextSpan(
                                text: parts[1],
                                style: TextStyle(
                                  fontSize: 20.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        getTime(t),
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
          itemCount: notifications.length,
        ),
      );
    });
  }
}
