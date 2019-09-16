import 'dart:math';

class Question {
  final int factor1, factor2, ans;
  Question(this.factor1, this.factor2, this.ans);
  @override
  String toString() => "$factor1 x $factor2";
}

class TimesTable {
  List<Question> _possible = List<Question>();
  Random _random = Random();

  int get length => _possible.length;

  TimesTable() {
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
