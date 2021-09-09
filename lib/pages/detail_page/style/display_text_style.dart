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

Widget rhythmTextStyle(String rhythm) {
  final rhythmNumerator = rhythm.split("/")[0];
  final rhythmDenominator = rhythm.split("/")[1];
  return Align(
    alignment: Alignment.bottomLeft,
    child: Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Text(
        "$rhythmNumerator\nー\n$rhythmDenominator",
        style: TextStyle(
          height: 0.5,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        textAlign: TextAlign.center,
      ),
    ),
  );
}
