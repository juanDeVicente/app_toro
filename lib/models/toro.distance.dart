import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';

import '../utilities/flavor_config.dart';
import 'package:http/http.dart' as http;
import 'toro.dart';

class ToroDistance {
  ToroDistance(
      {required this.distance,
      required this.lat,
      required this.lon,
      required this.toro});
  ToroDistance.fromJson(Map<String, dynamic> json)
      : lat = json['lat'].toDouble(),
        lon = json['lon'].toDouble(),
        distance = json['distance'],
        toro = Toro.fromJson(json['toro']);

  Map<String, dynamic> toJson() =>
      {'lat': lat, 'lon': lon, 'distance': distance, 'toro': toro.toJson()};

  LatLng getCenter() => LatLng((lat + toro.lat) / 2, (lon + toro.lon) / 2);

  double latRad(double lat) {
    final double sin = math.sin(lat * math.pi / 180);
    final double radX2 = math.log((1 + sin) / (1 - sin)) / 2;
    return math.max(math.min(radX2, math.pi), -math.pi) / 2;
  }

  double getZoom(LatLngBounds bounds, double mapWidth, double mapHeight) {
    final LatLng northEast = bounds.northEast!;
    final LatLng southWest = bounds.southWest!;

    final double latFraction =
        (latRad(northEast.latitude) - latRad(southWest.latitude)) / math.pi;

    final double lngDiff = northEast.longitude - southWest.longitude;
    final double lngFraction =
        ((lngDiff < 0) ? (lngDiff + 360) : lngDiff) / 360;

    final double latZoom =
        (math.log(mapHeight / 256 / latFraction) / math.ln2).floorToDouble();
    final double lngZoom =
        (math.log(mapWidth / 256 / lngFraction) / math.ln2).floorToDouble();

    return math.min(latZoom, lngZoom);
  }

  final double distance;
  final double lat;
  final double lon;
  final Toro toro;
}

Future<ToroDistance?> getNearestToro(double lat, double lon) async {
  var apiUrl =
      '${FlavorConfig.instance.values.baseUrl}/toro/distance?lat=$lat&lon=$lon';

  try {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      var toroDistance = ToroDistance.fromJson(json.decode(response.body));
      return toroDistance;
    }
  } catch (e) {
    rethrow;
  }

  return null;
}
