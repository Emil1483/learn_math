import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../helpers/times_table.dart';
import './completed.dart';

class HomeRoute extends StatefulWidget {
  final Function showAd;

  const HomeRoute({@required this.showAd});

  @override
  _HomeRouteState createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute>
    with SingleTickerProviderStateMixin {
  final TimesTable _table = TimesTable();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();

  AnimationController _animation;

  final Performance _performance = Performance();
  Question _currentQuestion;
  DateTime _currentTime = DateTime.now();
  int _tries = 0;
  bool _newTry = true;
  bool _cantUnderstand = false;

  @override
  void initState() {
    super.initState();
    _currentQuestion = _table.nextQuestion();

    _animation = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _animation.dispose();
    _controller.dispose();
  }

  void _onInputChanged(String str) {
    if (str.isEmpty) _newTry = true;

    try {
      int ans = int.parse(str);

      setState(() => _cantUnderstand = false);

      if (ans.toString().length < _currentQuestion.ans.toString().length) {
        _newTry = true;
      }

      if (ans.toString().length != _currentQuestion.ans.toString().length) {
        return;
      }
      if (ans != _currentQuestion.ans) {
        if (!_newTry) return;
        _tries++;
        _animation.fling(
          velocity: _animation.isDismissed ? 1 : -1,
        );
        _newTry = false;
        return;
      }
      _performance.addQuestionData(
        QuestionData(
          question: _currentQuestion.copy(),
          duration: DateTime.now().difference(_currentTime),
          tries: _tries,
        ),
      );
      _currentTime = DateTime.now();
      _tries = 0;
      _nextQuestion(context);
      _controller.clear();
    } catch (_) {
      setState(() {
        _cantUnderstand = true;
      });
    }
  }

  void _nextQuestion(BuildContext context) {
    if (_table.length <= 0) {
      widget.showAd();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => CompletedRoute(_performance),
        ),
      );
      return;
    }
    setState(() => _currentQuestion = _table.nextQuestion());
  }

  double _shake(double t) {
    return 10 * math.sin(t * math.pi) * math.sin(t * math.pi * 3);
  }

  Widget _buildTextField() {
    return AnimatedBuilder(
      animation: _animation,
      builder: (BuildContext context, _) {
        return Transform.translate(
          offset: Offset(_shake(_animation.value), 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.arrow_forward, size: 52.0),
              SizedBox(width: 12.0),
              Container(
                width: 120,
                child: TextField(
                  controller: _controller,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 32.0),
                  keyboardType: TextInputType.number,
                  onChanged: _onInputChanged,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(
                        color: _cantUnderstand
                            ? Colors.red
                            : Theme.of(context).accentColor,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.0),
              Icon(Icons.arrow_back, size: 52.0),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Learn to Multiply"),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Align(
                alignment: Alignment(0, 1),
                child: Text(
                  _currentQuestion.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 64.0),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _buildTextField(),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment(0, -1),
                child: Text(
                  "Problems Left\n ${_table.length + 1}",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w200),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
