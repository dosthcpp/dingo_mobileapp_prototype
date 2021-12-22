import 'package:dingo_prototype/old/result_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:dingo_prototype/components/general_text_field.dart';
import 'package:dingo_prototype/components/rounded_button.dart';
import 'package:dingo_prototype/components/appbar.dart';
import 'package:dingo_prototype/components/general_dialog.dart';

import 'package:dingo_prototype/old/main_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _fireStore = FirebaseFirestore.instance;

class FindIdAndPasswd extends StatefulWidget {
  static const id = 'find_id_and_passwd';

  @override
  _FindIdAndPasswdState createState() => _FindIdAndPasswdState();
}

class _FindIdAndPasswdState extends State<FindIdAndPasswd> {
  final _auth = FirebaseAuth.instance;
  String email;
  String name;
  String phoneNumber;

  // TODO: change menu following the menu title.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBarDesign(
          isMainScreen: false,
          onTap: () {
            setState(() {
              email = null;
              name = null;
              phoneNumber = null;
            });
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 25.0,
          vertical: 20.0,
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    "[이메일 찾기]",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                      fontSize: 20.0,
                    ),
                  ),
                  GeneralTextField(
                    title: "이름",
                    type: TextInputType.emailAddress,
                    func: (value) {
                      name = value;
                    },
                  ),
                  GeneralTextField(
                    title: "휴대폰번호",
                    type: TextInputType.number,
                    func: (value) {
                      phoneNumber = value;
                    },
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: _fireStore
                        .collection('user')
                        .where('원아 이름', isEqualTo: name)
                        .where('휴대전화', isEqualTo: phoneNumber)
                        .snapshots(),
                    builder: (context, snapshot) {
                      return RoundedButton(
                        color: Colors.blue,
                        buttonTitle: '찾기',
                        onPressed: () {
                          try {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ResultPage(
                                  title: "이메일 찾기 결과",
                                  result: snapshot.data.docs[0].id,
                                ),
                              ),
                            );
                          } catch (e) {
                            print(e);
                          }
                        },
                      );
                    },
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        "[비밀번호 리셋]",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                          fontSize: 20.0,
                        ),
                      ),
                      GeneralTextField(
                        title: "이메일",
                        type: TextInputType.emailAddress,
                        func: (value) {
                          email = value;
                        },
                      ),
                      SizedBox(
                        height: 24.0,
                      ),
                      RoundedButton(
                        color: Colors.blue,
                        buttonTitle: '찾기',
                        onPressed: () async {
                          await _auth.sendPasswordResetEmail(
                            email: email,
                          );
                          _displayDialogPasswordResetEmailHasAlreadyBeenSent();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _displayDialogPasswordResetEmailHasAlreadyBeenSent() {
    showDialog(
      context: context,
      builder: (context) {
        return GeneralDialog(
          title: '패스워드 초기화 이메일을 보냈습니다!',
          onTap: () {
            Navigator.pushNamed(
              context,
              MainPage.id,
            );
          },
        );
      },
    );
  }
}
