import 'package:flutter/material.dart';
import 'package:dingo_prototype/components/appbar.dart';
import 'package:webview_flutter/webview_flutter.dart';


class GovBusiness extends StatelessWidget {
  static const id = 'gov_business';

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
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            MaterialButton(
              child: Image.asset(
                'images/e-kind.png',
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => _GeneralWebScreen(
                      url: "https://www.childschool.go.kr:40443/index.do",
                      item: "육아학비지원시스템",
                    ),
                  ),
                );
              },
            ),
            MaterialButton(
              child: Image.asset(
                'images/e-childschoolinfo.png',
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => _GeneralWebScreen(
                      url: "https://e-childschoolinfo.moe.go.kr/main.do",
                      item: "유치원알리미",
                    ),
                  ),
                );
              },
            ),
            MaterialButton(
              child: Image.asset(
                'images/idolbom.png',
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => _GeneralWebScreen(
                      url: "https://www.idolbom.go.kr/front/main/main.do",
                      item: "긴급돌봄서비스",
                    ),
                  ),
                );
              },
            ),
            MaterialButton(
              child: Image.asset(
                'images/go-firstschool.png',
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => _GeneralWebScreen(
                      url: "https://www.go-firstschool.go.kr/PAMS_SS/selectHm10mGridList.do",
                      item: "처음학교로",
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _GeneralWebScreen extends StatelessWidget {
  _GeneralWebScreen({@required this.url, @required this.item});

  final String url;
  final String item;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBarDesign(
          isMainScreen: false,
          title: item,
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: WebView(
        initialUrl: url,
        javascriptMode: JavascriptMode.unrestricted,
      ),
      // TODO: 처음학교로 API
    );
  }
}
