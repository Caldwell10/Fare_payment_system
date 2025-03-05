import 'package:fare_payment_system/passenger_view/payment_page.dart';
import 'package:fare_payment_system/passenger_view/view_routes_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../passenger_view/customer_support_page.dart';
import '../passenger_view/fare_calculation_page.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key, required this.phoneNumber});

  final String phoneNumber;
  final user = FirebaseAuth.instance.currentUser;

  // Sign User Out Method
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    // Get the phone number of the logged-in user
    final phoneNumber = user?.phoneNumber ?? '';
    print('HomePage initialized with phone number: $phoneNumber');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 108, 105, 105),
        title: const Text(
          'Farely',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: signUserOut,
            icon: const Icon(Icons.logout, color: Colors.white),
          ),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16.0),
        children: [
          buildGridItem(context, 'Routes', Icons.map, const ViewRoutesPage()),
          buildGridItem(context, 'Fare Calculation', Icons.calculate, const FareCalculationPage()),
          buildGridItem(context, 'Payment', Icons.payment, const PaymentPage()),
          buildGridItem(context, 'Customer Support', Icons.support_agent, CustomerSupportPage(phoneNumber: phoneNumber)),
        ],
      ),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget buildGridItem(BuildContext context, String title, IconData icon, Widget destinationPage) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destinationPage),
        );
      },
      child: Card(
        elevation: 5.0,
        margin: const EdgeInsets.all(10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color.fromARGB(255, 108, 105, 105), Color.fromARGB(255, 108, 105, 105)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 50.0, color: Colors.white),
                const SizedBox(height: 10.0),
                Text(
                  title,
                  style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
