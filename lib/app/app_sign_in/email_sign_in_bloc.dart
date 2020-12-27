import 'dart:async';

import 'package:andrea_project/app/app_sign_in/email_sign_in_model.dart';
import 'package:andrea_project/services/auth.dart';
import 'package:flutter/foundation.dart';

//* Steps 1-3 required every time a BLoC is implemented
//* Step 1: Create Stream
//* Step 2: Add values to Stream via helper method
//* Step 3: Dispose the Bloc when finished
//* methods here generate a copy of the model with updateWith
//* which calls the copyWith method of the model class

class EmailSignInBloc {
  EmailSignInBloc({@required this.auth});
  final AuthBase auth;

  //create a StreamController, ModelStream, and model Instance
  final StreamController<EmailSignInModel> _modelController =
      StreamController<EmailSignInModel>();

  Stream<EmailSignInModel> get modelStream => _modelController.stream;
  EmailSignInModel _model = EmailSignInModel();
  void dispose() {
    _modelController.close();
  }

  void updateEmail(String email) => updateWith(email: email);
  void updatePassword(String password) => updateWith(password: password);

  void toggleFormType() {
    final formType = _model.formType == EmailSignInFormType.signIn
        ? EmailSignInFormType.register
        : EmailSignInFormType.signIn;
    updateWith(
      password: '',
      email: '',
      submitted: false,
      isLoading: false,
      formType: formType,
    );
  }

  Future<void> submit() async {
    updateWith(isLoading: true, submitted: true);
    try {
      if (_model.formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmailAndPassword(_model.email, _model.password);
      } else if (_model.formType == EmailSignInFormType.register) {
        await auth.createUserWithEmailAndPassword(
            _model.email, _model.password);
      }
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }

  void updateWith({
    String email,
    String password,
    EmailSignInFormType formType,
    bool submitted,
    bool isLoading,
  }) {
    //update model
    _model = _model.copyWith(
      email: email,
      password: password,
      formType: formType,
      isLoading: isLoading,
      submitted: submitted,
    );
    // add updated model to model controller
    _modelController.add(_model);
  }
}
