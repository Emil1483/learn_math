import 'package:flutter/material.dart';

class MainButton extends StatelessWidget {
  final Function onPressed;
  final Widget child;

  const MainButton({@required this.onPressed, @required this.child});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: Theme.of(context).accentColor,
      textColor: Theme.of(context).canvasColor,
      onPressed: onPressed,
      child: child,
    );
  }
}
