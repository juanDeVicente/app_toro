import 'package:app_toro/services/distance_background_service.dart';
import 'package:app_toro/toro.app.dart';
import 'package:app_toro/utilities/flavor_config.dart';
import 'package:app_toro/utilities/notification_config.dart';
import 'package:flutter/material.dart';

void main() {
  FlavorConfig(
      flavor: Flavor.dev,
      values: FlavorValues(baseUrl: "http://192.168.50.254:8080"));

  NotificationConfig.config();

  initializeService();

  runApp(const ToroApp());
}
