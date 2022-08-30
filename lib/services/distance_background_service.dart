import 'dart:async';
import 'dart:ui';

import 'package:app_toro/models/toro.distance.dart';
import 'package:app_toro/utilities/constants.dart';
import 'package:app_toro/utilities/flavor_config.dart';
import 'package:app_toro/utilities/notification_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

void initializeService() async {
  var prefs = await SharedPreferences.getInstance();
  var sendNotifiactions = prefs.getBool(keyShowNotifications) ?? false;
  if (sendNotifiactions) {
    await prefs.setString('base_url', FlavorConfig.instance.values.baseUrl);
    await initialize();
    startService();
  } else {
    _service?.invoke('stopService');
  }
}

FlutterBackgroundService? _service;

void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  var isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
  if (isLocationServiceEnabled) {
    var locationPermission = await Geolocator.checkPermission();
    if (locationPermission != LocationPermission.denied &&
        locationPermission != LocationPermission.deniedForever) {
      Timer.periodic(const Duration(seconds: 1), (timer) async {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        FlavorConfig(
            flavor: Flavor.service,
            values: FlavorValues(baseUrl: preferences.getString('base_url')!));
        var lastToroSeen = preferences.getString('last_toro_seen') ?? '';
        var distanceToCheck = preferences.getDouble(keyDistanceToNotify) ?? 5;
        var position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);

        var nearestToro =
            await getNearestToro(position.latitude, position.longitude);
        print(
            'Distancia a toro ${nearestToro!.toro.name} es ${nearestToro.distance}');
        if (nearestToro!.distance <= distanceToCheck &&
            nearestToro.toro.name != lastToroSeen) {
          await preferences.setString('last_toro_seen', nearestToro.toro.name);
          showNotification('¡Un toro se encuentra cerca!',
              'El ${nearestToro.toro.name} está a menos de $distanceToCheck kilómetros');
        }
      });
    }
  }
}

Future<void> initialize() async {
  _service = FlutterBackgroundService();
  await _service!.configure(
      androidConfiguration: AndroidConfiguration(
        // this will be executed when app is in foreground or background in separated isolate
        onStart: onStart,

        // auto start service
        autoStart: false,
        isForegroundMode: false,
      ),
      iosConfiguration: IosConfiguration(
        // auto start service
        autoStart: false,

        // this will be executed when app is in foreground in separated isolate
        onForeground: onStart,

        // you have to enable background fetch capability on xcode project
        onBackground: onIosBackground,
      ));
}

void startService() => _service?.startService();

bool onIosBackground(ServiceInstance service) {
  WidgetsFlutterBinding.ensureInitialized();
  print('FLUTTER BACKGROUND FETCH');

  return true;
}
