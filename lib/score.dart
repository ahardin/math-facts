import 'package:flutter/material.dart';
import 'package:flutter_circle/game_model.dart';
import 'package:provider/provider.dart';

class Score extends StatelessWidget {
  const Score({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var game = context.watch<GameModel>();
    return Text('Score: ${game.score}', style: const TextStyle(fontSize: 18));
  }
}
