import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:dingo_prototype/components/general_dialog.dart';
import 'package:dingo_prototype/components/general_text_field.dart';
import 'package:dingo_prototype/components/rounded_button.dart';
import 'package:dingo_prototype/data/user_database.dart';
import 'package:dingo_prototype/components/appbar.dart';

import 'package:dingo_prototype/old/main_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _fireStore = FirebaseFirestore.instance;

class RegistrationPage extends StatefulWidget {
  static const id = 'registration_page';

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
//
//  String emailValidator(String value) {
//    Pattern pattern =
//        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
//    RegExp regex = new RegExp(pattern);
//    if (!regex.hasMatch(value)) {
//      return 'Email format is invalid';
//    } else {
//      return null;
//    }
//  }
//
//  String pwdValidator(String value) {
//    if (value.length < 8) {
//      return 'Password must be longer than 8 characters';
//    } else {
//      return null;
//    }
//  }
  final _auth = FirebaseAuth.instance;
  Map<String, String> userDatabase = {};
  String passwd;
  String passwdForchk;

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
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 25.0,
            vertical: 20.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                "[회원가입]",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                  fontSize: 20.0,
                ),
              ),
              GeneralTextField(
                title: "이메일 *",
                type: TextInputType.emailAddress,
                func: (value) {
                  userDatabase[userDataItem[0]] = value;
                },
              ),
              GeneralTextField(
                title: "비밀번호 *",
                type: TextInputType.number,
                obscureText: true,
                func: (value) {
                  passwd = value;
                },
              ),
              GeneralTextField(
                title: "비밀번호\n재입력 *",
                type: TextInputType.number,
                obscureText: true,
                func: (value) {
                  passwdForchk = value;
                },
              ),
              GeneralTextField(
                title: "닉네임 *",
                func: (value) {
                  userDatabase[userDataItem[1]] = value;
                },
              ),
              GeneralTextField(
                title: "원아 이름 *",
                func: (value) {
                  userDatabase[userDataItem[2]] = value;
                },
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      "원아의 성별 *",
                      style: TextStyle(
                        fontSize: 13.0,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 8.0,
                  ),
                  Expanded(
                    flex: 2,
                    child: RadioListTile(
                      selected: false,
                      title: Text("남자"),
                      value: 'male',
                      groupValue: userDatabase[userDataItem[3]],
                      onChanged: (value) {
                        setState(() {
                          userDatabase[userDataItem[3]] = value;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: RadioListTile(
                      selected: false,
                      title: Text("여자"),
                      value: 'female',
                      groupValue: userDatabase[userDataItem[3]],
                      onChanged: (value) {
                        setState(() {
                          userDatabase[userDataItem[3]] = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              GeneralTextField(
                  title: "나이 *",
                  func: (value) {
                    userDatabase[userDataItem[4]] = value;
                  }),
              GeneralTextField(
                title: "유치원 \n이름 *",
                func: (value) {
                  userDatabase[userDataItem[5]] = value;
                },
              ),
              GeneralTextField(
                title: "반 이름 *",
                func: (value) {
                  userDatabase[userDataItem[6]] = value;
                },
              ),
              GeneralTextField(
                title: "주소 *",
                func: (value) {
                  userDatabase[userDataItem[7]] = value;
                },
              ),
              GeneralTextField(
                title: "집전화",
                type: TextInputType.number,
                func: (value) {
                  userDatabase[userDataItem[8]] = value; // can be null
                },
              ),
              GeneralTextField(
                title: "휴대전화 *",
                type: TextInputType.number,
                func: (value) {
                  userDatabase[userDataItem[9]] = value;
                },
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                color: Colors.blue,
                buttonTitle: '가입하기',
                onPressed: () async {
                  int i = 0;
                  for (;
                      i < userDataItem.length &&
                          userDatabase[userDataItem[i]] != null;
                      ++i) {}
                  if (passwd == null || passwdForchk == null) {
                    _displayDialog("비밀번호를 확인해 주세요.");
                  } else if (passwd != passwdForchk) {
                    _displayDialog("비밀번호가 일치하지 않습니다.");
                  } else if (i != 8 && i < userDataItem.length) {
                    _displayDialog("${userDataItem[i]}을(를) 입력해주세요.");
                  } else {
                    try {
                      final User newUser =
                          (await _auth.createUserWithEmailAndPassword(
                        email: userDatabase[userDataItem[0]].trim(),
                        password: passwd,
                      )).user;
                      if (newUser != null) {
                        _fireStore
                            .collection('user')
                            .doc(userDatabase[userDataItem[0]])
                            .set({
                          // 비밀번호는 담지 않음
                          userDataItem[1]: userDatabase[userDataItem[1]],
                          // 닉네임
                          userDataItem[2]: userDatabase[userDataItem[2]],
                          // 원아 이름
                          userDataItem[3]: userDatabase[userDataItem[3]],
                          // 성별
                          userDataItem[4]: userDatabase[userDataItem[4]],
                          // 나이
                          userDataItem[5]: userDatabase[userDataItem[5]],
                          // 유치원 이름
                          userDataItem[6]: userDatabase[userDataItem[6]],
                          // 반 이름
                          userDataItem[7]: userDatabase[userDataItem[7]],
                          // 주소
                          userDataItem[8]: userDatabase[userDataItem[8]],
                          // 집전화
                          userDataItem[9]: userDatabase[userDataItem[9]],
                          // 휴대전화
                        });
                        passwd = null;
                        passwdForchk = null;
                        userDatabase = {};
                        await newUser.sendEmailVerification();
                        _displayDialogPleaseVerifyyouremail();
                      }
                    } catch (e) {
                      print(e);
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _displayDialog(String title) {
    showDialog(
      context: context,
      builder: (context) {
        return GeneralDialog(
          title: title,
          onTap: () {
            Navigator.pop(context);
          },
        );
      },
    );
  }

  void _displayDialogPleaseVerifyyouremail() {
    showDialog(
      context: context,
      builder: (context) {
        return GeneralDialog(
          title: '이메일을 인증해 주세요!',
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

//  DropdownButton<int> androidDropdown() {
//    int minAge = 3;
//    int maxAge = 7;
//    List<DropdownMenuItem<int>> dropdownItems = [];
//    for (var i = minAge; i < maxAge; ++i) {
//      var newItem = DropdownMenuItem(
//        child: Text('$i'),
//        value: i,
//      );
//      dropdownItems.add(newItem);
//    }
//
//    return DropdownButton<int>(
//      value: age,
//      items: dropdownItems,
//      onChanged: (value) {
//        setState(() {
//          age = value;
//        });
//      },
//    );
//  }
//
//  CupertinoPicker iOSPicker() {
//    int minAge = 3;
//    int maxAge = 7;
//    List<Text> pickerItems = [];
//    for (var i = minAge; i < maxAge; ++i) {
//      pickerItems.add(Text('$i'));
//    }
//
//    return CupertinoPicker(
//      backgroundColor: Colors.lightBlue,
//      itemExtent: 5.0,
//      onSelectedItemChanged: (selectedIndex) {
//        setState(() {
//          age = selectedIndex + 3;
//        });
//      },
//      children: pickerItems,
//    );
//  }
}
