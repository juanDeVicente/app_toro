import 'package:app_toro/parts/app.bar.dart';
import 'package:app_toro/parts/drawer.dart';
import 'package:app_toro/parts/text.panel.dart';
import 'package:flutter/material.dart';

class ToroApp extends StatelessWidget {
  const ToroApp({Key? key}) : super(key: key);

  final double separation = 30.0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Where is my toro?',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
          drawer: const ToroDrawer(),
          appBar: const ToroAppBar(),
          body: Container(
            color: const Color(0xFFe6e6e6),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: separation,
                  ),
                  const TextPanel(
                      headerText: '¿Qué es "Where is my toro"?',
                      bodyText:
                          '"Where is my toro?" es la aplicación definitiva que te permitirá ganar a tus amigos en el famosísimo juego de "Toro"'),
                  SizedBox(
                    height: separation,
                  ),
                  const TextPanel(
                      headerText: '¿Qué es el juego de "Toro"?',
                      bodyText:
                          'El juego de toro es aquel que se juega en las carreteras de España que consiste en lo siguiente: El primero que ve un toro en la carretera tiene la obligación de gritar Toro para ganar la ronda. Quien hubiera gritado más veces toro en la ruta será el ganador'),
                  SizedBox(
                    height: separation,
                  ),
                  const TextPanel(
                      headerText: '¿Cómo puedes usar la app?',
                      bodyText:
                          'Usando el menú desplegable de la izquierda puedes curiosear con las opciones disponibles de la app'),
                ]),
          )),
    );
  }
}
