import 'package:flutter/material.dart';
import 'package:flutter_circle/game_model.dart';
import 'package:provider/provider.dart';

class GameTimer extends StatelessWidget {
  const GameTimer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var game = context.watch<GameModel>();
    return Text('Time: ${game.time}', style: const TextStyle(fontSize: 18));
  }
}
