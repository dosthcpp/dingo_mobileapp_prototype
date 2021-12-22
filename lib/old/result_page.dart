import 'package:dingo_prototype/components/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:dingo_prototype/components/appbar.dart';
import 'package:dingo_prototype/old/main_page.dart';

class ResultPage extends StatelessWidget {
  ResultPage({
    @required this.title,
    @required this.result,
  });

  final String title;
  final String result;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBarDesign(
          isMainScreen: false,
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                color: Colors.black54,
                fontSize: 30.0,
              ),
            ),
            Text(
              '\n회원님의 아이디는 [$result] 입니다.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
            SizedBox(
              height: 24.0,
            ),
            RoundedButton(
                color: Colors.blueAccent,
                buttonTitle: '돌아가기',
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    MainPage.id,
                  );
                }),
          ],
        ),
      ),
    );
  }
}
