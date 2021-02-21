import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// The Constants class
///
/// All constants value used through the application
class Constants {
  static String splashScreen = 'SPLASH_SCREEN';
  static String homeScreen = 'HOME_SCREEN';
  static String loginScreen = 'LOGIN_SCREEN';
}

class FirestoreNotifier extends ChangeNotifier {
  bool isLoaded = false;

  void loaded() {
    isLoaded = true;
  }
}

final firestoreProvider =
    ChangeNotifierProvider.autoDispose<FirestoreNotifier>((ref) {
  ref.maintainState = true;
  return FirestoreNotifier();
});
