import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//Show Toast Message
void showSnackBar({@required scaffoldKey, String text, String buttonText, VoidCallback onPressed}) {
  try {
    scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(text),
        action: SnackBarAction(label: buttonText, onPressed: onPressed),
      ),
    );
  } catch (e) {
    scaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text(text)),
    );
  }
}

// Return Alert Dialog Box
void showAlertDialog(BuildContext context, String title, String body) {
  // flutter defined function
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: new Text(title),
        content: new Text(body),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          new FlatButton(
            child: new Text("Close"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

//Show loading pop up
void showLoading(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
          bottomLeft: Radius.circular(30.0),
          bottomRight: Radius.circular(30.0),
        )),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: new Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              new CircularProgressIndicator(),
              Padding(
                padding: const EdgeInsets.all(10),
                child: new Text("Loading, please wait..."),
              ),
            ],
          ),
        ),
      );
    },
  );
}
