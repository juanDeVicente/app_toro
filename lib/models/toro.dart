import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_svg/svg.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

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

  Marker toMarker() {
    return Marker(
        point: LatLng(lat, lon),
        width: 32,
        height: 32,
        builder: (context) => SvgPicture.asset('assets/bull.svg',
            width: 24,
            height: 24,
            color: Colors.black,
            semanticsLabel: 'A bull'));
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
    rethrow;
  }

  return List.empty();
}
