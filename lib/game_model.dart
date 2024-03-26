import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';

class GameModel extends ChangeNotifier {
  List<CircleItem> circleItems = [];
  String equation = '';
  Queue<String> queue = Queue();
  QuestionStatus status = QuestionStatus.unanswered;
  int score = 0;

  GameModel() {
    circleItems = generateNewProblems();
    startTimer();
    notifyListeners();
  }

  late Timer _timer;
  int defaultTime = 120;
  int time = 120;

  void startTimer() {
    const oneSec = Duration(seconds: 1);

    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (time == 0) {
          timer.cancel();
        } else {
          time--;
          notifyListeners();
        }
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void startNewRound() {
    _timer.cancel();
    time = defaultTime;
    startTimer();
    circleItems = generateNewProblems();
  }

  void selectCircle(CircleItem circle) {
    if (time <= 0) return;

    if (circle.state == CircleState.normal) {
      if (canSelect(circle)) {
        circle.state = CircleState.selected;
        queue.add(circle.text);
      }
    } else if (circle.state == CircleState.selected) {
      if (queue.isNotEmpty && queue.last == circle.text) {
        circle.state = CircleState.normal;
        queue.removeLast();
      }
    }

    updateEquation();
    checkEquation();

    var allCorrect = circleItems.every((element) =>
        element.text == '=' || element.state == CircleState.correct);

    if (allCorrect) {
      startNewRound();
    } else {
      // see if any combination of the remaining "normal" circles can be a valid equation

      var isEquationRemaining = false;

      var remainingNumbers = circleItems
          .where((element) =>
              isNumeric(element.text) && element.state != CircleState.correct)
          .map((e) => int.parse(e.text))
          .toList();

      var remainingOperators = circleItems
          .where((element) =>
              element.text == 'X' && element.state != CircleState.correct)
          .map((e) => e.text)
          .toList();

      for (var i = 0; i < remainingNumbers.length; i++) {
        for (var j = 0; j < remainingNumbers.length; j++) {
          if (j == i) continue;

          for (var k = 0; k < remainingNumbers.length; k++) {
            if (k == i || k == j) continue;

            for (var operator in remainingOperators) {
              var realAnswer = remainingNumbers[i] * remainingNumbers[j];
              var possibleAnswer = remainingNumbers[k];

              if (realAnswer == possibleAnswer) {
                isEquationRemaining = true;
                break;
              }
            }
          }
        }
      }

      if (!isEquationRemaining) {
        startNewRound();
        queue.clear();
      }
    }

    notifyListeners();
  }

  void updateEquation() {
    equation = queue.map((e) => e.toLowerCase()).join(' ');
  }

  void checkEquation() {
    if (queue.length == 5) {
      var num1 = int.parse(queue.elementAt(0));
      var num2 = int.parse(queue.elementAt(2));
      var product = int.parse(queue.elementAt(4));

      if (queue.elementAt(1) == 'X' && num1 * num2 == product) {
        status = QuestionStatus.correct;
        score++;

        for (var circle in circleItems) {
          if (circle.text == '=') {
            circle.state = CircleState.normal;
          } else if (circle.state == CircleState.selected) {
            circle.state = CircleState.correct;
          }
        }

        queue.clear();
      } else {
        status = QuestionStatus.incorrect;
        queue.clear();

        for (var circle in circleItems) {
          if (circle.state == CircleState.selected) {
            circle.state = CircleState.normal;
          }
        }
      }
    } else {
      status = QuestionStatus.unanswered;
    }
  }

  bool isNumeric(String text) {
    return int.tryParse(text) != null;
  }

  bool canSelect(CircleItem circle) {
    if (isNumeric(circle.text)) {
      if (queue.isEmpty) {
        return true;
      }

      if (queue.last == 'X' || queue.last == '=') {
        return true;
      }

      return false;
    }

    if (circle.text == 'X') {
      return queue.length == 1;
    }

    if (circle.text == '=') {
      return queue.length == 3;
    }

    return false;
  }

  CircleItem createCircle(
      double angle, int index, double radius, double itemRadius, String text) {
    return CircleItem(
        x: cos(angle * index) * radius - itemRadius,
        y: sin(angle * index) * radius - itemRadius,
        color: Colors.orange,
        text: text,
        state: CircleState.normal);
  }

  List<CircleItem> generateNewProblems() {
    var problems =
        generateMultiplicationProblems(numberOfProblems: 2, maxMultiplier: 6);

    var circleCount = problems.length * 4;

    var angle = 2 * pi / circleCount;
    double radius = 150;
    double itemRadius = 40;
    var index = 0;

    List<String> terms = [];

    for (var problem in problems) {
      terms.add(problem.num1.toString());
      terms.add('X');
      terms.add(problem.num2.toString());
      terms.add(problem.product.toString());
    }

    terms.shuffle();

    List<CircleItem> items = [];

    for (var term in terms) {
      items.add(createCircle(angle, index++, radius, itemRadius, term));
    }

    // add the equals item
    items.add(CircleItem(
        x: -40,
        y: -40,
        color: Colors.orange,
        text: '=',
        state: CircleState.normal));

    items.shuffle();

    return items;
  }

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

  void reset() {
    score = 0;
    queue.clear();
    equation = '';
    circleItems = generateNewProblems();
    _timer.cancel();
    time = defaultTime;
    startTimer();
    notifyListeners();
  }
}

class CircleItem {
  final double x;
  final double y;
  final String text;
  final Color color;
  CircleState state = CircleState.normal;

  CircleItem(
      {required this.x,
      required this.y,
      required this.text,
      required this.color,
      required this.state});
}

class Problem {
  final int num1;
  final int num2;
  final int product;

  Problem(this.num1, this.num2, this.product);
}

enum CircleState {
  normal,
  selected,
  correct,
}

enum QuestionStatus {
  correct,
  incorrect,
  unanswered,
}
