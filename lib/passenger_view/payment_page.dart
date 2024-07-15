import 'package:fare_payment_system/components/my_button.dart';
import 'package:fare_payment_system/components/my_textfield.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fare_payment_system/controllers/mpesa_service.dart';
import 'package:fare_payment_system/components/constants.dart';
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
  bool isLoading = false;

  Future<void> _initiatePayment() async {
    final phoneNumber = phoneController.text.trim();
    final amount = amountController.text.trim();

    if (phoneNumber.isEmpty || amount.isEmpty || selectedMatatuId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a phone number, amount, and select a matatu')),
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

      String result = await _mpesaService.initiateStkPush(
        phoneNumber,
        amount,
        Constants.accountref,
        Constants.transactionDesc,
      );

      await FirebaseFirestore.instance.collection('transactions').add({
        'phoneNumber': phoneNumber,
        'amount': amount,
        'matatuId': selectedMatatuId,
        'matatuName': selectedMatatuName,
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
            child: Column(
              children: <Widget>[
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('matatus').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }

                    var matatus = snapshot.data!.docs;

                    return DropdownButtonFormField(
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
                          child: Text(matatu['name']),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedMatatuId = value as String;
                          selectedMatatuName = matatus.firstWhere((matatu) => matatu.id == selectedMatatuId)['name'];
                        });
                      },
                      value: selectedMatatuId.isEmpty ? null : selectedMatatuId,
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
              ],
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
