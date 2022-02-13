import 'package:flutter/material.dart';

class PushNotificationProvider extends ChangeNotifier {
  List<Map<String, dynamic>> notifications = [];

  addNotification(Map<String, dynamic> noti) {
    notifications.add(noti);
    notifyListeners();
  }

  List<Map<String, dynamic>> getNotification() {
    return notifications;
  }
}