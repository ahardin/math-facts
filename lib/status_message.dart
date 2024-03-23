import 'package:flutter/material.dart';
import 'package:flutter_circle/game_model.dart';
import 'package:provider/provider.dart';

class StatusMessage extends StatelessWidget {
  const StatusMessage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var game = context.watch<GameModel>();
    return Text(
        game.status == QuestionStatus.incorrect ? 'Nope, try again.' : '');
  }
}
