import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fare_payment_system/components/my_textfield.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fare_payment_system/passenger_view/view_routes_page.dart';


class CreateRoutePage extends StatefulWidget {
  const CreateRoutePage({super.key});

  @override
  State<CreateRoutePage> createState() => _CreateRoutesPageState();
}

class _CreateRoutesPageState extends State<CreateRoutePage> {
  final start = TextEditingController();
  final end = TextEditingController();
  bool isVisible = false;
  List<LatLng> routePoints = [LatLng(-1.2921, 36.8219)];

  @override
  void dispose() {
    start.dispose();
    end.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Routing', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
         backgroundColor: const Color.fromARGB(255, 108, 105, 105),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                MyTextfield(
                  controller: start,
                  hintText: 'Enter start location',
                  obscureTest: false,
                ),
                const SizedBox(height: 20),
                MyTextfield(
                  controller: end,
                  hintText: 'Enter end location',
                  obscureTest: false,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      print('Button pressed');
                      List<Location> startLocations = await locationFromAddress(start.text);
                      List<Location> endLocations = await locationFromAddress(end.text);

                      if (startLocations.isEmpty || endLocations.isEmpty) {
                        print('Could not find locations');
                        return;
                      }

                      var v1 = startLocations[0].latitude;
                      var v2 = startLocations[0].longitude;
                      var v3 = endLocations[0].latitude;
                      var v4 = endLocations[0].longitude;

                      var url = Uri.parse('http://router.project-osrm.org/route/v1/driving/$v2,$v1;$v4,$v3?steps=true&annotations=true&geometries=geojson&overview=full');
                      var response = await http.get(url);

                      if (!mounted) return;

                      if (response.statusCode == 200) {
                        setState(() {
                          routePoints = [];
                          var router = jsonDecode(response.body)['routes'][0]['geometry']['coordinates'];
                          for (var point in router) {
                            routePoints.add(LatLng(point[1], point[0]));
                          }
                          isVisible = true;
                        });

                        // Save route points to Firestore
                        await FirebaseFirestore.instance.collection('routes').add({
                          'startLocation': start.text,
                          'endLocation': end.text,
                          'routePoints': routePoints.map((point) => {'latitude': point.latitude, 'longitude': point.longitude}).toList(),
                          'createdAt': FieldValue.serverTimestamp(),
                        });

                        print('Route saved to Firestore');
                      } else {
                        print('Failed to get route: ${response.body}');
                      }
                    } catch (e) {
                      print('Error occurred: $e');
                    }
                  },
                  child: const Text('Press'),
                ),
                const SizedBox(height: 20),
                if (isVisible)
                  SizedBox(
                    height: 500,
                    width: double.infinity,
                    child: FlutterMap(
                      options: MapOptions(
                        initialCenter: routePoints.isNotEmpty ? routePoints[0] : LatLng(-1.2921, 36.8219),
                        initialZoom: 14,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.example.farePaymentSystem',
                        ),
                        PolylineLayer(
                          polylines: [
                            Polyline(points: routePoints, color: Colors.blue, strokeWidth: 4),
                          ],
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
