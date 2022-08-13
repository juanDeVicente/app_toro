import 'dart:typed_data';

import 'package:app_toro/models/toro.distance.dart';
import 'package:app_toro/parts/error.data.dart';
import 'package:app_toro/parts/waiting.data.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math';

import '../parts/app.bar.dart';
import '../parts/drawer.dart';
import '../utilities/file.dart';

class TorosDistanceRoute extends StatefulWidget {
  const TorosDistanceRoute({Key? key}) : super(key: key);

  @override
  State<TorosDistanceRoute> createState() {
    return _TorosDistanceRouteState();
  }
}

class _TorosDistanceRouteState extends State<TorosDistanceRoute> {
  late GoogleMapController mapController;

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
                return FutureBuilder(
                  future: getBytesFromAsset(path: 'assets/bull.png', width: 72),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var bytes = snapshot.data as Uint8List;
                      BitmapDescriptor markerbitmap =
                          BitmapDescriptor.fromBytes(bytes);
                      var points = [
                        LatLng(toroDistance.lat, toroDistance.lon),
                        LatLng(toroDistance.toro.lat, toroDistance.toro.lon)
                      ];
                      final highestLat =
                          points.map((e) => e.latitude).reduce(max);
                      final highestLong =
                          points.map((e) => e.longitude).reduce(max);
                      final lowestLat =
                          points.map((e) => e.latitude).reduce(min);
                      final lowestLong =
                          points.map((e) => e.longitude).reduce(min);
                      final lowestLatLowestLong = LatLng(lowestLat, lowestLong);
                      final highestLatHighestLong =
                          LatLng(highestLat, highestLong);
                      final Map<String, Marker> markers = {};
                      markers['user'] = Marker(
                          markerId: const MarkerId('Me'),
                          position:
                              LatLng(position.latitude, position.longitude));
                      markers['toro'] =
                          toroDistance.toro.toMarker(markerbitmap);
                      var center = toroDistance.getCenter();

                      var zoom = toroDistance.getZoom(
                          LatLngBounds(
                              southwest: lowestLatLowestLong,
                              northeast: highestLatHighestLong),
                          256,
                          256);
                      return GoogleMap(
                        zoomGesturesEnabled: false,
                        scrollGesturesEnabled: false,
                        tiltGesturesEnabled: false,
                        rotateGesturesEnabled: false,
                        zoomControlsEnabled: false,
                        initialCameraPosition: CameraPosition(
                          target: center,
                          zoom: zoom,
                        ),
                        markers: markers.values.toSet(),
                      );
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
                  error: 'Cannot get nearest toro',
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
