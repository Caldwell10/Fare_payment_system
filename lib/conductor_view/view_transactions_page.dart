import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewTransactionsPage extends StatelessWidget {
  const ViewTransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Transactions'),
        backgroundColor: const Color.fromARGB(255, 108, 105, 105),
        
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('matatus').snapshots(),
        builder: (context, matatuSnapshot) {
          if (matatuSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (matatuSnapshot.hasError) {
            return Center(child: Text('Error: ${matatuSnapshot.error}'));
          }

          if (!matatuSnapshot.hasData || matatuSnapshot.data!.docs.isEmpty) {
            return Center(child: Text('No matatus found'));
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
                    return Center(child: CircularProgressIndicator());
                  }

                  if (transactionSnapshot.hasError) {
                    return Center(child: Text('Error: ${transactionSnapshot.error}'));
                  }

                  if (!transactionSnapshot.hasData || transactionSnapshot.data!.docs.isEmpty) {
                    return ListTile(
                      title: Text('Matatu: $matatuName'),
                      subtitle: Text('No transactions found'),
                    );
                  }

                  final transactions = transactionSnapshot.data!.docs;

                  return Card(
                    margin: EdgeInsets.all(10.0),
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ExpansionTile(
                      title: Text(
                        'Matatu: $matatuName',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                      ),
                      children: transactions.map((transactionDoc) {
                        final transaction = transactionDoc.data() as Map<String, dynamic>;
                        final amount = transaction['amount']?.toString() ?? 'No amount';
                        final description = transaction['resultDesc'] ?? 'No description';
                        final date = transaction['transactionDate'] ?? 'No date';
                        final receiptNumber = transaction['mpesaReceiptNumber'] ?? 'No receipt number';

                        return ListTile(
                          leading: Icon(Icons.receipt, size: 40.0, color: Colors.black),
                          title: Text(
                            'Amount: $amount',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 5.0),
                              Text('Description: $description'),
                              Text('Date: $date'),
                              Text('Receipt Number: $receiptNumber'),
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
      backgroundColor: const Color.fromARGB(255, 236, 239, 241), // Background color to contrast with the cards
    );
  }
}
