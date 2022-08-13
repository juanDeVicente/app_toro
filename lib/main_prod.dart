import 'package:app_toro/toro.app.dart';
import 'package:app_toro/utilities/flavor_config.dart';
import 'package:flutter/material.dart';

void main() {
  FlavorConfig(
      flavor: Flavor.PRODUCTION,
      values: FlavorValues(baseUrl: "https://api-toro.herokuapp.com"));

  runApp(const ToroApp());
}
