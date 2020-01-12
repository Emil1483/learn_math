import 'dart:math';

import 'package:flutter/material.dart';

class Question {
  final int factor1, factor2, ans;
  Question(this.factor1, this.factor2, this.ans);

  @override
  String toString() => "$factor1 x $factor2";

  Question copy() => Question(factor1, factor2, ans);
}

class QuestionData {
  final Question question;
  final Duration duration;
  final int tries;
  QuestionData({
    @required this.question,
    @required this.duration,
    @required this.tries,
  });
}

class Performance {
  final List<QuestionData> _data = [];

  int get length => _data.length;

  void addQuestionData(QuestionData questionData) {
    _data.add(questionData);
  }

  Duration getTotalTime() {
    Duration result = Duration();
    for (QuestionData data in _data) {
      result += data.duration;
    }
    return result;
  }

  int getCorrectOnFirst() {
    int result = 0;
    for (QuestionData data in _data) {
      if (data.tries == 0) result++;
    }
    return result;
  }
}

class TimesTable {
  List<Question> _allQuestions = [];
  List<Question> _possible = [];
  Random _random = Random();

  int get length => _possible.length;
  int get total => _allQuestions.length;

  TimesTable() {
    _possible.add(Question(1, 2, 2));
    _possible.add(Question(2, 2, 4));
    _possible.add(Question(3, 2, 6));
    _allQuestions = List.from(_possible);
    return;
    for (int i = 1; i < 10 - 1; i++) {
      for (int j = i; j < 10; j++) {
        _possible.add(Question(i, j, i * j));
      }
    }
  }

  Question nextQuestion() => _possible.removeAt(
        _random.nextInt(_possible.length),
      );
}
