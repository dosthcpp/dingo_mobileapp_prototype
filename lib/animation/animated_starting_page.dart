import 'dart:math';
import 'package:dingo_prototype/MainPage.dart';
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class AnimatedStartingPage extends StatefulWidget {
  static const String id = 'fancy_background';

  @override
  _AnimatedStartingPageState createState() => _AnimatedStartingPageState();
}

class _AnimatedStartingPageState extends State<AnimatedStartingPage> {
  @override
  void initState() {
    Future.delayed(
      Duration(seconds: 3),
      () {
        Navigator.pushReplacementNamed(context, MainPage.id);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedBackground(),
        onBottom(
          AnimatedWave(
            height: 180,
            speed: 1.0,
          ),
        ),
        onBottom(
          AnimatedWave(
            height: 120,
            speed: 0.9,
            offset: pi,
          ),
        ),
        onBottom(
          AnimatedWave(
            height: 220,
            speed: 1.2,
            offset: pi / 2,
          ),
        ),
        Positioned.fill(
          child: Image.asset(
            'images/dingo_icon.png',
            scale: 1.8,
          ),
        ),
      ],
    );
  }

  onBottom(Widget child) => Positioned.fill(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: child,
        ),
      );
}

class AnimatedWave extends StatelessWidget {
  final double? height;
  final double? speed;
  final double offset;

  AnimatedWave({this.height, this.speed, this.offset = 0.0});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        height: height,
        width: constraints.biggest.width,
        child: PlayAnimation(
            // playback: Playback.LOOP,
            duration: Duration(milliseconds: (5000 / speed!).round()),
            tween: Tween(begin: 0.0, end: 2 * pi),
            builder: (context, _, double value) {
              return CustomPaint(
                foregroundPainter: CurvePainter(value + offset),
              );
            }),
      );
    });
  }
}

class CurvePainter extends CustomPainter {
  final double value;

  CurvePainter(this.value);

  @override
  void paint(Canvas canvas, Size size) {
    final white = Paint()..color = Colors.white.withAlpha(60);
    final path = Path();

    final y1 = sin(value);
    final y2 = sin(value + pi / 2);
    final y3 = sin(value + pi);

    final startPointY = size.height * (0.5 + 0.4 * y1);
    final controlPointY = size.height * (0.5 + 0.4 * y2);
    final endPointY = size.height * (0.5 + 0.4 * y3);

    path.moveTo(size.width * 0, startPointY);
    path.quadraticBezierTo(
        size.width * 0.5, controlPointY, size.width, endPointY);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, white);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class AnimatedBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tween = MultiTween();
    tween.add(
        "color1",
        ColorTween(
          begin: Color(0xFF99d3bd),
          end: Colors.lightBlue.shade900,
        ),
        Duration(seconds: 3));
    tween.add(
        "color2",
        ColorTween(
          begin: Colors.lightBlue.shade900,
          end: Colors.blue.shade600,
        ),
        Duration(seconds: 3));

    // [
    //   Track("color1").add(
    //     Duration(seconds: 3),
    //     ColorTween(
    //       begin: Color(0xFF99d3bd),
    //       end: Colors.lightBlue.shade900,
    //     ),
    //   ),
    //   Track("color2").add(
    //     Duration(seconds: 3),
    //     ColorTween(
    //       begin: Colors.lightBlue.shade900,
    //       end: Colors.blue.shade600,
    //     ),
    //   )
    // ]

    return PlayAnimation(
      // playback: Playback.MIRROR,
      tween: tween,
      duration: tween.duration,
      builder: (context, _, MultiTweenValues animation) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [animation.get("color1"), animation.get("color2")],
            ),
          ),
        );
      },
    );
  }
}
