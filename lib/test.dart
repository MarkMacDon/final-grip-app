import 'package:flutter/material.dart';

class TestPage extends StatelessWidget {
  final String uid1;
  final String uid2;

  const TestPage({@required this.uid1, @required this.uid2});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Page'),
      ),
      body: Center(
        child: FlatButton(
          onPressed: () => print('$uid1 is UID1 \n $uid2 is UID2'),
          child: Text('UID 1'),
        ),
      ),
    );
  }
}
