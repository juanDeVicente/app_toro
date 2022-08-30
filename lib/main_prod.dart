import 'package:app_toro/services/distance_background_service.dart';
import 'package:app_toro/toro.app.dart';
import 'package:app_toro/utilities/flavor_config.dart';
import 'package:app_toro/utilities/notification_config.dart';
import 'package:flutter/material.dart';

void main() async {
  FlavorConfig(
      flavor: Flavor.prod,
      values: FlavorValues(baseUrl: "https://api-toro.herokuapp.com"));

  NotificationConfig.config();

  initializeService();

  runApp(const ToroApp());
}
