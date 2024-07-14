
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

class RouteService {
  final String apiKey;

  RouteService({required this.apiKey});

  Future<Map<String, dynamic>> fetchRoute(String startLocation, String endLocation) async {
    final Uri url = Uri.parse(
        'https://maps.googleapis.com/maps/api/directions/json?origin=$startLocation&destination=$endLocation&key=$apiKey');

    final http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'OK') {
        return data;
      } else {
        throw Exception('Failed to fetch route: ${data['status']}');
      }
    } else {
      throw Exception('Failed to fetch route');
    }
  }

  Future<void> saveRouteToFirestore(Map<String, dynamic> routeData, String routeName, String routeNumber) async {
    final routesCollection = FirebaseFirestore.instance.collection('routes');
    
    await routesCollection.add({
      'routeName': routeName,
      'routeNumber': routeNumber,
      'startLocation': routeData['routes'][0]['legs'][0]['start_location'],
      'endLocation': routeData['routes'][0]['legs'][0]['end_location'],
      'overviewPolyline': routeData['routes'][0]['overview_polyline']['points'],
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
