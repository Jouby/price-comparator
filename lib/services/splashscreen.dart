import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:the_dead_masked_company.price_comparator/services/constants.dart';

/// The Splash Screen Widget
///
/// Display during 2 second an image before display the main UI screen
class ImageSplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<ImageSplashScreen> {
  /// Image path
  final imagePath = 'assets/splashscreen.png';

  /// Image margin
  final double imageMargin = 20.0;

  Timer _timer;

  /// Start Timer
  Future<Timer> startTime() async {
    var _duration = Duration(seconds: 2);
    _timer = Timer(_duration, navigationPage);
    return _timer;
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
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
