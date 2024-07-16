import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FareCalculationPage extends StatefulWidget {
  @override
  _FareCalculationPageState createState() => _FareCalculationPageState();
}

class _FareCalculationPageState extends State<FareCalculationPage> {
  String selectedStartLocation = '';
  String selectedEndLocation = '';
  double fare = 0.0;

  void _calculateFare() {
    print('Selected Start Location: $selectedStartLocation');
    print('Selected End Location: $selectedEndLocation');

    // Just set the fare to 50 for demonstration purposes
    setState(() {
      fare = 50;
    });

    print('Fare: $fare');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fare Calculation'),
        foregroundColor: Colors.white,
        backgroundColor: Color.fromARGB(255, 108, 105, 105),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('routes').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  var routes = snapshot.data!.docs;

                  return Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField(
                              decoration: InputDecoration(
                                labelText: 'Start Location',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                prefixIcon: Icon(Icons.location_on),
                              ),
                              items: routes.map((route) {
                                var data = route.data() as Map<String, dynamic>;
                                return DropdownMenuItem(
                                  value: route.id,
                                  child: Text(data['startLocation'], overflow: TextOverflow.ellipsis),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedStartLocation = value as String;
                                });
                              },
                              value: selectedStartLocation.isEmpty ? null : selectedStartLocation,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField(
                              decoration: InputDecoration(
                                labelText: 'End Location',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                prefixIcon: Icon(Icons.location_on),
                              ),
                              items: routes.map((route) {
                                var data = route.data() as Map<String, dynamic>;
                                return DropdownMenuItem(
                                  value: route.id,
                                  child: Text(data['endLocation'], overflow: TextOverflow.ellipsis),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedEndLocation = value as String;
                                });
                              },
                              value: selectedEndLocation.isEmpty ? null : selectedEndLocation,
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _calculateFare,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  backgroundColor: Color.fromARGB(255, 108, 105, 105),
                  foregroundColor: Colors.white,
                ),
                child: Text(
                  'Calculate Fare',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              SizedBox(height: 40),
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Fare to be paid:',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '$fare',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 108, 105, 105)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 236, 239, 241),
    );
  }
}
