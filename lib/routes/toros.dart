import 'package:app_toro/models/toro.dart';
import 'package:app_toro/parts/error.data.dart';
import 'package:app_toro/parts/waiting.data.dart';
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

  Future<void> _onMapCreated(
      GoogleMapController controller, List<Toro> toros) async {
    BitmapDescriptor markerbitmap = BitmapDescriptor.fromBytes(
        await getBytesFromAsset(path: 'assets/bull.png', width: 72));
    setState(() {
      _markers.clear();
      for (final toro in toros) {
        _markers[toro.name] = toro.toMarker(markerbitmap);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const ToroDrawer(),
        appBar: const ToroAppBar(),
        body: FutureBuilder<List<Toro>>(
            future: getToros(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return GoogleMap(
                  onMapCreated: (controller) =>
                      _onMapCreated(controller, snapshot.data!),
                  initialCameraPosition: CameraPosition(
                    target: _center,
                    zoom: 5.4,
                  ),
                  markers: _markers.values.toSet(),
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
