import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';

class ViewRoutesPage extends StatelessWidget {
  const ViewRoutesPage({super.key});

  Future<List<Polyline>> _fetchRoutes() async {
    List<Polyline> polylines = [];
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('routes').get();

    for (var doc in snapshot.docs) {
      List<LatLng> points = (doc['routePoints'] as List)
          .map((point) => LatLng(point['latitude'], point['longitude']))
          .toList();

      polylines.add(Polyline(
        points: points,
        color: Colors.blue,
        strokeWidth: 4,
      ));
    }

    return polylines;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Routes'),
      ),
      body: FutureBuilder<List<Polyline>>(
        future: _fetchRoutes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading routes'));
          } else {
            return FlutterMap(
              options: const MapOptions(
                initialCenter: LatLng(-1.2921, 36.8219),
                initialZoom: 13,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.farePaymentSystem',
                ),
                PolylineLayer(polylines: snapshot.data!),
              ],
            );
          }
        },
      ),
    );
  }
}
