import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewAnalyticsPage extends StatelessWidget {
  const ViewAnalyticsPage({super.key});

  Future<Map<String, dynamic>> _fetchAnalytics() async {
    // Fetch transactions
    QuerySnapshot transactionsSnapshot = await FirebaseFirestore.instance.collection('transactions').get();
    Map<String, dynamic> transactionsPerMatatu = {};

    for (var doc in transactionsSnapshot.docs) {
      var data = doc.data() as Map<String, dynamic>;
      String matatuId = data['matatuId'];
      double amount = double.tryParse(data['amount'].toString()) ?? 0.0;
      String phoneNumber = data['phoneNumber'] ?? 'Unknown';
      Timestamp timestamp = data['timestamp'] ?? Timestamp.now();

      if (transactionsPerMatatu.containsKey(matatuId)) {
        transactionsPerMatatu[matatuId]['count'] += 1;
        transactionsPerMatatu[matatuId]['totalAmount'] += amount;
        transactionsPerMatatu[matatuId]['transactions'].add({
          'phoneNumber': phoneNumber,
          'timestamp': timestamp,
        });
      } else {
        transactionsPerMatatu[matatuId] = {
          'count': 1,
          'totalAmount': amount,
          'transactions': [
            {
              'phoneNumber': phoneNumber,
              'timestamp': timestamp,
            }
          ],
        };
      }
    }

    // Fetch users
    QuerySnapshot usersSnapshot = await FirebaseFirestore.instance.collection('users').get();
    int totalUsers = usersSnapshot.docs.length;

    return {
      'transactionsPerMatatu': transactionsPerMatatu,
      'totalUsers': totalUsers,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Analytics'),
        backgroundColor: const Color.fromARGB(255, 108, 105, 105),
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchAnalytics(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No data available'));
          }

          var analytics = snapshot.data!;
          var transactionsPerMatatu = analytics['transactionsPerMatatu'] as Map<String, dynamic>;
          var totalUsers = analytics['totalUsers'] as int;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Analytics Overview',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
             
                ),
                SizedBox(height: 20),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Icon(Icons.person, size: 40, color: Colors.orange),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total Users Registered',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '$totalUsers',
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Icon(Icons.directions_bus, size: 40, color: Colors.blue),
                        SizedBox(width: 10),
                        Text(
                          'Transactions per Matatu',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: transactionsPerMatatu.length,
                    itemBuilder: (context, index) {
                      String matatuId = transactionsPerMatatu.keys.elementAt(index);
                      int transactionCount = transactionsPerMatatu[matatuId]['count'];
                      double totalAmount = transactionsPerMatatu[matatuId]['totalAmount'];
                      var transactions = transactionsPerMatatu[matatuId]['transactions'] as List<Map<String, dynamic>>;

                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ExpansionTile(
                          title: Text(
                            'Matatu ID: $matatuId',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Transactions: $transactionCount'),
                              Text('Total Amount: ${totalAmount.toStringAsFixed(2)}'),
                            ],
                          ),
                          children: transactions.map((transaction) {
                            return ListTile(
                              leading: Icon(Icons.person, size: 40, color: Colors.black),
                              title: Text('Phone Number: ${transaction['phoneNumber']}'),
                              subtitle: Text('Time: ${transaction['timestamp'].toDate()}'),
                            );
                          }).toList(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
      backgroundColor: const Color.fromARGB(255, 236, 239, 241), // Background color to contrast with the cards
    );
  }
}
