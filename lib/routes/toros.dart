import 'package:app_toro/models/toro.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../parts/app.bar.dart';
import '../parts/drawer.dart';
import '../utilities/file.dart';

class TorosRoute extends StatefulWidget {
  const TorosRoute({Key? key}) : super(key: key);

  @override
  State<TorosRoute> createState() {
    return _TorosRouteState();
  }
}

class _TorosRouteState extends State<TorosRoute> {
  final Map<String, Marker> _markers = {};
  final LatLng _center = const LatLng(40.463667, -3.74922);

  Future<void> _onMapCreated(GoogleMapController controller) async {
    final toros = await getToros();
    BitmapDescriptor markerbitmap = BitmapDescriptor.fromBytes(
        await getBytesFromAsset(path: 'assets/bull.png', width: 72));
    setState(() {
      _markers.clear();
      for (final toro in toros) {
        final marker = Marker(
            markerId: MarkerId(toro.name),
            position: LatLng(toro.lat, toro.lon),
            infoWindow: InfoWindow(title: toro.name, snippet: toro.comunidad),
            icon: markerbitmap);
        _markers[toro.name] = marker;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const ToroDrawer(),
        appBar: const ToroAppBar(),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          zoomGesturesEnabled: false,
          scrollGesturesEnabled: false,
          tiltGesturesEnabled: false,
          rotateGesturesEnabled: false,
          zoomControlsEnabled: false,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 5.7,
          ),
          markers: _markers.values.toSet(),
        ));
  }
}
