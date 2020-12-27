import 'package:andrea_project/app/app_sign_in/sign_in_manager.dart';
import 'package:andrea_project/app/app_sign_in/sign_in_button.dart';
import 'package:andrea_project/app/app_sign_in/social_sign_in_button.dart';
import 'package:andrea_project/app/common_widgets/show_exception_alert_dialog.dart';
import 'package:andrea_project/services/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:andrea_project/app/app_sign_in/email_sign_in_page.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatelessWidget {
  SignInPage({@required this.manager, @required this.isLoading});
  final SignInManager manager;
  final bool isLoading;
  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<ValueNotifier<bool>>(
      create: (_) => ValueNotifier<bool>(false),
      child: Consumer<ValueNotifier<bool>>(
        builder: (_, isLoading, __) => Provider<SignInManager>(
          create: (_) => SignInManager(isLoading: isLoading, auth: auth),
          child: Consumer<SignInManager>(
            builder: (_, manager, __) => SignInPage(
              manager: manager,
              isLoading: isLoading.value,
            ),
          ),
        ),
      ),
    );
  }

  void _showSignInError(BuildContext context, Exception exception) {
    if (exception is FirebaseException &&
        exception.code == 'ERROR_ABORTED_BY_USER') return;
    showExceptionAlertDialog(context,
        title: "Sign in failed", exception: exception);
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      await manager.signInWithGoogle();
    } catch (error) {
      _showSignInError(context, error);
    }
  }

  Future<void> _signInAnonymously(BuildContext context) async {
    try {
      await manager.signInAnonymously();
    } catch (error) {
      _showSignInError(context, error);
    }
  }

  Future<void> _signInWithFacebook(BuildContext context) async {
    try {
      await manager.signInWithFacebook();
    } catch (error) {
      _showSignInError(context, error);
    }
  }

  void _signInWithEmail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (context) => EmailSignInPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(
          'Sign In Page Title',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 2,
      ),
      body: _buildContent(context),
    );
  }

  Container _buildContent(BuildContext context) {
    return Container(
      color: Colors.black87,
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 50,
            child: _buildTitle(),
          ),
          SizedBox(height: 60),
          SocialSignInButton(
            color: Colors.white24,
            onPressed: isLoading ? null : () => _signInWithGoogle(context),
            text: 'Sign In with Google',
            textColor: Colors.white,
            assetName: 'images/google-logo.png',
          ),
          SizedBox(height: 10),
          SocialSignInButton(
            color: Colors.white24,
            onPressed: isLoading ? null : () => _signInWithFacebook(context),
            text: 'Sign In with Facebook',
            textColor: Colors.white,
            assetName: 'images/facebook-logo.png',
          ),
          SizedBox(height: 10),
          SignInButton(
            color: Colors.white24,
            onPressed: isLoading ? null : () => _signInWithEmail(context),
            text: 'Sign In with email',
            textColor: Colors.white,
          ),
          SizedBox(height: 10),
          Text(
            'or',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: 10),
          SignInButton(
            color: Colors.white24,
            onPressed: isLoading ? null : () => _signInAnonymously(context),
            text: 'Go Anonymous',
            textColor: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    if (isLoading == false) {
      return Text(
        'Grip App',
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 42, fontWeight: FontWeight.bold, color: Colors.white),
      );
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}
