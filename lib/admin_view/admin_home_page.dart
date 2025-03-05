import 'package:flutter/material.dart';
import 'package:fare_payment_system/admin_view/create_route_page.dart';
import 'package:fare_payment_system/admin_view/view_analytics_page.dart';
import 'package:fare_payment_system/admin_view/view_ticket_page.dart';
import 'package:fare_payment_system/admin_view/create_matatu_page.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Farely'),
         foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 108, 105, 105),
          
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16.0),
        children: [
          buildGridItem(context, 'View Analytics', Icons.analytics, const ViewAnalyticsPage()),
          buildGridItem(context, 'View Tickets', Icons.support_agent, const ViewTicketPage()),
          buildGridItem(context, 'Create Route', Icons.route, const CreateRoutePage()),
          buildGridItem(context, 'Create Matatu', Icons.bus_alert_outlined, const CreateMatatuPage()),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 236, 239, 241), // Background color to contrast with the cards
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
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color.fromARGB(255, 108, 105, 105), Color.fromARGB(255, 108, 105, 105)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(15.0),
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
