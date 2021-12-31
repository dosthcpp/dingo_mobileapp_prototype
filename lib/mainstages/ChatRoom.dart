import 'package:flutter/material.dart';
import 'package:dingo_prototype/constants.dart';
import 'package:dingo_prototype/data/user_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _fireStore = FirebaseFirestore.instance;

class ChatRoom extends StatefulWidget {
  final email;

  ChatRoom({this.email});

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final textEditingController = TextEditingController();

  String? messageText;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _MessagesStream(),
        Expanded(
          flex: 1,
          child: Material(
            elevation: 10.0,
            child: Padding(
              padding: EdgeInsets.only(
                left: 10.0,
                right: 10.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: RawMaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        side: BorderSide(
                          color: Colors.blue,
                        ),
                      ),
                      fillColor: Colors.white,
                      child: Icon(
                        Icons.add,
                        color: Colors.blue,
                      ),
                      onPressed: () {
                        // TODO: make feature buttons
                      },
                    ),
                  ),
                  Expanded(
                    flex: 10,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 3.0,
                        horizontal: 10.0,
                      ),
                      child: TextField(
                        controller: textEditingController,
                        decoration: kMessageTextFieldDecoration,
                        onChanged: (value) {
                          messageText = value;
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: StreamBuilder<DocumentSnapshot>(
                      stream: _fireStore
                          .collection('user')
                          .doc(widget.email)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.lightBlueAccent,
                            ),
                          );
                        }
                        return RawMaterialButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            side: BorderSide(
                              color: Color(0xFF2C76E3),
                            ),
                          ),
                          fillColor: Colors.blue,
                          onPressed: () {
//                              final String kindergartenName =
//                                  snapshot.data[userDataItem[5]].toString(); // 방이름
                          final _data = snapshot
                              .data!.data() as Map;
                          print(_data);
                            final String childName = _data[userDataItem[2]]
                                .toString(); // 원아 이름
                            final String className = _data[userDataItem[6]]
                                .toString(); // 반 이름
                            DateTime now = DateTime.now();
                            if (messageText == null) {
                              // do nothing
                            } else {
                              textEditingController.clear();
                              setState(
                                    () {
                                  _fireStore.collection('messageList').add(
                                    {
                                      'className': className,
                                      'childName': childName,
                                      'text': messageText,
                                      'sender': widget.email,
                                      'time': now.toString(),
                                    },
                                  );
                                  messageText = null;
                                },
                              );
                            }
                          },
                          child: Icon(
                            Icons.arrow_upward,
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}


class ChatRoomAppbar extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2.0,
      child: Padding(
        padding: EdgeInsets.only(
          top: 20.0,
        ),
        child: Container(
          height: 120.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  Material(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        10.0,
                      ),
                    ),
                    color: Colors.black12,
                    child: Image.asset(
                      'images/icon.png',
                      height: 70.0,
                      scale: 0.65,
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 30.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "희망유치원 희망반",
                          style: TextStyle(
                            fontSize: 21.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          "김시우 선생님",
                          style: TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[800],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 40.0,
                ),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Row(
                    children: <Widget>[
                      GestureDetector(
                        child: Icon(
                          Icons.search,
                          size: 30.0,
                        ),
                        onTap: () {
                          // Do something
                        },
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      GestureDetector(
                        child: Image.asset(
                          'images/alarm_setting.png',
                          height: 35.0,
                        ),
                        onTap: () {
                          // Do something
                        },
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}


class _MessagesStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _fireStore.collection('messageList').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        // TODO: order data by time directly on the database
        final messages = snapshot.data!.docs; // Flutter inline variable
        List<_MessageBubble> messageBubbles = [];
        for (var message in messages) {
          final msg = message.data() as Map;
          final String className = msg['className'];
          final String messageText = msg['text']; // messages from FirebaseData
          final String messageSender = msg['sender'];
          final DateTime time = DateTime.parse(msg['time']);
          final String currentUser = 'black_s@naver.com';

          final messageBubble = _MessageBubble(
            // TODO: if teacher send this message, ...
            // TODO: following kindergarten code, make a new chatroom.
            className: className,
            sender: messageSender,
            text: messageText,
            time: time.toString(),
            isMe: currentUser == messageSender,
          );
          messageBubbles.add(messageBubble);
        }
        messageBubbles.sort((a, b) {
          var aTime = a.time;
          var bTime = b.time;
          return -aTime.compareTo(bTime);
        });

        List<Widget> ret = [];
        for (var i = 0; i < messageBubbles.length; ++i) {
          ret.add(messageBubbles[i]);
          if (i + 1 != messageBubbles.length &&
              messageBubbles[i].time.toString().split(" ")[0] !=
                  messageBubbles[i + 1].time.toString().split((" "))[0]) {
            ret.add(
              _CustomDivider(
                time: DateTime.parse(
                  messageBubbles[i].time,
                ),
              ),
            );
          }
          if (i == messageBubbles.length - 1) {
            ret.add(
              _CustomDivider(
                time: DateTime.parse(
                  messageBubbles[i].time,
                ),
              ),
            );
          }
        }

        return Expanded(
          flex: 10,
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 20.0,
            ),
            children: ret,
          ),
        );
      },
    );
  }
}

class _CustomDivider extends StatelessWidget {
  _CustomDivider({required this.time});

  final DateTime time;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 10.0,
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Divider(
              color: Colors.black,
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                time.toString().split(" ")[0].split("-")[0] +
                    "년 " +
                    time.toString().split(" ")[0].split("-")[1] +
                    "월 " +
                    time.toString().split(" ")[0].split("-")[2] +
                    "일",
                style: TextStyle(
                  fontSize: 12.0,
                ),
              ),
            ),
          ),
          Expanded(
            child: Divider(
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  _MessageBubble({
    required this.className,
    this.sender,
    required this.text,
    required this.time,
    required this.isMe,
  });

  final String className;
  final String? sender;
  final String text;
  final String time;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    if (!isMe) {
      return Padding(
        padding: EdgeInsets.symmetric(
          vertical: 5.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: AssetImage(
                'images/icon.png',
              ),
            ),
            SizedBox(
              width: 10.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "[새싹반] 김시우 선생님",
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Material(
                      borderRadius: kBorderRadiusIfIsNotMe,
                      color: Colors.black54,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 5.0,
                          horizontal: 15.0,
                        ),
                        child: Text(
                          text,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      time.split(" ")[1].split(":")[0] +
                          ":" +
                          time.split(" ")[1].split(":")[1],
                      style: TextStyle(
                        fontSize: 12.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.symmetric(
          vertical: 5.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  "김시우 학부모님",
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      time.split(" ")[1].split(":")[0] +
                          ":" +
                          time.split(" ")[1].split(":")[1],
                      style: TextStyle(
                        fontSize: 12.0,
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Material(
                      borderRadius: kBorderRadiusIfIsMe,
                      color: Colors.blue,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 5.0,
                          horizontal: 15.0,
                        ),
                        child: Text(
                          text,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              width: 10.0,
            ),
            CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: AssetImage(
                'images/icon.png',
              ),
            ),
          ],
        ),
      );
    }
  }
}
