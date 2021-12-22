import 'package:flutter/material.dart';

class ChildCard extends StatelessWidget {
  ChildCard({
    @required this.childName,
    @required this.age,
  });

  final String childName;
  final int age;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        right: 10.0,
      ),
      child: Container(
        // TODO: flexible width
        height: 25.0,
        width: 103.0,
        child: Material(
          borderRadius: BorderRadius.circular(12.0),
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(5.0),
            child: Row(
              children: <Widget>[
                Image.asset(
                  'images/heart_2.png',
                ),
                SizedBox(
                  width: 5.0,
                ),
                Text(
                  childName,
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: 5.0,
                ),
                Text(
                  "만 $age세",
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.black54,
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
