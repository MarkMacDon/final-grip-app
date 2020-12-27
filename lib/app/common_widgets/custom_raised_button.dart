import 'package:flutter/material.dart';

class CustomRaisedButton extends StatelessWidget {
  const CustomRaisedButton({
    Key key,
    this.borderRadius = 4.0,
    this.color,
    this.onPressed,
    this.child,
    this.height = 50,
  }) : assert(borderRadius != null);

  final Widget child;
  final double borderRadius;
  final Color color;
  final VoidCallback onPressed;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: RaisedButton(
        onPressed: onPressed,
        color: color,
        disabledColor: color,
        child: child,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        ),
      ),
    );
  }
}
