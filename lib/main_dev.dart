import 'package:app_toro/toro.app.dart';
import 'package:app_toro/utilities/flavor_config.dart';
import 'package:flutter/material.dart';

void main() {
  FlavorConfig(
      flavor: Flavor.PRODUCTION,
      values: FlavorValues(baseUrl: "http://192.168.50.254:8080"));

  runApp(const ToroApp());
}
