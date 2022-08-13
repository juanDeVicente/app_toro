import 'package:flutter/material.dart';

class ErrorData extends StatelessWidget {
  final String? error;

  const ErrorData({Key? key, this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Icon(
          Icons.error_outline,
          color: Colors.red,
          size: 60,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Text('Error: $error'),
        )
      ],
    ));
  }
}
