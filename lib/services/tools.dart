import 'package:flutter/material.dart';

/// The Tools widget
///
/// This widget is used to externalize some functions
class Tools extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return null;
  }

  static void showError(BuildContext context, String content) {
    showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Icon(Icons.error),
              content: Center(
                  child:
                      Text(content, style: TextStyle(color: Colors.red[800]))));
        });
  }
}

MaterialColor createMaterialColor(Color color) {
  var strengths = <double>[.05];
  var swatch = <int, Color>{};
  final r = color.red, g = color.green, b = color.blue;

  for (var i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  strengths.forEach((double strength) {
    final ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  });
  return MaterialColor(color.value, swatch);
}
