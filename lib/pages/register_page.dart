import 'package:fare_payment_system/controllers/phone_authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'otp_verification_page.dart';
import 'package:fare_payment_system/components/my_button.dart';
import 'package:fare_payment_system/components/my_textfield.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final phoneController = TextEditingController();

  void sendOTP() async {
    print("sendOTP called"); // Debug statement
    String phoneNumber = '+254${phoneController.text.trim()}'; // Correctly format the phone number
    await PhoneAuthentication().sendOTPCode(
      phoneNumber,
      (String verId) async {
        print("OTP sent, navigating to verification page with verId: $verId"); // Debug statement
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtpVerificationPage(verificationId: verId, phoneNumber: phoneNumber),
          ),
        );
      },
      (dynamic error) { // Error handling callback
        print("Failed to send OTP: $error"); // Debug statement
        String errorMessage = 'An unknown error occurred';
        if (error is FirebaseAuthException) {
          errorMessage = "Failed to send OTP: ${error.message}";
        }
        
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Error"),
              content: Text(errorMessage),
              actions: <Widget>[
                TextButton(
                  child: const Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    );
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
                const Icon(
                  Icons.app_registration_outlined,
                  size: 100,
                ),
                const SizedBox(height: 50),
                const Text(
                  'Enter phone number to register',
                  style: TextStyle(color: Colors.black45, fontSize: 16),
                ),
                const SizedBox(height: 25),
                MyTextfield(
                  controller: phoneController,
                  hintText: 'Phone Number',
                  obscureTest: false,
                ),
                const SizedBox(height: 30),
                MyButton(
                  onTap: () {
                    print("Register button pressed"); // Debug statement
                    sendOTP();
                  },
                  text: 'Register',
                ),
                const SizedBox(height: 100),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already a member?'),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Login here',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
