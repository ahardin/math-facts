import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_circle/game_model.dart';
import 'package:provider/provider.dart';

class Equation extends StatelessWidget {
  const Equation({super.key});

  @override
  Widget build(BuildContext context) {
    var game = context.watch<GameModel>();
    game.addListener(() => {});
    return Padding(
      padding: const EdgeInsets.only(top: 32.0),
      child: Builder(builder: (context) {
        var el = Text(game.equation,
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: game.status == QuestionStatus.correct
                      ? Colors.green
                      : game.status == QuestionStatus.incorrect
                          ? Colors.red
                          : Colors.black,
                ))
            .animate(target: game.status == QuestionStatus.unanswered ? 0 : 1
                //onPlay: (controller) => controller.repeat(reverse: true),
                )
            .scale(
              duration: const Duration(milliseconds: 200),
              end: const Offset(1.2, 1.2),
              begin: const Offset(1, 1),
            );

        if (game.status == QuestionStatus.incorrect) {
          el = el.animate(target: 1).shake();
        }

        return el;
      }),
    );
  }
}
