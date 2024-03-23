import 'package:flutter/material.dart';
import 'package:flutter_circle/game_model.dart';
import 'package:provider/provider.dart';

class Equation extends StatelessWidget {
  const Equation({super.key});

  @override
  Widget build(BuildContext context) {
    var game = context.watch<GameModel>();

    return Padding(
      padding: const EdgeInsets.only(top: 32.0),
      child: Text(game.equation,
          style: const TextStyle(
            fontSize: 48,
          )),
    );
  }
}
