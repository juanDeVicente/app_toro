import 'package:app_toro/parts/error.data.dart';
import 'package:app_toro/parts/waiting.data.dart';
import 'package:app_toro/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DistanceDialog extends StatefulWidget {
  const DistanceDialog({Key? key}) : super(key: key);

  @override
  State<DistanceDialog> createState() {
    return _DistanceDialogState();
  }
}

class _DistanceDialogState extends State<DistanceDialog> {
  final double _minDistance = 1.0;
  final double _maxDistance = 8.0;

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<bool> _updateRealTime() async {
    return (await _prefs).getBool(keyUpdateRealTime) ?? false;
  }

  Future<bool> _showNotifications() async {
    return (await _prefs).getBool(keyShowNotifications) ?? false;
  }

  Future<double> _distanceToNotify() async {
    return (await _prefs).getDouble(keyDistanceToNotify) ?? 5.0;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait(
          [_updateRealTime(), _showNotifications(), _distanceToNotify()]),
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.hasData) {
          var updateRealTime = snapshot.data![0] as bool;
          var showNotifications = snapshot.data![1] as bool;
          var distanceToNotify = snapshot.data![2] as double;

          return AlertDialog(
              title: const Text('Opciones'),
              actionsPadding: const EdgeInsets.only(right: 18),
              backgroundColor: backgroundColor,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      padding: const EdgeInsets.only(
                        left: 8.0,
                        right: 10.0,
                        top: 8.0,
                      ),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          color: Colors.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10))),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'General',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: [
                              const Expanded(
                                  flex: 9,
                                  child: Text(
                                    'Actualizar en tiempo real',
                                  )),
                              Expanded(
                                  flex: 1,
                                  child: Switch(
                                    value: updateRealTime,
                                    onChanged: (value) async => {
                                      await (await _prefs)
                                          .setBool(keyUpdateRealTime, value),
                                      setState(
                                        () {},
                                      )
                                    },
                                  ))
                            ],
                          ),
                        ],
                      )),
                  const SizedBox(
                    height: 16,
                  ),
                  Container(
                      padding: const EdgeInsets.only(
                        left: 8.0,
                        right: 10.0,
                        top: 8.0,
                      ),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          color: Colors.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10))),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Notificaciones',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: [
                              const Expanded(
                                  flex: 9,
                                  child: Text(
                                    'Habilitar notificaciones',
                                  )),
                              Expanded(
                                flex: 1,
                                child: Switch(
                                  value: showNotifications,
                                  onChanged: (value) async => {
                                    await (await _prefs)
                                        .setBool(keyShowNotifications, value),
                                    setState(
                                      () {},
                                    )
                                  },
                                ),
                              )
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Distancia a notificar (km)'),
                              Row(
                                children: [
                                  Expanded(
                                      flex: 1, child: Text('$_minDistance')),
                                  Expanded(
                                      flex: 8,
                                      child: Slider(
                                        min: _minDistance,
                                        max: _maxDistance,
                                        label:
                                            '${distanceToNotify.toStringAsFixed(2)} km',
                                        value: distanceToNotify,
                                        onChanged: (value) async => {
                                          await (await _prefs).setDouble(
                                              keyDistanceToNotify, value),
                                          setState(
                                            () {},
                                          )
                                        },
                                      )),
                                  Expanded(
                                      flex: 1, child: Text('$_maxDistance')),
                                ],
                              )
                            ],
                          )
                        ],
                      )),
                ],
              ),
              actions: [
                TextButton(
                  style: TextButton.styleFrom(backgroundColor: Colors.white),
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  style: TextButton.styleFrom(backgroundColor: Colors.white),
                  onPressed: () => Navigator.pop(context, 'OK'),
                  child: const Text('OK'),
                ),
              ]);
        } else if (snapshot.hasError) {
          return const ErrorData(
            error: 'Error al cargar la configuracion',
          );
        }
        return const WaitingData();
      },
    );
  }
}
