import 'package:andrea_project/app/common_widgets/custom_raised_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FromSubmitButton extends CustomRaisedButton {
  FromSubmitButton({
    @required String text,
    @required VoidCallback onPressed,
    @required Color color,
  }) : super(
          child: Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 19),
          ),
          height: 44,
          color: color,
          borderRadius: 4.0,
          onPressed: onPressed,
        );
}
