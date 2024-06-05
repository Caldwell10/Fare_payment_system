import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_page.dart'; // Import the HomePage
import 'package:fare_payment_system/controllers/phone_authentication.dart'; // Import PhoneAuthentication

class OtpVerificationPage extends StatefulWidget {
  final String verificationId;

  OtpVerificationPage({Key? key, required this.verificationId}) : super(key: key);

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final codeController = TextEditingController();
  final PhoneAuthentication phoneAuth = PhoneAuthentication();

  void verifyOTP() async {
    String otp = codeController.text.trim();
    String result = await phoneAuth.verifyOTPCode(
      verifyId: widget.verificationId,
      otp: otp,
    );

    if (result == 'success') {
      print("OTP verified successfully, navigating to HomePage"); // Debug statement
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      print("OTP verification failed: $result"); // Debug statement
      // Handle error
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to verify OTP. Please try again.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OTP Verification'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Enter the OTP sent to your phone',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              TextField(
                controller: codeController,
                decoration: InputDecoration(
                  labelText: 'OTP Code',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.security),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: verifyOTP,
                  child: Text('Verify'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  // Resend OTP functionality here
                },
                child: Text('Didn\'t receive OTP? Resend'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
