import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:http/http.dart' as http;

import '../utilities/flavor_config.dart';

@JsonSerializable()
class Toro {
  Toro(
      {required this.lat,
      required this.lon,
      required this.name,
      required this.comunidad});

  Toro.fromJson(Map<String, dynamic> json)
      : lat = double.parse(json['lat']),
        lon = double.parse(json['lon']),
        name = json['name'],
        comunidad = json['comunidad'];

  Map<String, dynamic> toJson() =>
      {'lat': lat, 'lon': lon, 'name': name, 'comunidad': comunidad};

  Marker toMarker(BitmapDescriptor descriptor) {
    return Marker(
        markerId: MarkerId(name),
        position: LatLng(lat, lon),
        infoWindow: InfoWindow(title: name, snippet: comunidad),
        icon: descriptor);
  }

  final double lat;
  final double lon;
  final String name;
  final String comunidad;
}

Future<List<Toro>> getToros() async {
  var apiUrl = '${FlavorConfig.instance.values.baseUrl}/toro';

  try {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      var torosList = List<Toro>.empty(growable: true);
      var toros = json.decode(response.body)['toros'];
      for (var toro in toros) {
        torosList.add(Toro(
            lat: double.parse(toro['lat']),
            lon: double.parse(toro['lon']),
            name: toro['name'],
            comunidad: toro['comunidad']));
      }
      return torosList;
    }
  } catch (e) {
    print(e);
  }

  return List.empty();
}
