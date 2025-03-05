import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FareCalculationPage extends StatefulWidget {
  const FareCalculationPage({super.key});

  @override
  _FareCalculationPageState createState() => _FareCalculationPageState();
}

class _FareCalculationPageState extends State<FareCalculationPage> {
  String selectedStartLocation = '';
  String selectedEndLocation = '';
  double fare = 0.0;

  void _calculateFare() {
    if (selectedStartLocation.isEmpty || selectedEndLocation.isEmpty) {
      // Show an alert dialog if either location is not selected
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Please select both start and end locations.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    print('Selected Start Location: $selectedStartLocation');
    print('Selected End Location: $selectedEndLocation');

    // For demonstration purposes, set the fare to 50
    setState(() {
      fare = 50.0;
    });

    print('Fare: $fare');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fare Calculation'),
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 108, 105, 105),
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
                    return const Center(child: CircularProgressIndicator());
                  }

                  var routes = snapshot.data!.docs;

                  return Column(
                    children: [
                      DropdownButtonFormField(
                        decoration: InputDecoration(
                          labelText: 'Start Location',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          prefixIcon: const Icon(Icons.location_on),
                        ),
                        items: routes.map((route) {
                          var data = route.data() as Map<String, dynamic>;
                          return DropdownMenuItem(
                            value: data['startLocation'],
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
                      const SizedBox(height: 20),
                      DropdownButtonFormField(
                        decoration: InputDecoration(
                          labelText: 'End Location',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          prefixIcon: const Icon(Icons.location_on),
                        ),
                        items: routes.map((route) {
                          var data = route.data() as Map<String, dynamic>;
                          return DropdownMenuItem(
                            value: data['endLocation'],
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
                    ],
                  );
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _calculateFare,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  backgroundColor: const Color.fromARGB(255, 108, 105, 105),
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  'Calculate Fare',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 40),
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        'Fare to be paid:',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '$fare',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 108, 105, 105),
                        ),
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
