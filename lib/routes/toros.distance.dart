import 'package:app_toro/models/toro.distance.dart';
import 'package:app_toro/parts/error.data.dart';
import 'package:app_toro/parts/waiting.data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'dart:math';

import '../parts/app.bar.dart';
import '../parts/drawer.dart';

class TorosDistanceRoute extends StatefulWidget {
  const TorosDistanceRoute({Key? key}) : super(key: key);

  @override
  State<TorosDistanceRoute> createState() {
    return _TorosDistanceRouteState();
  }
}

class _TorosDistanceRouteState extends State<TorosDistanceRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const ToroDrawer(),
        appBar: const ToroAppBar(),
        body: FutureBuilder(
            future: Geolocator.isLocationServiceEnabled(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var isLocationEnabled = snapshot.data as bool;
                if (isLocationEnabled) {
                  return FutureBuilder(
                      future: Geolocator.checkPermission(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var permission = snapshot.data as LocationPermission;
                          if (permission == LocationPermission.denied) {
                            return FutureBuilder(
                              future: Geolocator.requestPermission(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  permission =
                                      snapshot.data as LocationPermission;
                                  if (permission == LocationPermission.denied ||
                                      permission ==
                                          LocationPermission.deniedForever) {
                                    return const ErrorData(
                                      error: "GPS permission denied",
                                    );
                                  } else {
                                    return const DistanceToroWidget();
                                  }
                                } else if (snapshot.hasError) {
                                  return const ErrorData(
                                    error: 'Unknown error',
                                  );
                                } else {
                                  return const WaitingData();
                                }
                              },
                            );
                          } else if (permission ==
                              LocationPermission.deniedForever) {
                            return const ErrorData(error: "GPS is not enabled");
                          }
                          return const DistanceToroWidget();
                        } else if (snapshot.hasError) {
                          return const ErrorData(error: "GPS is not enabled");
                        } else {
                          return const WaitingData();
                        }
                      });
                }
                return const ErrorData(error: "GPS is not enabled");
              } else if (snapshot.hasError) {
                return const ErrorData(error: "Unknown error");
              } else {
                return const WaitingData();
              }
            }));
  }
}

class DistanceToroWidget extends StatelessWidget {
  const DistanceToroWidget({Key? key}) : super(key: key);
  final Color backgroundColor = Colors.white;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future:
          Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Position position = snapshot.data as Position;
          return FutureBuilder(
            future: getNearestToro(position.latitude, position.longitude),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var toroDistance = snapshot.data as ToroDistance;
                var points = [
                  LatLng(toroDistance.lat, toroDistance.lon),
                  LatLng(toroDistance.toro.lat, toroDistance.toro.lon)
                ];
                final highestLat = points.map((e) => e.latitude).reduce(max);
                final highestLong = points.map((e) => e.longitude).reduce(max);
                final lowestLat = points.map((e) => e.latitude).reduce(min);
                final lowestLong = points.map((e) => e.longitude).reduce(min);
                final lowestLatLowestLong = LatLng(lowestLat, lowestLong);
                final highestLatHighestLong = LatLng(highestLat, highestLong);
                final Map<String, Marker> markers = {};
                markers['user'] = Marker(
                  width: 24,
                  height: 24,
                  point: LatLng(position.latitude, position.longitude),
                  builder: (context) =>
                      const Icon(Icons.person, color: Colors.black),
                );
                markers['toro'] = toroDistance.toro.toMarker();
                var center = toroDistance.getCenter();

                var zoom = toroDistance.getZoom(
                    LatLngBounds(lowestLatLowestLong, highestLatHighestLong),
                    MediaQuery.of(context).size.width,
                    MediaQuery.of(context).size.height);
                final Set<Polyline> polyline = {};

                polyline.add(
                  Polyline(
                      points: points,
                      color: Colors.black,
                      borderColor: null,
                      borderStrokeWidth: 1),
                );

                return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                            textAlign: TextAlign.center,
                            'El toro más cercano está a ${toroDistance.distance.toInt()} kilómetros'),
                      ),
                      Expanded(
                          child: FlutterMap(
                        options: MapOptions(
                            center: center,
                            zoom: zoom,
                            maxBounds: LatLngBounds(
                                LatLng(-90, -180.0), LatLng(90.0, 180.0))),
                        layers: [
                          TileLayerOptions(
                              urlTemplate:
                                  'http://mt{s}.google.com/vt/lyrs=m@221097413,lyrs=m&x={x}&y={y}&z={z}',
                              subdomains: ['0', '1', '2', '3'],
                              userAgentPackageName: 'com.example.app',
                              retinaMode: true),
                          PolylineLayerOptions(polylines: polyline.toList()),
                          MarkerLayerOptions(markers: markers.values.toList()),
                        ],
                      ))
                    ]);
              } else if (snapshot.hasError) {
                return const ErrorData(
                  error: 'Error retrieving bull image',
                );
              } else {
                return const WaitingData();
              }
            },
          );
        } else if (snapshot.hasError) {
          return const ErrorData(
            error: "Cannot get current position",
          );
        } else {
          return const WaitingData();
        }
      },
    );
  }
}
