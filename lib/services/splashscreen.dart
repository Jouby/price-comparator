import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:the_dead_masked_company.price_comparator/resources/user_repository.dart';
import 'package:the_dead_masked_company.price_comparator/services/globals.dart';

/// The Splash Screen Widget
///
/// Display during 2 second an image before display the main UI screen
class ImageSplashScreen extends StatefulHookWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<ImageSplashScreen> {
  /// Image path
  final imagePath = 'assets/splashscreen.png';

  /// Image margin
  final double imageMargin = 20.0;

  Timer _timer;

  FirestoreNotifier firestoreNotifier;

  /// Start Timer
  Future<Timer> startTime() async {
    var _duration = Duration(seconds: 1);
    _timer = Timer(_duration, navigationPage);
    return _timer;
  }

  /// Navigate to Home screen
  void navigationPage() async {
    if (firestoreNotifier.isLoaded) {
      var username = await UserRepository().getUserName();
      var route =
          username != null ? Constants.homeScreen : Constants.loginScreen;
      await Navigator.of(context).pushReplacementNamed(route);
    } else {
      await startTime();
    }
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    firestoreNotifier = useProvider(firestoreProvider);

    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(left: imageMargin, right: imageMargin),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[Image.asset(imagePath)],
        ),
      ),
    );
  }
}
