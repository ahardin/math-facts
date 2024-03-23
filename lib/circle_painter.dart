import 'package:flutter/material.dart';

class CirclePainter extends CustomPainter {
  final Color color;
  String text = '';

  CirclePainter({required this.color, this.text = ''});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, paint);

    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 32,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    final textOffset = Offset(
      center.dx - textPainter.width / 2,
      center.dy - textPainter.height / 2,
    );
    textPainter.paint(canvas, textOffset);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
