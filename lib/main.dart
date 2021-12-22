import 'package:dingo_prototype/animation/animated_starting_page.dart';
import 'package:dingo_prototype/MainPage.dart';
import 'package:dingo_prototype/mainstages//Announcement.dart';
import 'package:dingo_prototype/mainstages/SettingsPage.dart';
import 'package:dingo_prototype/screens/AgreementDetail.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: AnimatedStartingPage.id,
      routes: {
        AnimatedStartingPage.id: (context) => AnimatedStartingPage(),
        MainPage.id : (context) => MainPage(),
        AnnouncementPage.id : (context) => AnnouncementPage(),
        AgreementDetail.id: (context) => AgreementDetail(),
        SettingsPage.id : (context) => SettingsPage(),

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