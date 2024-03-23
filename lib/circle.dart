import 'package:flutter/material.dart';
import 'package:flutter_circle/game_model.dart';
import 'package:provider/provider.dart';

import 'circle_painter.dart';

typedef CircleCallback = void Function(CircleItem item);

class Circle extends StatelessWidget {
  final CircleItem item;
  final CircleCallback callback;

  const Circle({super.key, required this.item, required this.callback});

  @override
  Widget build(BuildContext context) {
    const double radius = 40;

    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(3, 3),
            ),
          ]),
      child: GestureDetector(
        onTap: () {
          callback(item);
        },
        child: Opacity(
          opacity: item.state == CircleState.correct ? .6 : 1,
          child: CustomPaint(
            size: const Size(radius * 2, radius * 2),
            painter: CirclePainter(
                color: item.state == CircleState.selected
                    ? Colors.blue
                    : item.state == CircleState.correct
                        ? Colors.lightGreen
                        : item.color,
                text: item.text),
          ),
        ),
      ),
    );
  }
}
