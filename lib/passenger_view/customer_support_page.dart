import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerSupportPage extends StatefulWidget {
  final String phoneNumber;

  CustomerSupportPage({super.key, required this.phoneNumber});

  @override
  _CustomerSupportPageState createState() => _CustomerSupportPageState();
}

class _CustomerSupportPageState extends State<CustomerSupportPage> {
  final messageController = TextEditingController();

  void submitTicket(BuildContext context) async {
    final message = messageController.text.trim();

    if (message.isEmpty) {
      showErrorDialog('Message field is required.');
      return;
    }

    try {
      print('Submitting ticket with phone number: ${widget.phoneNumber} and message: $message');
      await FirebaseFirestore.instance.collection('support_tickets').add({
        'phone_number': widget.phoneNumber,
        'message': message,
        'timestamp': Timestamp.now(),
      });

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Your ticket has been submitted successfully.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );

      // Clear the form fields
      messageController.clear();
    } catch (e) {
      showErrorDialog('An error occurred. Please try again.');
      print('Error submitting ticket: $e');
    }
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print('CustomerSupportPage initialized with phone number: ${widget.phoneNumber}');
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Support'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome ${widget.phoneNumber}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              controller: messageController,
              decoration: InputDecoration(
                labelText: 'Message',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => submitTicket(context),
              child: Text('Submit Ticket'),
            ),
          ],
        ),
      ),
    );
  }
}
