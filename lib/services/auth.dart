import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthBase {
  User get currentUser;
  Future<User> signInWithFacebook();
  Future<User> signInWithGoogle();
  Future<User> signInAnonymously();
  Future<User> signInWithEmailAndPassword(String email, String password);
  Future<User> createUserWithEmailAndPassword(String email, String password);
  Stream<User> authStateChanges();
  Future<void> signOut();
}

class Auth implements AuthBase {
  final _firebaseAuth = FirebaseAuth.instance;

  @override
  Stream<User> authStateChanges() => _firebaseAuth.authStateChanges();

  @override
  User get currentUser => _firebaseAuth.currentUser;

  @override
  Future<User> signInAnonymously() async {
    final userCredential = await _firebaseAuth.signInAnonymously();
    return userCredential.user;
  }

  @override
  //* To sign in an ID Token and an Access Token are required

  Future<User> signInWithGoogle() async {
    final googleSignIn = GoogleSignIn();
    print('Google Sign In instance created');
    final googleUser = await googleSignIn.signIn();
    print('Google user created');
    if (googleUser != null) {
      print('Google user isnt null');
      final googleAuth = await googleUser.authentication;
      if (googleAuth.idToken != null) {
        final userCredential = await _firebaseAuth
            .signInWithCredential(GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        ));
        return userCredential.user;
      } else {
        throw FirebaseAuthException(
          message: "Missing Google ID token",
        );
      }
    } else {
      throw FirebaseAuthException(
        message: "Sign in aborted by user",
        code: 'ERROR_ABORTED_BY_USER',
      );
    }
  }

  @override
  Future<User> signInWithFacebook() async {
    final fb = FacebookLogin();
    print('Facebook Login instance created');
    final response = await fb.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email,
    ]);
    print('Facebook response recieved');

    switch (response.status) {
      case FacebookLoginStatus.Success:
        final accessToken = response.accessToken;
        final userCredential = await _firebaseAuth.signInWithCredential(
          FacebookAuthProvider.credential(accessToken.token),
        );
        return userCredential.user;
      case FacebookLoginStatus.Error:
        throw FirebaseAuthException(
          message: 'Login status Error',
        );
      case FacebookLoginStatus.Cancel:
        throw FirebaseAuthException(
          message: 'Login cancelled by user',
          code: 'ERROR_ABORTED_BY_USER',
        );
      default:
        throw UnimplementedError();
    }
  }

  @override
  Future<User> signInWithEmailAndPassword(String email, String password) async {
    final userCredential = await _firebaseAuth.signInWithCredential(
      EmailAuthProvider.credential(email: email, password: password),
    );
    return userCredential.user;
  }

  @override
  Future<User> createUserWithEmailAndPassword(
      String email, String password) async {
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return userCredential.user;
  }

  @override
  Future<void> signOut() async {
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    final fbLogin = FacebookLogin();
    await fbLogin.logOut();
    await _firebaseAuth.signOut();
  }
}
