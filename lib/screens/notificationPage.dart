import 'package:dingo_prototype/main.dart';
import 'package:dingo_prototype/providers/pushNotificationProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationPage extends StatelessWidget {
  static const id = 'notification_page';

  @override
  Widget build(BuildContext context) {
    return Consumer<PushNotificationProvider>(builder: (ctx, push, __) {
      var notifications = push.getNotification();
      return Scaffold(
        body: ListView.builder(
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(notifications[index]),
            );
          },
          itemCount: notifications.length,
        ),
      );
    });
  }
}
