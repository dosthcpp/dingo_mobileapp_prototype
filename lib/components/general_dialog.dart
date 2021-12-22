import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';

class GeneralDialog extends StatelessWidget {
  GeneralDialog({
    @required this.title,
    @required this.onTap,
  });

  final String title;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return AlertDialog(
        title: Text(
          "경고",
        ),
        content: Text(
          title,
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              "확인",
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
    } else if (Platform.isIOS) {
      return CupertinoAlertDialog(
        title: Text("경고"),
        content: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              "확인",
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: onTap,
          ),
        ],
      );
    }
  }
}
