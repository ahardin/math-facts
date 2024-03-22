import 'package:flutter/material.dart';

import 'circle_painter.dart';

typedef CircleCallback = bool Function(Circle circle, bool currentlySelected);

class Circle extends StatefulWidget {
  final CircleCallback? callback;
  final double x;
  final double y;
  String text = '';
  Color color;

  Circle(
      {super.key,
      required this.x,
      required this.y,
      this.text = '',
      this.color = Colors.black54,
      this.callback});

  @override
  State<Circle> createState() => _CircleState();
}

class _CircleState extends State<Circle> {
  bool selected = false;

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
          if (widget.callback != null) {
            if (widget.callback!(widget, selected)) {
              setState(() {
                selected = !selected;
              });
            }
          }
        },
        child: CustomPaint(
          size: const Size(radius * 2, radius * 2),
          painter: CirclePainter(
              color: selected ? Colors.red : widget.color, text: widget.text),
        ),
      ),
    );
  }
}
