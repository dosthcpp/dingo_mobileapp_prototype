import 'package:dingo_prototype/animation/animated_starting_page.dart';
import 'package:dingo_prototype/MainPage.dart';
import 'package:dingo_prototype/mainstages//Announcement.dart';
import 'package:dingo_prototype/mainstages/SettingsPage.dart';
import 'package:dingo_prototype/providers/pushNotificationProvider.dart';
import 'package:dingo_prototype/screens/AgreementDetail.dart';
import 'package:dingo_prototype/screens/notificationPage.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

PushNotificationProvider pushNotificationProvider = PushNotificationProvider();

class ReceivedNotification {

  final int id;
  final String title;
  final String body;
  final String payload;

  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final IOSInitializationSettings initializationSettingsIOS =
      IOSInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
          onDidReceiveLocalNotification: (
            int? id,
            String? title,
            String? body,
            String? payload,
          ) async {
            didReceiveLocalNotificationSubject.add(
              ReceivedNotification(
                id: id!,
                title: title!,
                body: body!,
                payload: payload!,
              ),
            );
          });
  final InitializationSettings initializationSettings = InitializationSettings(
    iOS: initializationSettingsIOS,
  );
  final bool? result = await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String? payload) async {
    if (payload != null) {
      print(payload);
    }
  });
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => pushNotificationProvider),
    ], child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: AnimatedStartingPage.id,
      routes: {
        AnimatedStartingPage.id: (context) => AnimatedStartingPage(),
        MainPage.id: (context) => MainPage(),
        AnnouncementPage.id: (context) => AnnouncementPage(),
        AgreementDetail.id: (context) => AgreementDetail(),
        SettingsPage.id: (context) => SettingsPage(),
        NotificationPage.id: (context) => NotificationPage(),

        // old
        // MyPage.id : (context) => MyPage(),
        // MyPageAlternative.id: (context) => MyPageAlternative(),
        // MainPage.id : (context) => MainPage(),
        // RegistrationPage.id : (context) => RegistrationPage(),
        // FindIdAndPasswd.id : (context) => FindIdAndPasswd(),
        // GovBusiness.id : (context) => GovBusiness(),
      },
    );
  }
}
