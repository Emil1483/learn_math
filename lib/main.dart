import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './routes/home_route.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: 'Learn to multiply',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        canvasColor: Color(0xFF161B21),
        accentColor: Color(0xFFF4A342),
        toggleableActiveColor: Color(0xFFF4A342),
        appBarTheme: AppBarTheme(
          color: Color(0xFF222A33),
          textTheme: TextTheme(
            title: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 22.0,
            ),
          ),
        ),
      ),
      home: HomeRoute(),
    );
  }
}
