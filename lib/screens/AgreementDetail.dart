import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';

final _store = FirebaseFirestore.instance;

class AgreementDetailArgs {
  final String title, content;
  final bool isAgreed;
  final Function onTap;

  AgreementDetailArgs(
      {this.title, this.content, this.isAgreed = false, this.onTap});
}

class AgreementDetail extends StatelessWidget {
  static const id = 'agreement_management';

  @override
  Widget build(BuildContext context) {
    AgreementDetailArgs args =
        ModalRoute.of(context).settings.arguments as AgreementDetailArgs;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: args.isAgreed ? Colors.black54 : Colors.blue,
        title: Text(
          args.title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: StreamBuilder<DocumentSnapshot>(
          stream:
              _store.collection('user').doc('black_s@naver.com').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final _data = snapshot.data.data() as Map;
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.15,
                ),
                Text(
                    "반 이름: ${_data['반 이름']}   영유아명: ${_data['원아 이름']}   원아 성별: ${_data['원아 성별']}",
                    style: TextStyle(
                      fontSize: 15.0,
                    )),
                Html(
                  data: args.content,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.1,
                ),
                GestureDetector(
                  child: Text(
                    "개인정보 활용 및 보관에 동의합니다.",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 18.0,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  onTap: () {},
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.1,
                ),
                Text(
                  "${DateTime.now().year}년 ${DateTime.now().month}월 ${DateTime.now().day}일",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 15.0,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.05,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    right: 10.0,
                  ),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "보호자: 영유아와의 관계: 아버지\n(성명: ${_data['부모님 성함']} / h.p: ${_data['휴대전화']})",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.1,
                ),
                MaterialButton(
                  child: Container(
                    decoration: BoxDecoration(
                      color: args.isAgreed ? Colors.black54 : Colors.blue,
                      borderRadius: BorderRadius.circular(
                        5.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 1.0), //(x,y)
                          blurRadius: 3.0,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 8.0,
                      ),
                      child: Text(
                        "생체인증으로 동의합니다.",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ),
                  onPressed: args.onTap,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
