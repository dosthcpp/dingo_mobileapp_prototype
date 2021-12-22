import 'package:flutter/material.dart';

class AppBarDesign extends StatelessWidget {
  bool isMainScreen = false;
  final actionButtons;
  final Function onTap;
  final String title;

  AppBarDesign({
    @required this.isMainScreen,
    this.actionButtons,
    this.onTap,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: isMainScreen
          ? null
          : GestureDetector(
              child: Icon(
                Icons.navigate_before,
                color: Colors.black,
              ),
              onTap: onTap,
            ),
      backgroundColor: Colors.white,
      elevation: 5.0,
      centerTitle: true,
      title: title != null
          ? Text(
              title,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            )
          : Image.asset(
              'images/logo.png',
              height: 40.0,
              alignment: Alignment.center,
            ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      actions: actionButtons,
    );
  }
}
