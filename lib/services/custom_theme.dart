import 'package:flutter/material.dart';

class CustomAppBar extends AppBar {
  CustomAppBar(
      {Widget title,
      List<Widget> actions,
      Widget leading,
      double leadingWidth,
      bool centerTitle = true})
      : super(
          title: title,
          centerTitle: centerTitle,
          iconTheme: IconThemeData(
            color: Colors.black87,
          ),
          actions: actions,
          leading: leading,
          leadingWidth: leadingWidth,
          bottom: PreferredSize(
              child: Container(
                color: Colors.black38,
                height: 1.0,
              ),
              preferredSize: Size.fromHeight(1.0)),
        );
}

class CustomIconButton extends IconButton {
  CustomIconButton({Widget icon, String tooltip, Function() onPressed})
      : super(
            icon: icon,
            tooltip: tooltip,
            color: Colors.black87,
            onPressed: onPressed);
}

class CustomFloatingActionButton extends FloatingActionButton {
  CustomFloatingActionButton(
      {Function() onPressed, String tooltip, Widget child})
      : super(
            onPressed: onPressed,
            tooltip: tooltip,
            backgroundColor: Colors.teal,
            child: child,
            elevation: 20,
            highlightElevation: 0);
}

class CustomAppBarTitle extends Text {
  CustomAppBarTitle(String name) : super(name);
}

class CustomRaisedButton extends RaisedButton {
  CustomRaisedButton({Function() onPressed, Widget child})
      : super(
          onPressed: onPressed,
          child: child,
          padding: EdgeInsets.all(10),
          textColor: Colors.black87,
          color: Colors.teal,
          colorBrightness: Brightness.light,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25.0))),
          elevation: 5,
        );
}

class CustomHighlightTextSpan extends TextSpan {
  CustomHighlightTextSpan({String text})
      : super(
            text: text,
            style: TextStyle(color: Colors.teal[700], fontSize: 30));
}

class CustomBasicTextSpan extends TextSpan {
  CustomBasicTextSpan({String text, List<TextSpan> children})
      : super(
            text: text,
            style: TextStyle(
                color: Colors.black, fontSize: 25, fontFamily: 'Nunito'),
            children: children);
}

class CustomBasicText extends Text {
  CustomBasicText(String text, {List<TextSpan> children})
      : super(text,
            style: TextStyle(
                color: Colors.black, fontSize: 25, fontFamily: 'Nunito'));
}
