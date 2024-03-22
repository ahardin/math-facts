import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_circle/circle.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key, required this.title});

  final String title;

  @override
  State<GamePage> createState() => _GamePageState();
}

class Problem {
  final int num1;
  final int num2;
  final int product;

  Problem(this.num1, this.num2, this.product);
}

class _GamePageState extends State<GamePage> {
  late List<Circle> circleWidgets;
  Queue<String> queue = Queue();
  String equation = '';
  int score = 0;

  List<Problem> generateMultiplicationProblems(
      {int numberOfProblems = 2, int maxMultiplier = 10}) {
    List<Problem> problems = [];
    for (int i = 0; i < numberOfProblems; i++) {
      int num1 = Random().nextInt(maxMultiplier + 1);
      int num2 = Random().nextInt(maxMultiplier + 1);
      int product = num1 * num2;
      problems.add(Problem(num1, num2, product));
    }
    problems.shuffle();
    return problems;
  }

  bool isNumeric(String text) {
    return int.tryParse(text) != null;
  }

  void addOperand(String operand) {
    queue.add(operand);
    updateEquation();

    if (queue.length == 5) {
      var num1 = int.parse(queue.elementAt(0));
      var num2 = int.parse(queue.elementAt(2));
      var product = int.parse(queue.elementAt(4));

      if (queue.elementAt(1) == 'X' && num1 * num2 == product) {
        queue.clear();
        updateEquation();
        for (var circle in circleWidgets) {
          //circle.deselect();
        }
        setState(() {
          score++;
        });
      }
    }
  }

  void updateEquation() {
    setState(() {
      equation = queue.map((e) => e.toLowerCase()).join(' ');
    });
  }

  bool trySelect(circle, selected) {
    if (selected) {
      if (circle.text == queue.last) {
        queue.removeLast();
        updateEquation();
        return true;
      }

      return false;
    }

    if (isNumeric(circle.text)) {
      if (queue.isEmpty) {
        addOperand(circle.text);
        return true;
      }

      if (queue.last == 'X' || queue.last == '=') {
        addOperand(circle.text);
        return true;
      }

      return false;
    }

    if (circle.text == 'X') {
      if (queue.length == 1) {
        addOperand('X');
        return true;
      }
    }

    if (circle.text == '=') {
      if (queue.length == 3) {
        addOperand('=');
        return true;
      }
    }

    return false;
  }

  Circle createCircle(
      double angle, int index, double radius, double itemRadius, String text) {
    return Circle(
        x: cos(angle * index) * radius - itemRadius,
        y: sin(angle * index) * radius - itemRadius,
        color: Colors.orange,
        text: text,
        callback: trySelect);
  }

  @override
  void initState() {
    super.initState();

    var problems =
        generateMultiplicationProblems(numberOfProblems: 2, maxMultiplier: 10);

    circleWidgets = List.empty(growable: true);

    var circleCount = problems.length * 4;

    var angle = 2 * pi / circleCount;
    double radius = 150;
    double itemRadius = 40;
    var index = 0;

    for (var problem in problems) {
      circleWidgets.add(createCircle(
          angle, index, radius, itemRadius, problem.num1.toString()));

      index++;

      circleWidgets.add(createCircle(
          angle, index, radius, itemRadius, problem.num2.toString()));

      index++;

      circleWidgets.add(createCircle(
          angle, index, radius, itemRadius, problem.product.toString()));

      index++;

      circleWidgets.add(createCircle(angle, index, radius, itemRadius, 'X'));

      index++;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return Stack(
          children: [
            Positioned(
              top: 70,
              left: constraints.constrainWidth() / 2 - 90,
              child: Text(
                equation,
                style:
                    const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            for (var circle in circleWidgets)
              AnimatedPositioned(
                duration: const Duration(milliseconds: 500),
                curve: Easing.standardDecelerate,
                top: constraints.constrainHeight() / 2 + circle.y,
                left: constraints.constrainWidth() / 2 + circle.x,
                child: circle,
              ),
            Positioned(
                top: constraints.constrainHeight() / 2 - 40,
                left: constraints.constrainWidth() / 2 - 40,
                child: Circle(
                  x: 12,
                  y: 12,
                  color: Colors.blue,
                  text: '=',
                  callback: trySelect,
                )),
          ],
        );
      }),
    );
  }
}
