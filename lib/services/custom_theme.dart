import 'package:flutter/material.dart';

class CustomAppBar extends AppBar {
  CustomAppBar({
    required Widget title,
    required List<Widget> actions,
    required Widget leading,
    required double leadingWidth,
    bool centerTitle = true,
  }) : super(
          title: title,
          centerTitle: centerTitle,
          iconTheme: IconThemeData(
            color: Colors.black87,
          ),
          actions: actions,
          leading: leading,
          leadingWidth: leadingWidth,
          bottom: PreferredSize(
              preferredSize: Size.fromHeight(1.0),
              child: Container(
                color: Colors.black38,
                height: 1.0,
              )),
        );
}

class CustomIconButton extends IconButton {
  CustomIconButton({
    required Widget icon,
    required String tooltip,
    required Function() onPressed,
  }) : super(
            icon: icon,
            tooltip: tooltip,
            color: Colors.black87,
            onPressed: onPressed);
}

class CustomFloatingActionButton extends FloatingActionButton {
  CustomFloatingActionButton(
      {required Function() onPressed,
      required String tooltip,
      required Widget child})
      : super(
            onPressed: onPressed,
            tooltip: tooltip,
            backgroundColor: Colors.teal,
            child: child,
            elevation: 20,
            highlightElevation: 0);

  CustomFloatingActionButton.extended({
    required Function() onPressed,
    required Widget label,
    required Widget icon,
    required String tooltip,
  }) : super.extended(
            onPressed: onPressed,
            label: label,
            icon: icon,
            tooltip: tooltip,
            backgroundColor: Colors.teal,
            elevation: 20,
            highlightElevation: 0);
}

class CustomAppBarTitle extends Text {
  CustomAppBarTitle(String name) : super(name);
}

class CustomButton extends ElevatedButton {
  CustomButton({
    required Key key,
    required Function() onPressed,
    required Widget child,
  }) : super(
            key: key,
            onPressed: onPressed,
            child: child,
            style: ButtonStyle(
              padding: MaterialStateProperty.all(EdgeInsets.all(10)),
              textStyle:
                  MaterialStateProperty.all(TextStyle(color: Colors.black87)),
              backgroundColor: MaterialStateProperty.all(Colors.teal),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              elevation: MaterialStateProperty.all(5),
            ));
}

class CustomHighlightTextSpan extends TextSpan {
  CustomHighlightTextSpan({required String text})
      : super(
            text: text,
            style: TextStyle(color: Colors.teal[700], fontSize: 30));
}

class CustomBasicTextSpan extends TextSpan {
  CustomBasicTextSpan({
    required String text,
    required List<TextSpan> children,
  }) : super(
            text: text,
            style: TextStyle(
                color: Colors.black, fontSize: 25, fontFamily: 'Nunito'),
            children: children);
}

class CustomBasicText extends Text {
  CustomBasicText(String text, {required List<TextSpan> children})
      : super(text,
            style: TextStyle(
                color: Colors.black, fontSize: 25, fontFamily: 'Nunito'));
}
