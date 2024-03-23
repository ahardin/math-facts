import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_circle/circle.dart';
import 'package:flutter_circle/circles_circle.dart';
import 'package:flutter_circle/equation.dart';
import 'package:flutter_circle/game_model.dart';
import 'package:provider/provider.dart';

import 'score.dart';
import 'status_message.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key, required this.title});

  final String title;

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GameModel(),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 247, 115,
                0), //Theme.of(context).colorScheme.inversePrimary,
            title: Text(widget.title),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  context.read<GameModel>().reset();
                },
              ),
            ],
          ),
          body: const Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Score(),
              ),
              Equation(),
              StatusMessage(),
              Expanded(child: CirclesCircle()),
            ],
          ),
        );
      }),
    );
  }
}
