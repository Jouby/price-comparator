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
