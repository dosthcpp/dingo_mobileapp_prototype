import 'package:flutter/material.dart';

class PushNotificationProvider extends ChangeNotifier {
  List<String> notifications = [];

  addNotification(String noti) {
    notifications.add(noti);
    notifyListeners();
  }

  List<String> getNotification() {
    return notifications;
  }
}