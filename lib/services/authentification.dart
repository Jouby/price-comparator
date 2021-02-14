import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuth {
  Future<String> signIn(String email, String password);

  Future<String> signUp(String email, String password);

  User getCurrentUser();

  Future<void> sendEmailVerification();

  Future<void> signOut();
}

class Auth implements BaseAuth {
  FirebaseAuth firebaseAuth;

  Auth({this.firebaseAuth});

  @override
  Future<String> signIn(String email, String password) async {
    var result = await firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    var user = result.user;

    return user.uid;
  }

  @override
  Future<String> signUp(String email, String password) async {
    var result = await firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    var user = result.user;

    return user.uid;
  }

  @override
  User getCurrentUser() {
    return firebaseAuth.currentUser;
  }

  @override
  Future<void> signOut() async {
    return firebaseAuth.signOut();
  }

  @override
  Future<void> sendEmailVerification() async {
    var user = firebaseAuth.currentUser;
    await user.sendEmailVerification();
  }
}
