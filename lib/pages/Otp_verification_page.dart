import 'package:flutter/material.dart';
import 'home_page.dart'; 
import 'package:fare_payment_system/controllers/phone_authentication.dart'; 

class OtpVerificationPage extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;

  const OtpVerificationPage({super.key, required this.verificationId, required this.phoneNumber});

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
        MaterialPageRoute(builder: (context) => HomePage(phoneNumber: widget.phoneNumber)),
      );
    } else {
      print("OTP verification failed: $result"); // Debug statement
      // Handle error
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Failed to verify OTP. Please try again.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void resendOTP() {
    // Add functionality to resend OTP here
    print('Resend OTP functionality to be implemented');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OTP Verification'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Enter the OTP sent to your phone',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: codeController,
                decoration: const InputDecoration(
                  labelText: 'OTP Code',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.security),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: verifyOTP,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    textStyle: const TextStyle(fontSize: 18,),
                  ),
                  child: const Text('Verify'),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: resendOTP,
                child: const Text('Didn\'t receive OTP? Resend'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
