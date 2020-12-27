import 'package:andrea_project/app/common_widgets/show_alert_dialog.dart';
import 'package:andrea_project/app/home/train_screen.dart';
import 'package:andrea_project/app/home/training_plan_screen.dart';
import 'package:andrea_project/services/auth.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:andrea_project/app/constants/constants.dart';

class MainMenuPage extends StatelessWidget {
  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await buildAlert(
      context,
      title: 'Logout',
      content: 'Are you sure?',
      defaultActionText: 'Ok',
      cancelActionText: 'Cancel',
    );
    if (didRequestSignOut == true) {
      _signOut(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: kAppBarColor,
        title: Text('Main Menu'),
        actions: [
          FlatButton(
            onPressed: () => _confirmSignOut(context),
            child: Text(
              'Logout',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          FlatButton(
              onPressed: () => TrainingPlanScreen.show(context),
              child: Text('Training Plan')),
          FlatButton(
              onPressed: () => TrainScreen.show(context), child: Text('Train')),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => TrainingPlanScreen.show(context),
        child: Icon(Icons.add),
      ),
    );
  }
}
