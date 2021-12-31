import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class FadeIn extends StatelessWidget {
  final double delay;
  final Widget child;

  FadeIn(this.delay, this.child);

  @override
  Widget build(BuildContext context) {
    final tween = MultiTween();
    tween.add("opacity", Tween(
      begin: 0.0,
      end: 1.0,
    ), Duration(milliseconds: 500));
    tween.add("translateX", Tween(
      begin: 130.0,
      end: 0.0,
    ), Duration(milliseconds: 500));

    // [
    //   Track("opacity")
    //       .add(Duration(milliseconds: 500), Tween(begin: 0.0, end: 1.0)),
    //   Track("translateX").add(
    //       Duration(milliseconds: 500), Tween(begin: 130.0, end: 0.0),
    //       curve: Curves.easeOut)
    // ]

    return PlayAnimation(
      delay: Duration(milliseconds: (300 * delay).round()),
      duration: tween.duration,
      tween: tween,
      child: child,
      builder: (context, _, MultiTweenValues animation) {
        return Opacity(
          opacity: animation.get("opacity"),
          child: Transform.translate(
              offset: Offset(animation.get("translateX"), 0), child: child),
        );
      },
    );
  }
}