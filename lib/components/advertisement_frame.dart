import 'package:flutter/material.dart';

class Advertisement extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 15.0,
      ),
      child: Material(
        color: Colors.grey,
        borderRadius: BorderRadius.all(
          Radius.circular(
            5.0,
          ),
        ),
        child: MaterialButton(
          height: 200.0,
          child: Center(
            child: Text(
              "Advertisement",
            ),
          ),
          // TODO: direct to the page
          onPressed: () {},
        ),
      ),
    );
  }
}
