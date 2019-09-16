import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../helpers/times_table.dart';
import '../ui_elements/main_button.dart';
import './completed.dart';

class HomeRoute extends StatefulWidget {
  @override
  _HomeRouteState createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute>
    with SingleTickerProviderStateMixin {
  final TimesTable _table = TimesTable();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();

  AnimationController _animation;
  DateTime _whenStarted;

  Question _question;
  int _correct = 0;
  bool _wrong = false;

  @override
  void initState() {
    super.initState();
    _question = _table.nextQuestion();
    _animation = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );
    _whenStarted = DateTime.now();
  }

  @override
  void dispose() {
    super.dispose();
    _animation.dispose();
  }

  void _nextQuestion(BuildContext context) {
    if (_table.length <= 0) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => CompletedRoute(
            DateTime.now().difference(_whenStarted),
            _correct,
          ),
        ),
      );
      return;
    }
    setState(() => _question = _table.nextQuestion());
  }

  double _shake(double t) {
    return 10 * math.sin(t * math.pi) * math.sin(t * math.pi * 3);
  }

  Widget _buildTextField() {
    return Container(
      width: 120,
      child: TextField(
        controller: _controller,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 32.0),
        keyboardType: TextInputType.number,
      ),
    );
  }

  Widget _buildCheckButton() {
    return AnimatedBuilder(
      animation: _animation,
      builder: (BuildContext context, _) {
        return Transform.translate(
          offset: Offset(_shake(_animation.value), 0),
          child: MainButton(
            onPressed: () {
              Scaffold.of(context).hideCurrentSnackBar();
              try {
                String str = _controller.text;
                int ans = int.parse(str);
                if (ans != _question.ans) {
                  _wrong = true;
                  _animation.fling(
                    velocity: _animation.isDismissed ? 1 : -1,
                  );
                  return;
                }
                if (!_wrong) setState(() => _correct++);
                _wrong = false;
                _nextQuestion(context);
                _controller.clear();
              } catch (_) {
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Could not understand your answer"),
                  ),
                );
                return;
              }
            },
            child: Text("Check"),
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
              child: Center(
                child: Text(
                  _question.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 64.0),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Column(
                children: <Widget>[
                  _buildTextField(),
                  SizedBox(height: 22.0),
                  _buildCheckButton(),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                "Total Correct\n $_correct",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w200),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
