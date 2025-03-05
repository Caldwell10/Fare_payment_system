import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewTransactionsPage extends StatelessWidget {
  const ViewTransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Transactions'),
        backgroundColor: const Color.fromARGB(255, 108, 105, 105),
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('matatus').snapshots(),
        builder: (context, matatuSnapshot) {
          if (matatuSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (matatuSnapshot.hasError) {
            return Center(child: Text('Error: ${matatuSnapshot.error}'));
          }

          if (!matatuSnapshot.hasData || matatuSnapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No matatus found'));
          }

          final matatus = matatuSnapshot.data!.docs;

          return ListView.builder(
            itemCount: matatus.length,
            itemBuilder: (context, index) {
              final matatu = matatus[index];
              final matatuId = matatu.id;
              final matatuName = matatu['name'];

              return StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('transactions')
                    .where('matatuId', isEqualTo: matatuId)
                    .snapshots(),
                builder: (context, transactionSnapshot) {
                  if (transactionSnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (transactionSnapshot.hasError) {
                    return Center(child: Text('Error: ${transactionSnapshot.error}'));
                  }

                  if (!transactionSnapshot.hasData || transactionSnapshot.data!.docs.isEmpty) {
                    return ListTile(
                      title: Text('Matatu: $matatuName'),
                      subtitle: const Text('No transactions found'),
                    );
                  }

                  final transactions = transactionSnapshot.data!.docs;

                  return Card(
                    margin: const EdgeInsets.all(10.0),
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ExpansionTile(
                      title: Text(
                        'Matatu: $matatuName',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                      ),
                      children: transactions.map((transactionDoc) {
                        final transaction = transactionDoc.data() as Map<String, dynamic>;
                        final amount = transaction['amount']?.toString() ?? 'No amount';
                        final phoneNumber = transaction['phoneNumber'] ?? 'No phone number';
                        final date = transaction['transactionDate'] != null
                            ? (transaction['transactionDate'] as Timestamp).toDate().toString()
                            : 'No date';
                        final receiptNumber = transaction['receiptNumber'] ?? 'No receipt number';
                        final startLocation = transaction['startLocation'] ?? 'No start location';
                        final endLocation = transaction['endLocation'] ?? 'No end location';

                        return ListTile(
                          leading: const Icon(Icons.receipt, size: 40.0, color: Colors.black),
                          title: Text(
                            'Amount: $amount',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 5.0),
                              Text('Phone Number: $phoneNumber'),
                              Text('Date: $date'),
                              Text('Receipt Number: $receiptNumber'),
                              Text('Start Location: $startLocation'),
                              Text('End Location: $endLocation'),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      backgroundColor: const Color.fromARGB(255, 236, 239, 241),
    );
  }
}
