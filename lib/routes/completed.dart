import 'package:flutter/material.dart';

import '../ui_elements/main_button.dart';
import '../helpers/times_table.dart';

class CompletedRoute extends StatelessWidget {
  final Performance performance;

  const CompletedRoute(this.performance);

  String _format(int value) {
    String result = value.toString();
    if (result.length == 1) result = "0$result";
    return result;
  }

  @override
  Widget build(BuildContext context) {
    Duration totalTime = performance.getTotalTime();
    int hours = totalTime.inHours;
    int minutes = totalTime.inMinutes - hours * 60;
    int secounds = totalTime.inSeconds - hours * 60 * 60 - minutes * 60;
    return Scaffold(
      appBar: AppBar(
        title: Text("You did it!"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "You completed the times table in",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24.0),
            ),
            SizedBox(height: 24.0),
            Text(
              "${_format(hours)}:${_format(minutes)}:${_format(secounds)}",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 64.0),
            ),
            SizedBox(height: 8.0),
            Text(
              "with ${performance.getCorrectOnFirst()}/${performance.length} on your first try",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w200),
            ),
            SizedBox(height: 64.0),
            MainButton(
              child: Text("Practise Again"),
              onPressed: () {
                Navigator.of(context).pushReplacementNamed("/");
              },
            ),
          ],
        ),
      ),
    );
  }
}
