import 'package:app_toro/models/toro.dart';
import 'package:app_toro/models/toro.distance.dart';
import 'package:latlong2/latlong.dart';
// ignore: depend_on_referenced_packages
import 'package:test/test.dart';
import 'package:http/http.dart' as http;
// ignore: depend_on_referenced_packages
import 'package:mockito/annotations.dart';

@GenerateMocks([http.Client])
void main() {
  group('Get center', () {
    const String toroName = 'Testing toro';
    const String toroComunidad = 'Testing comunidad';

    var expectedResult = {
      ToroDistance(
          distance: 10,
          lat: 0,
          lon: 0,
          toro: Toro(
              lat: 0,
              lon: 0,
              name: 'Testing toro',
              comunidad: 'Testing comunidad')): LatLng(0, 0),
      ToroDistance(
          distance: 0,
          lat: 10,
          lon: 10,
          toro: Toro(
              lat: 0,
              lon: 0,
              name: toroName,
              comunidad: toroComunidad)): LatLng(5, 5),
      ToroDistance(
          distance: 0,
          lat: -10,
          lon: -10,
          toro: Toro(
              lat: 0,
              lon: 0,
              name: toroName,
              comunidad: toroComunidad)): LatLng(-5, -5),
      ToroDistance(
          distance: 0,
          lat: -2.5,
          lon: -2.5,
          toro: Toro(
              lat: 2.5,
              lon: 2.5,
              name: toroName,
              comunidad: toroComunidad)): LatLng(0, 0),
      ToroDistance(
          distance: 0,
          lat: 2.5,
          lon: 2.5,
          toro: Toro(
              lat: 2.5,
              lon: 2.5,
              name: toroName,
              comunidad: toroComunidad)): LatLng(2.5, 2.5)
    };

    expectedResult.forEach((input, expected) {
      test(
          "latitude1: ${input.lat}, latitude2: ${input.toro.lat}, longitude1: ${input.lon}, longitude2: ${input.toro.lon} -> expected center (${expected.latitude}, ${expected.longitude})",
          (() {
        expect(input.getCenter().latitude, expected.latitude);
        expect(input.getCenter().longitude, expected.longitude);
      }));
    });
  });
  group('Get distance', () {});
}
