import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Program extends StatelessWidget {
  static const id = 'settings_page';

  _open(url) async {
    if(await canLaunch(url)) {
    await launch(url);
    } else {
    throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          MaterialButton(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            padding: EdgeInsets.zero,
            onPressed: () {
              _open('https://www.childschool.go.kr/index.do');
            },
            child: Image.asset(
              'images/program/e-kind.png',
            ),
          ),
          MaterialButton(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            padding: EdgeInsets.zero,
            onPressed: () {
              _open('https://e-childschoolinfo.moe.go.kr/');
            },
            child: Image.asset(
              'images/program/e-childschoolinfo.png',
            ),
          ),
          MaterialButton(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            padding: EdgeInsets.zero,
            onPressed: () {
              _open('https://idolbom.go.kr/front/main/main.do');
            },
            child: Image.asset(
              'images/program/idolbom.png',
            ),
          ),
          MaterialButton(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            padding: EdgeInsets.zero,
            onPressed: () async {
              _open('https://www.go-firstschool.go.kr/PAMS_SS/selectHm10mGridList.do');
            },
            child: Image.asset(
              'images/program/go-firstschool.png',
            ),
          ),
        ],
      ),
    );
  }
}