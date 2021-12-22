import 'package:flutter/material.dart';

class GeneralTextField extends StatelessWidget {
  GeneralTextField(
      {@required this.title, this.obscureText, this.type, this.func});

  final String title;
  bool obscureText;
  TextInputType type;
  Function func;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 10.0,
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.0,
              ),
            ),
          ),
          SizedBox(
            width: 8.0,
          ),
          Expanded(
            flex: 5,
            child: TextField(
                obscureText: obscureText == null ? false : true,
                keyboardType: type,
                textAlign: TextAlign.start,
                onChanged: func),
          ),
        ],
      ),
    );
  }
}
