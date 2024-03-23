import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_circle/circle.dart';
import 'package:flutter_circle/circles_circle.dart';
import 'package:flutter_circle/equation.dart';
import 'package:flutter_circle/game_model.dart';
import 'package:provider/provider.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key, required this.title});

  final String title;

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late List<Circle> circleWidgets;
  Queue<String> queue = Queue();
  String equation = '';
  int score = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(
            255, 247, 115, 0), //Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ChangeNotifierProvider(
        create: (context) => GameModel(),
        child: const Column(
          children: [
            Equation(),
            StatusMessage(),
            Expanded(child: CirclesCircle()),
          ],
        ),
      ),
    );
  }
}

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
