import 'package:andrea_project/app/app_sign_in/email_sign_in_form_bloc_based.dart';
import 'package:andrea_project/app/app_sign_in/email_sign_in_form_change_notifier.dart';
import 'package:flutter/material.dart';

class EmailSignInPage extends StatelessWidget {
  const EmailSignInPage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
        elevation: 2,
      ),
      backgroundColor: Colors.grey[900],
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Card(
            color: Colors.white70,
            child: EmailSignInFormChangeNotifier.create(context),
          ),
        ),
      ),
    );
  }
}
