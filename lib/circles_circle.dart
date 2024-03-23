import 'package:flutter/material.dart';
import 'package:flutter_circle/circle.dart';
import 'package:flutter_circle/game_model.dart';
import 'package:provider/provider.dart';

class CirclesCircle extends StatelessWidget {
  const CirclesCircle({super.key});

  @override
  Widget build(BuildContext context) {
    var game = context.watch<GameModel>();

    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Stack(
        children: [
          for (var circle in game.circleItems)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 500),
              curve: Easing.standardDecelerate,
              top: constraints.constrainHeight() / 2 + circle.y,
              left: constraints.constrainWidth() / 2 + circle.x,
              child: Circle(item: circle, callback: game.selectCircle),
            ),
        ],
      );
    });
  }
}
