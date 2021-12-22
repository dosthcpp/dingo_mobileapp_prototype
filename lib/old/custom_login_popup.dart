import 'package:dingo_prototype/old/find_id_and_passwd.dart';
import 'package:dingo_prototype/old/my_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dingo_prototype/old/registration_page.dart';
import 'package:dingo_prototype/components/rounded_button.dart';
import 'package:dingo_prototype/components/general_dialog.dart';
import 'dart:ui';

class CustomLoginPopUp extends StatelessWidget {
  String email;
  String password;
  final FocusNode _focusNodeForEmail = FocusNode();
  final FocusNode _focusNodeForPasswd = FocusNode();
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: 3,
        sigmaY: 3,
      ),
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.only(
            top: _focusNodeForEmail.hasFocus || _focusNodeForPasswd.hasFocus
                ? MediaQuery.of(context).size.height / 2 -
                    325 // adjust values according to your need
                : MediaQuery.of(context).size.height / 2 - 210),
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          backgroundColor: Colors.white,
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                    bottom: 40.0,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFCD8DE8),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                      ),
                    ),
                    width: MediaQuery.of(context).size.width,
                    height: 60.0,
                    child: Image.asset(
                      'images/logo.png',
                      color: Colors.white,
                      scale: 1.2,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    right: 24.0,
                    left: 24.0,
                    bottom: 20.0,
                  ),
                  child: Column(
                    children: <Widget>[
                      TextField(
                        focusNode: _focusNodeForEmail,
                        keyboardType: TextInputType.emailAddress,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          hintText: '이메일을 입력하세요',
                        ),
                        onChanged: (value) {
                          email = value;
                        },
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      TextField(
                        focusNode: _focusNodeForPasswd,
                        obscureText: true,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          hintText: '비밀번호를 입력하세요',
                        ),
                        onChanged: (value) {
                          password = value;
                        },
                      ),
                      SizedBox(
                        height: 40.0,
                      ),
                      RoundedButton(
                        color: Colors.blue,
                        buttonTitle: '로그인',
                        onPressed: () async {
                          if (email == null || password == null) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return GeneralDialog(
                                    title: "아이디 또는 비밀번호를 확인해주세요.",
                                    onTap: () {
                                      Navigator.pop(context);
                                    });
                              },
                            );
                          }
                          try {
                            final signedInUser =
                                (await _auth.signInWithEmailAndPassword(
                              email: email,
                              password: password,
                            ))
                                    .user;
                            if (signedInUser.emailVerified) {
                              email = null;
                              password = null;
                              Navigator.pushNamed(
                                context,
                                MyPage.id,
                              );
                            }
                          } catch (e) {
                            print(e);
                          }
                        },
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          GestureDetector(
                            child: Text(
                              '가입하기',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 12.0,
                              ),
                            ),
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                RegistrationPage.id,
                              );
                            },
                          ),
                          GestureDetector(
                            child: Text(
                              '아이디 / 비밀번호 찾기',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 12.0,
                              ),
                            ),
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                FindIdAndPasswd.id,
                              );
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
