import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home_page.dart';
import 'package:fare_payment_system/components/my_button.dart';
import 'package:fare_payment_system/components/my_textfield.dart';
import 'package:fare_payment_system/conductor_view/conductor_home_page.dart';
import 'package:fare_payment_system/admin_view/admin_home_page.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final phoneController = TextEditingController();

  void signUserIn() async {
    // Show loading circle
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismiss by tapping outside
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      String phoneNumber = '+254${phoneController.text.trim()}';
      var userDoc = await FirebaseFirestore.instance.collection('users').doc(phoneNumber).get();

      if (userDoc.exists) {
        // Get user role
        String role = userDoc['role'];

        // Navigate to appropriate home page
        Widget homePage;
        if (role == 'passenger') {
          homePage = HomePage(phoneNumber: phoneNumber);
        } else if (role == 'conductor') {
          homePage = const ConductorHomePage();
        } else if (role == 'admin') {
          homePage = const AdminHomePage();
        } else {
          homePage=HomePage(phoneNumber: phoneNumber);
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => homePage),
        );
      } else {
        Navigator.pop(context); // Remove the loading circle
        showErrorDialog('Phone number not found');
      }
    } catch (e) {
      Navigator.pop(context); // Remove the loading circle
      showErrorDialog('An error occurred. Please try again.');
    }
  }

  // Error message dialog
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
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 188, 194, 197),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 50),
                const Icon(
                  Icons.account_circle,
                  size: 100,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Welcome back',
                  style: TextStyle(
                    color: Colors.black45,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 50),

                // Phone Number textfield
                MyTextfield(
                  controller: phoneController,
                  hintText: 'Phone Number',
                  obscureTest: false,
                ),
                const SizedBox(height: 25),

                // Sign in button
                MyButton(
                  onTap: signUserIn,
                  text: 'Sign In',
                ),
                const SizedBox(height: 100),

                // Not a member? Register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Not a member?'),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Register now',
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
