import 'package:andrea_project/app/app_sign_in/validators.dart';
import 'package:andrea_project/services/auth.dart';
import 'package:flutter/foundation.dart';

import '../../not_in_use/email_sign_in_model.dart';

class EmailSignInChangeModel with EmailAndPasswordValidators, ChangeNotifier {
  EmailSignInChangeModel(
      {@required this.auth,
      this.email = '',
      this.password = '',
      this.formType = EmailSignInFormType.signIn,
      this.submitted = false,
      this.isLoading = false});

  final AuthBase auth;
  String email;
  String password;
  EmailSignInFormType formType;
  bool submitted;
  bool isLoading;

  String get primaryButtonText {
    return formType == EmailSignInFormType.signIn
        ? 'Sign in'
        : 'Create an account';
  }

  String get secondaryButtonText {
    return formType == EmailSignInFormType.register
        ? 'Have an account? Sign in'
        : 'Need an account? Register';
  }

  bool get canSubmit {
    return emailValidator.isValid(email) && passwordValidator.isValid(password);
  }

  String get passwordErrorText {
    if (submitted && !emailValidator.isValid(email)) {
      return invalidEmailErrorText;
    }
    return null;
  }

  String get emailErrorText {
    if (submitted && !emailValidator.isValid(email)) {
      return invalidPasswordErrorText;
    }
    return null;
  }

  void updateEmail(String email) => updateWith(email: email);

  void updatePassword(String password) => updateWith(password: password);

  void toggleFormType() {
    //* this.formType references class formType instead of local (in method) formType
    formType = this.formType == EmailSignInFormType.signIn
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
      if (formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmailAndPassword(email, password);
      } else if (this.formType == EmailSignInFormType.register) {
        await auth.createUserWithEmailAndPassword(email, password);
      }
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }

  //* This method allows the model to be copied while keeping unchanged perameters
  void updateWith({
    String email,
    String password,
    EmailSignInFormType formType,
    bool submitted,
    bool isLoading,
  }) {
    this.email = email ?? this.email;
    this.password = password ?? this.password;
    this.formType = formType ?? this.formType;
    this.submitted = submitted ?? this.submitted;
    this.isLoading = isLoading ?? this.isLoading;
    notifyListeners();
  }
}
