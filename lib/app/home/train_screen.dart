import 'package:andrea_project/services/auth.dart';
import 'package:andrea_project/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TrainScreen extends StatefulWidget {
  TrainScreen({@required this.database, @required this.auth});
  final Database database;
  final AuthBase auth;
  static Future<void> show(BuildContext context) async {
    final database = Provider.of<Database>(context, listen: false);
    final auth = Provider.of<AuthBase>(context, listen: false);
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TrainScreen(
          database: database,
          auth: auth,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _TrainScreenState createState() => _TrainScreenState();
}

class _TrainScreenState extends State<TrainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Train Screen'),
      ),
      body: Container(
        child: Text(widget.auth.currentUser.email),
      ),
    );
  }
}
