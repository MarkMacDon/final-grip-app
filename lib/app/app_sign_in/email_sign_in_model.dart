import 'package:andrea_project/app/app_sign_in/validators.dart';

enum EmailSignInFormType { signIn, register }

class EmailSignInModel with EmailAndPasswordValidators {
  EmailSignInModel(
      {this.email = '',
      this.password = '',
      this.formType = EmailSignInFormType.signIn,
      this.submitted = false,
      this.isLoading = false});

  final String email;
  final String password;
  final EmailSignInFormType formType;
  final bool submitted;
  final bool isLoading;

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

  //* This method allows the model to be copied while keeping unchanged perameters
  EmailSignInModel copyWith({
    String email,
    String password,
    EmailSignInFormType formType,
    bool submitted,
    bool isLoading,
  }) {
    return EmailSignInModel(
      email: email ?? this.email,
      password: password ?? this.password,
      formType: formType ?? this.formType,
      submitted: submitted ?? this.submitted,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
