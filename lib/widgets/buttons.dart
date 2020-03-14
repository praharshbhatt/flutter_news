import 'package:flutter/material.dart';

import '../main.dart';

//This Package contains the widgets for all the buttons used in the app

//This Returns the Primary Raised button with Icon
RaisedButton primaryRaisedIconButton(
    {@required BuildContext context,
    @required String text,
    @required Icon icon,
    double textSize,
    Color color,
    Color highlightColor,
    Color splashColor,
    Color textColor,
    VoidCallback onPressed}) {
  return RaisedButton.icon(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.0),
              topRight: Radius.circular(10.0),
              bottomLeft: Radius.circular(10.0),
              bottomRight: Radius.circular(10.0)),
          side: BorderSide(color: Color.fromARGB(255, 51, 72, 84))),
      color: color == null ? Color.fromARGB(255, 51, 72, 84) : color,
      disabledColor: Colors.grey,
      highlightColor: highlightColor == null ? Color.fromARGB(255, 51, 72, 84) : highlightColor,
      splashColor: splashColor == null ? Colors.white : splashColor,
      icon: icon,
      label: Text(text, style: getTextStyle(context, textSize, textColor)),
      onPressed: () => onPressed());
}

//This Returns the Primary Raised button
RaisedButton primaryRaisedButton(
    {@required BuildContext context,
    @required String text,
    double textSize,
    Color color,
    Color highlightColor,
    Color splashColor,
    Color textColor,
    VoidCallback onPressed}) {
  return RaisedButton(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
      padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
      color: color == null ? Color.fromARGB(255, 51, 72, 84) : color,
      disabledColor: Color.fromARGB(255, 51, 72, 84),
      highlightColor: highlightColor == null ? Color.fromARGB(255, 51, 72, 84) : highlightColor,
      splashColor: splashColor == null ? Colors.white : splashColor,
      child: Text(text, style: getTextStyle(context, textSize, textColor)),
      onPressed: () => onPressed());
}

//Get the TextStyle from the given params
TextStyle getTextStyle(_context, _textSize, _textColor) {
  TextStyle _textStyle;

  //Defining size
  if (_textSize == null) _textSize = MediaQuery.of(_context).size.width * 0.04;
  //Defining textColor
  if (_textColor == null) {
    _textStyle = TextStyle(
      fontSize: _textSize,
    );
  } else {
    _textStyle = TextStyle(
      fontSize: _textSize,
      color: _textColor,
    );
  }

  return _textStyle;
}
