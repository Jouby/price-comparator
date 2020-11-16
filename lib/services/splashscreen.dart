import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:the_dead_masked_company.price_comparator/services/constants.dart';

/// The Splash Screen Widget
///
/// Display during 2 second an image before display the main UI screen
class ImageSplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => new SplashScreenState();
}

class SplashScreenState extends State<ImageSplashScreen> {
  /// Image path
  static const imagePath = 'assets/splashscreen.png';
  /// Image margin
  static const imageMargin = 20.0;

  /// Start Timer
  startTime() async {
    var _duration = new Duration(seconds: 2);
    return Timer(_duration, navigationPage);
  }

  /// Navigate to Home screen
  void navigationPage() {
    Navigator.of(context).pushReplacementNamed(Constants.homeScreen);
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(
          left: SplashScreenState.imageMargin,
          right: SplashScreenState.imageMargin
        ),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[Image.asset(SplashScreenState.imagePath)],
        ),
      ),
    );
  }
}
