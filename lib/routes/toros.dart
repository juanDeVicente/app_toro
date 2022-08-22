import 'package:app_toro/models/toro.dart';
import 'package:app_toro/parts/error.data.dart';
import 'package:app_toro/parts/waiting.data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import "package:latlong2/latlong.dart";

import '../parts/app.bar.dart';
import '../parts/drawer.dart';

class TorosRoute extends StatefulWidget {
  const TorosRoute({Key? key}) : super(key: key);

  @override
  State<TorosRoute> createState() {
    return _TorosRouteState();
  }
}

class _TorosRouteState extends State<TorosRoute> {
  final LatLng _center = LatLng(40.463667, -3.74922);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const ToroDrawer(),
        appBar: const ToroAppBar(),
        body: FutureBuilder<List<Toro>>(
            future: getToros(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return FlutterMap(
                  options: MapOptions(
                      center: _center,
                      zoom: 5.4,
                      maxBounds: LatLngBounds(
                          LatLng(-90, -180.0), LatLng(90.0, 180.0))),
                  layers: [
                    TileLayerOptions(
                        urlTemplate:
                            'http://mt{s}.google.com/vt/lyrs=m@221097413,lyrs=m&x={x}&y={y}&z={z}',
                        subdomains: ['0', '1', '2', '3'],
                        userAgentPackageName: 'com.example.app',
                        retinaMode: true),
                    MarkerLayerOptions(
                        markers:
                            snapshot.data!.map((e) => e.toMarker()).toList())
                  ],
                );
              } else if (snapshot.hasError) {
                return ErrorData(
                  error: snapshot.error.toString(),
                );
              } else {
                return const WaitingData();
              }
            }));
  }
}
