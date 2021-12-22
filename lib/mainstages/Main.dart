import 'package:flutter/material.dart';
import 'package:dingo_prototype/components/advertisement_frame.dart';

class Main extends StatelessWidget {
  final Function onVerticalDragStart;
  final double height;
  final Widget info;
  bool visible = false;

  Main({this.onVerticalDragStart, this.height, this.visible, this.info});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          left: 3.0,
          right: 3.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onVerticalDragStart: onVerticalDragStart,
              child: Padding(
                padding: EdgeInsets.only(
                  left: 15.0,
                  right: 15.0,
                  top: 15.0,
                ),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  height: height,
                  width: MediaQuery.of(context).size.width,
                  child: Material(
                    elevation: 2.0,
                    color: Colors.white,
                    shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          4.0,
                        ),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Visibility(
                          visible: visible,
                          child: Text(
                            "희망유치원 공기질",
                            style: TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Visibility(
                          visible: visible,
                          child: Image.asset(
                            // graph_placeholder
                            'images/graph_placeholder.png',
                            height: 250,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: 5.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Visibility(
                                visible: !visible,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    right: 30.0,
                                  ),
                                  child: Image.asset(
                                    'images/weather/good.png',
                                    height: 60.0,
                                  ),
                                ),
                              ),
                              info,
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 20.0,
                bottom: 25.0,
                left: 10.0,
                right: 10.0,
              ),
              child: Card(
                elevation: 2.0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 600.0,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                          top: 10.0,
                          right: 8.0,
                        ),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: GestureDetector(
                            child: Text(
                              "수정",
                              style: TextStyle(
                                fontSize: 10.0,
                                color: Colors.black54,
                              ),
                            ),
                            onTap: () {
                              // Do something
                            },
                          ),
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.0,
                            ),
                            child: CircleAvatar(
                              child: Image.asset(
                                'images/icon.png',
                              ),
                              backgroundColor: Colors.grey[200],
                              radius: 36.0,
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 3.0,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Text(
                                      "박나래",
                                      style: TextStyle(
                                        fontSize: 21.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 3.0,
                                    ),
                                    Text(
                                      "만 5세",
                                      style: TextStyle(
                                        fontSize: 13.0,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 3.0,
                                    ),
                                    Image.asset(
                                      'images/heart_2.png',
                                      height: 20.0,
                                    ),
                                  ],
                                ),
                              ),
                              Material(
                                color: Colors.greenAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 7.0,
                                    vertical: 2.0,
                                  ),
                                  child: Text(
                                    "유치원 이름",
                                    style: TextStyle(
                                      fontSize: 9.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 30.0,
                          bottom: 20.0,
                        ),
                        child: Advertisement(),
                      ),
                      Advertisement(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}