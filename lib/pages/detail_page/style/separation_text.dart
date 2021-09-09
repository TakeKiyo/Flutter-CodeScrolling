import 'package:flutter/material.dart';

Widget separationTextStyle(context, String text) {
  return Align(
    alignment: Alignment.centerLeft,
    child: Card(
      color: Theme.of(context).textTheme.headline6.color,
      child: Text(
        text,
        style: TextStyle(
          letterSpacing: 1,
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: Theme.of(context).canvasColor,
        ),
      ),
    ),
  );
}
