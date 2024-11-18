import 'package:flutter/material.dart';

showSnackBar(BuildContext context, String text,{Color customColor = Colors.black,Color textColor = Colors.white}) {
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: customColor,
    content: Text(
      text,
      style: TextStyle(
        color: textColor,
        fontWeight: FontWeight.bold,
        fontSize: 16
      )
    ),
  ));
}
