import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final user = FirebaseAuth.instance.currentUser;

  // Sign User Out Method
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[45],
        title: Text('FareFlow',
        style: TextStyle(
          fontSize: 35,
          fontWeight: FontWeight.bold
        ),
        ),
        actions: [
          IconButton(
            onPressed: signUserOut,
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16.0),
        children: [
          buildGridItem(context, 'Routes', Icons.map, RoutesPage()),
          buildGridItem(context, 'Select Seat', Icons.event_seat, SelectSeatPage()),
          buildGridItem(context, 'Fare Calculation', Icons.calculate, FareCalculationPage()),
          buildGridItem(context, 'Payment', Icons.payment, PaymentPage()),
          buildGridItem(context, 'Customer Support', Icons.support_agent, CustomerSupportPage()),
        ],
      ),
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
        margin: EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 50.0),
              SizedBox(height: 10.0),
              Text(title, style: TextStyle(fontSize: 16.0)),
            ],
          ),
        ),
      ),
    );
  }
}

class RoutesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Routes')),
      body: Center(child: Text('Routes Page')),
    );
  }
}

class SelectSeatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Seat')),
      body: Center(child: Text('Select Seat Page')),
    );
  }
}

class FareCalculationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Fare Calculation')),
      body: Center(child: Text('Fare Calculation Page')),
    );
  }
}

class PaymentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Payment')),
      body: Center(child: Text('Payment Page')),
    );
  }
}

class CustomerSupportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Customer Support')),
      body: Center(child: Text('Customer Support Page')),
    );
  }
}
