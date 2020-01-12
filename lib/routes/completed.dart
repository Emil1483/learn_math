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

  Widget _buildGraph(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    final List<QuestionData> data = performance.getSortedData();
    final int maxSecounds = performance.getMaxDuration().inMilliseconds;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: data.map((QuestionData qData) {
          final double fraction = qData.duration.inMilliseconds / maxSecounds;
          Color color = Colors.green[600];
          if (qData.tries > 0) {
            color = Theme.of(context).accentColor;
          } else if (qData.tries > 1) {
            color = Colors.red;
          }
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Text(
                    qData.question.toString(),
                    style: textTheme.subhead,
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: SizedBox(
                    height: 32.0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: CustomPaint(
                        painter: FractionPainter(
                          fraction: fraction,
                          partColor: color,
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Text(
                              (qData.duration.inMilliseconds / 1000)
                                  .toStringAsFixed(1),
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMainWidget(BuildContext context) {
    final Duration totalTime = performance.getTotalTime();
    final int hours = totalTime.inHours;
    final int minutes = totalTime.inMinutes - hours * 60;
    final int secounds = totalTime.inSeconds - hours * 60 * 60 - minutes * 60;

    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final EdgeInsets padding = mediaQuery.padding;
    final double height =
        mediaQuery.size.height - 56.0 - padding.top - padding.bottom;

    return SizedBox(
      height: height,
      child: Stack(
        children: <Widget>[
          Center(
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
          Align(
            alignment: Alignment(0, 0.85),
            child: Wrap(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(
                      "See your performance",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    SizedBox(height: 12.0),
                    Icon(Icons.arrow_downward, size: 42.0),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("You Did It!"),
      ),
      body: ListView(
        children: <Widget>[
          _buildMainWidget(context),
          _buildGraph(context),
          SizedBox(height: 32.0),
        ],
      ),
    );
  }
}

class FractionPainter extends CustomPainter {
  final double fraction;
  final Color partColor;
  final Color notPartColor;

  FractionPainter({
    @required this.fraction,
    this.partColor = Colors.orange,
    this.notPartColor = Colors.grey,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTRB(0, 0, size.width * fraction, size.height),
      Paint()..color = partColor,
    );
    canvas.drawRect(
      Rect.fromLTRB(size.width * fraction, 0, size.width, size.height),
      Paint()..color = notPartColor,
    );
  }

  @override
  bool shouldRepaint(FractionPainter oldDelegate) {
    return false;
  }
}
