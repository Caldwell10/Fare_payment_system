import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerSupportPage extends StatefulWidget {
  final String phoneNumber;

  const CustomerSupportPage({super.key, required this.phoneNumber});

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
        'phoneNumber': widget.phoneNumber,
        'message': message,
        'timestamp': Timestamp.now(),
      });

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Success'),
            content: const Text('Your ticket has been submitted successfully.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
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
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
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
        title: const Text('Customer Support'),
        backgroundColor: const Color.fromARGB(255, 108, 105, 105),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, ${widget.phoneNumber}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: messageController,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                labelText: 'Message',
                labelStyle: const TextStyle(color: Colors.black),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blueAccent),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                alignLabelWithHint: true,
                hintText: 'Enter your message here',
                hintStyle: const TextStyle(color: Colors.black54),
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () => submitTicket(context),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: const TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  backgroundColor: Colors.black87,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Submit Ticket'),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 236, 239, 241),
    );
  }
}
