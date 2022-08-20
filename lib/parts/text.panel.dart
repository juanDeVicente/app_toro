import 'package:flutter/material.dart';

class TextPanel extends StatelessWidget {
  const TextPanel({Key? key, required this.headerText, required this.bodyText})
      : super(key: key);

  final String headerText;
  final String bodyText;
  final Color backgroundColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 30.0, right: 30.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
          border: Border.all(color: backgroundColor),
          color: backgroundColor,
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                  style: TextStyle(
                      fontSize: 24, color: Theme.of(context).primaryColor),
                  textAlign: TextAlign.justify,
                  headerText)),
          Text(
              style: const TextStyle(
                fontSize: 16,
              ),
              textAlign: TextAlign.justify,
              bodyText),
        ],
      ),
    );
  }
}
