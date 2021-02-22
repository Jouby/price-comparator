import 'package:flutter/material.dart';

class CustomAppBar extends AppBar {
  CustomAppBar({Widget title, List<Widget> actions, Widget leading})
      : super(
          title: title,
          iconTheme: IconThemeData(
            color: Colors.black87,
          ),
          actions: actions,
          leading: leading,
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
  CustomAppBarTitle(String name)
      : super(
          name,
          style: TextStyle(color: Colors.black87),
        );
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

class CustomPrimaryTextSpan extends TextSpan {
  CustomPrimaryTextSpan({String text})
      : super(
            text: text,
            style: TextStyle(
                fontFamily: 'Nunito',
                color: Colors.teal[700],
                fontWeight: FontWeight.bold,
                fontSize: 30));
}
