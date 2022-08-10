import 'package:app_toro/parts/app.bar.dart';
import 'package:app_toro/parts/drawer.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Where is my toro?',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Scaffold(
          drawer: ToroDrawer(), appBar: ToroAppBar(), body: Text('Hola')),
    );
  }
}
