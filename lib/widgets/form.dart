import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../main.dart';

//This Package contains the widgets for all the Form related widgets
typedef CallBackString(String val);

TextFormField getTextFormField(
    {@required BuildContext context,
    @required TextEditingController controller,
    @required String strHintText,
    @required String strLabelText,
    Icon icon,
    TextInputType keyboardType,
    CallBackString validator,
    CallBackString onChanged,
    CallBackString onFieldSubmitted,
    Color textColor = Colors.black}) {
  return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        focusColor: textColor,
        fillColor: textColor,
        hoverColor: textColor,
        hintText: strHintText,
        hintStyle: TextStyle(
            fontSize: (!kIsWeb) ? MediaQuery.of(context).size.width * 0.04 : MediaQuery.of(context).size.width * 0.03,
            color: textColor),
        labelText: strLabelText,
        labelStyle: TextStyle(
            fontSize: (!kIsWeb) ? MediaQuery.of(context).size.width * 0.04 : MediaQuery.of(context).size.width * 0.03,
            color: textColor),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: myAppTheme.accentColor, width: 8)),
        suffixIcon: icon,
      ),
      keyboardType: keyboardType == null ? TextInputType.phone : keyboardType,
      style: TextStyle(
          fontSize: (!kIsWeb) ? MediaQuery.of(context).size.width * 0.04 : MediaQuery.of(context).size.width * 0.03,
          color: textColor),
      cursorColor: textColor,
      validator: (val) => validator(val),
      onChanged: (val) => onChanged(val),
      onFieldSubmitted: (val) => onFieldSubmitted(val));
}

TextFormField getTextFormFieldPassword({
  @required BuildContext context,
  @required TextEditingController controller,
  @required String strHintText,
  @required String strLabelText,
  Icon icon,
  TextInputType keyboardType,
  CallBackString validator,
  CallBackString onChanged,
}) {
  return TextFormField(
      controller: controller,
      maxLines: 1,
      decoration: new InputDecoration(
        hintText: strHintText,
        hintStyle: TextStyle(
            fontSize: (!kIsWeb) ? MediaQuery.of(context).size.width * 0.04 : MediaQuery.of(context).size.width * 0.03,
            color: Colors.black),
        labelText: strLabelText,
        labelStyle: TextStyle(
            fontSize: (!kIsWeb) ? MediaQuery.of(context).size.width * 0.04 : MediaQuery.of(context).size.width * 0.03,
            color: Colors.black),
        border: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(8),
            borderSide: new BorderSide(color: Color.fromARGB(255, 51, 72, 84), width: 10)),
        icon: icon,
      ),
      keyboardType: keyboardType == null ? TextInputType.phone : keyboardType,
      obscureText: true,
      style: TextStyle(
        fontSize: (!kIsWeb) ? MediaQuery.of(context).size.width * 0.06 : MediaQuery.of(context).size.width * 0.03,
      ),
      validator: (val) => validator(val),
      onChanged: (val) => onChanged(val));
}
