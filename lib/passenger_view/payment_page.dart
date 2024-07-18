import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fare_payment_system/components/my_button.dart';
import 'package:fare_payment_system/components/my_textfield.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:fare_payment_system/controllers/mpesa_service.dart';
import 'package:fare_payment_system/components/constants.dart';
import 'package:uuid/uuid.dart';
import 'thank_you_page.dart';

class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final MpesaService _mpesaService = MpesaService();
  String selectedMatatuId = '';
  String selectedMatatuName = '';
  String selectedStartLocation = '';
  String selectedEndLocation = '';
  bool isLoading = false;
  List<LatLng> routePoints = [];

  @override
  void dispose() {
    amountController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  Future<void> _initiatePayment() async {
    final phoneNumber = phoneController.text.trim();
    final amount = amountController.text.trim();

    if (phoneNumber.isEmpty || amount.isEmpty || selectedMatatuId.isEmpty || selectedStartLocation.isEmpty || selectedEndLocation.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a phone number, amount, and select a matatu, start location, and end location')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      print('Initiating payment...');
      print('Phone number: $phoneNumber');
      print('Amount: $amount');
      print('Matatu: $selectedMatatuName');
      print('Start Location: $selectedStartLocation');
      print('End Location: $selectedEndLocation');

      String result = await _mpesaService.initiateStkPush(
        phoneNumber,
        amount,
        Constants.accountref,
        Constants.transactionDesc,
      );

      // Generate receipt number and transaction date
      String receiptNumber = Uuid().v4();
      DateTime transactionDate = DateTime.now();

      await FirebaseFirestore.instance.collection('transactions').add({
        'phoneNumber': phoneNumber,
        'amount': amount,
        'matatuId': selectedMatatuId,
        'matatuName': selectedMatatuName,
        'startLocation': selectedStartLocation,
        'endLocation': selectedEndLocation,
        'transactionDate': transactionDate,
        'receiptNumber': receiptNumber,
        'timestamp': FieldValue.serverTimestamp(),
      });

      print('STK push result: $result');

      // Listen for payment confirmation
      _listenForPaymentConfirmation(result);
    } catch (error) {
      print('Error initiating payment: $error');
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error initiating payment: $error')),
      );
    }
  }

  void _listenForPaymentConfirmation(String transactionId) {
    Future.delayed(Duration(seconds: 5), () {
      setState(() {
        isLoading = false;
      });

      // Navigate to ThankYouPage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ThankYouPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Page'),
        foregroundColor: Colors.white,
        backgroundColor: Color.fromARGB(255, 108, 105, 105),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('matatus').snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }

                      var matatus = snapshot.data!.docs;

                      return Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField(
                              decoration: InputDecoration(
                                labelText: 'Select Matatu',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                prefixIcon: Icon(Icons.directions_bus),
                              ),
                              items: matatus.map((matatu) {
                                return DropdownMenuItem(
                                  value: matatu.id,
                                  child: Text(matatu['name'], overflow: TextOverflow.ellipsis),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedMatatuId = value as String;
                                  selectedMatatuName = matatus.firstWhere((matatu) => matatu.id == selectedMatatuId)['name'];
                                });
                              },
                              value: selectedMatatuId.isEmpty ? null : selectedMatatuId,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  SizedBox(height: 20),
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
                                  items: routes.where((route) {
                                    var data = route.data() as Map<String, dynamic>;
                                    return data.containsKey('startLocation');
                                  }).map((route) {
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
                                  items: routes.where((route) {
                                    var data = route.data() as Map<String, dynamic>;
                                    return data.containsKey('endLocation');
                                  }).map((route) {
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
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  MyTextfield(
                    controller: amountController,
                    hintText: 'Amount',
                    obscureTest: false,
                  ),
                  SizedBox(height: 20),
                  MyTextfield(
                    controller: phoneController,
                    hintText: 'Phone Number',
                    obscureTest: false,
                  ),
                  SizedBox(height: 20),
                  MyButton(
                    onTap: _initiatePayment,
                    text: 'Initiate Payment',
                  ),
                  SizedBox(height: 20),
                  if (routePoints.isNotEmpty)
                    SizedBox(
                      height: 300,
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
          if (isLoading)
            Container( 
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 236, 239, 241),
    );
  }
}
