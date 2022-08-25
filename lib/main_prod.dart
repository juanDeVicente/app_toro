import 'package:app_toro/toro.app.dart';
import 'package:app_toro/utilities/flavor_config.dart';
import 'package:app_toro/utilities/notification_config.dart';
import 'package:flutter/material.dart';

void main() {
  FlavorConfig(
      flavor: Flavor.prod,
      values: FlavorValues(baseUrl: "https://api-toro.herokuapp.com"));

  NotificationConfig.config();

  runApp(const ToroApp());
}
