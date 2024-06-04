import 'package:fare_payment_system/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:fare_payment_system/components/my_button.dart';
import 'package:fare_payment_system/components/my_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OtpVerificationPage extends StatefulWidget {
  final String verificationId;
  
  OtpVerificationPage({Key? key, required this.verificationId}) : super(key: key);

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final codeController = TextEditingController();

  void verifyOTP() async {
    try {
      // Create a PhoneAuthCredential with the code
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: codeController.text,
      );

      // Sign in the user with the credential
      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      if (userCredential.user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()), // Navigate to HomeScreen or another appropriate screen
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Failed to verify OTP: ${e.toString()}"),
            actions: <Widget>[
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
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
      backgroundColor: const Color.fromARGB(255, 188, 194, 197),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 50),
                const Icon(Icons.lock, size: 100),
                const SizedBox(height: 50),
                const Text(
                  'Enter the OTP sent to your phone',
                  style: TextStyle(color: Colors.black45, fontSize: 16),
                ),
                const SizedBox(height: 25),
                MyTextfield(
                  controller: codeController,
                  hintText: 'OTP Code',
                  obscureTest: false,
                ),
                const SizedBox(height: 10),
                MyButton(
                  onTap: verifyOTP,
                  text: 'Verify and Register',
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
