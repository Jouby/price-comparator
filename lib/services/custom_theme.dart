import 'package:flutter/material.dart';

class CustomAppBar extends AppBar {
  CustomAppBar(
      {Widget? title,
      List<Widget>? actions,
      Widget? leading,
      double? leadingWidth,
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
  CustomIconButton({required Widget icon, String? tooltip, Function()? onPressed})
      : super(
            icon: icon,
            tooltip: tooltip,
            color: Colors.black87,
            onPressed: onPressed);
}

class CustomFloatingActionButton extends FloatingActionButton {
  CustomFloatingActionButton(
      {Function()? onPressed, String? tooltip, Widget? child})
      : super(
            onPressed: onPressed,
            tooltip: tooltip,
            backgroundColor: Colors.teal,
            child: child,
            elevation: 20,
            highlightElevation: 0);

  CustomFloatingActionButton.extended(
      {Function()? onPressed, required Widget label, Widget? icon, String? tooltip})
      : super.extended(
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
  CustomButton({Key? key, Function()? onPressed, Widget? child})
      : super(
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
  CustomHighlightTextSpan({String? text})
      : super(
            text: text,
            style: TextStyle(color: Colors.teal[700], fontSize: 30));
}

class CustomBasicTextSpan extends TextSpan {
  CustomBasicTextSpan({String? text, List<TextSpan>? children})
      : super(
            text: text,
            style: TextStyle(
                color: Colors.black, fontSize: 25, fontFamily: 'Nunito'),
            children: children);
}

class CustomBasicText extends Text {
  CustomBasicText(String text, {List<TextSpan>? children})
      : super(text,
            style: TextStyle(
                color: Colors.black, fontSize: 25, fontFamily: 'Nunito'));
}
