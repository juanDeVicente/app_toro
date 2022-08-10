import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const ToroDrawer(),
        appBar: const ToroAppBar(),
        body: GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 11.0,
            )));
  }
}
