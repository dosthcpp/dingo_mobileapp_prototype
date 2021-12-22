import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dingo_prototype/screens/AgreementDetail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;

final _store = FirebaseFirestore.instance;

class AgreementManagement extends StatefulWidget {
  @override
  _AgreementManagementState createState() => _AgreementManagementState();
}

class _AgreementManagementState extends State<AgreementManagement> {
  final DateTime date = DateTime.now();

  String dateForm(DateTime date) {
    const weeks = [
      '월',
      '화',
      '수',
      '목',
      '금',
      '토',
      '일',
    ];

    return "${date.toString().split(" ")[0].split("-").join(".")} (${weeks[date.weekday - 1]})";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 15.0,
            ),
            child: Material(
              elevation: 1.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    10.0,
                  ),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 10.0,
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 10.0,
                        ),
                        child: StreamBuilder<DocumentSnapshot>(
                          stream: _store
                              .collection('user')
                              .doc('black_s@naver.com')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            final agreementList =
                                List.from((snapshot.data.data() as Map)['동의서']);
                            agreementList.sort((a, b) {
                              final aDate = a['createdAt'].toDate();
                              final bDate = b['createdAt'].toDate();
                              return aDate.compareTo(bDate);
                            });
                            return GridView.builder(
                              shrinkWrap: true,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                childAspectRatio: 1.5,
                                crossAxisCount: 2,
                                crossAxisSpacing: 10.0,
                                mainAxisSpacing: 10.0,
                              ),
                              itemBuilder: (context, index) {
                                return _AgreementButton(
                                  mainTitle: agreementList[index]['title'],
                                  subTitle: agreementList[index]['contents'],
                                  content: agreementList[index]['subcontents'],
                                  date: dateForm(agreementList[index]
                                          ['createdAt']
                                      .toDate()),
                                  isAgreed: agreementList[index]['isAgreed'],
                                  onAuthenticateComplete: () async {
                                    agreementList[index]['isAgreed'] = true;
                                    _store
                                        .collection('user')
                                        .doc('black_s@naver.com')
                                        .update({'동의서': agreementList});
                                  },
                                );
                              },
                              itemCount: agreementList.length,
                            );
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class _AgreementButton extends StatelessWidget {
  _AgreementButton({
    @required this.mainTitle,
    @required this.subTitle,
    @required this.content,
    @required this.date,
    @required this.isAgreed,
    @required this.onAuthenticateComplete,
    this.onTap,
  });

  final bool isAgreed;
  final Function onAuthenticateComplete;
  final String mainTitle;
  final String subTitle;
  final String content;
  final String date;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: (MediaQuery.of(context).size.width - 70) / 2,
        height: 108.0,
        decoration: BoxDecoration(
          border: Border.all(
            width: 1.0,
            color: isAgreed ? Colors.grey[500] : Colors.blueAccent,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(
              4.0,
            ),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 10.0,
            horizontal: 5.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                mainTitle,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: mainTitle.length < 11 ? 15.0 : 14.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Visibility(
                visible: mainTitle.length > 11,
                child: SizedBox(
                  height: 1.0,
                ),
              ),
              Text(
                subTitle,
                style: TextStyle(
                  fontSize: 9.5,
                ),
              ),
              Text(
                date,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 6.0,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                      top: 20.0,
                    ),
                    child: SizedBox(
                      width: 25.0,
                      height: 25.0,
                      child: CircleAvatar(
                        backgroundColor:
                            isAgreed ? Colors.grey[500] : Colors.blueAccent,
                        child: Image.asset(
                          'images/agreement.png',
                          scale: 2.5,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    "더보기>",
                    style: TextStyle(
                      fontSize: 6.0,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        Navigator.pushNamed(context, AgreementDetail.id,
            arguments: AgreementDetailArgs(
              title: mainTitle,
              content: content,
              isAgreed: isAgreed,
              onTap: () async {
                if (isAgreed) {
                  showDialog(
                    context: context,
                    builder: (_) => Platform.isAndroid
                        ? AlertDialog(
                            title: Text('Alert!'),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: [
                                  Text('이미 동의하셨습니다.'),
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(
                                child: Text('확인'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          )
                        : CupertinoAlertDialog(
                            title: Text('Alert!'),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: [
                                  Text('이미 동의하셨습니다.'),
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(
                                child: Text('확인'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                  );
                } else {
                  final localAuth = LocalAuthentication();
                  try {
                    bool didAuthenticate = await  localAuth.authenticate(
                      localizedReason: '생체인증을 이용하여 동의하세요.',
                      biometricOnly: true,
                    );
                    if (didAuthenticate) {
                      onAuthenticateComplete();
                      Navigator.pop(context);
                    }
                  } on PlatformException catch (e) {
                    if (e.code == auth_error.notAvailable) {
                      print('asdf');
                    }
                  }
                }
              },
            ));
      },
    );
  }
}
