import 'package:flutter/material.dart';

Widget songNameStyle(String title, String artist) {
  return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Center(
        child: Text(
          "$title / $artist",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ));
}

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
  final rhythmNumerator = rhythm?.split("/")[0];
  final rhythmDenominator = rhythm?.split("/")[1];
  return Padding(
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
  );
}

///調や拍がが変わったら二重線,最後の拍なら終始線
Widget insertionContainer(context, [String type]) {
  return Container(
      height: 32,
      width: 4,
      decoration: BoxDecoration(
        border: type == "double"
            ? Border(
                left: BorderSide(
                  color: Theme.of(context).textTheme.headline6.color,
                  width: 0.5,
                  style: BorderStyle.solid,
                ),
                right: BorderSide(
                  color: Theme.of(context).textTheme.headline6.color,
                  width: 0.5,
                  style: BorderStyle.solid,
                ),
              )
            : type == "last"
                ? Border(
                    left: BorderSide(
                      color: Theme.of(context).textTheme.headline6.color,
                      width: 0.5,
                      style: BorderStyle.solid,
                    ),
                    right: BorderSide(
                      color: Theme.of(context).textTheme.headline6.color,
                      width: 1.5,
                      style: BorderStyle.solid,
                    ),
                  )
                : Border(
                    left: BorderSide(
                      color: Theme.of(context).textTheme.headline6.color,
                      width: 0.5,
                      style: BorderStyle.solid,
                    ),
                  ),
      ));
}
