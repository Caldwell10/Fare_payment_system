import 'package:fare_payment_system/pages/home_page.dart';
import 'package:fare_payment_system/pages/login_or_register_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // User is logged in
          if (snapshot.hasData) {
            final user = FirebaseAuth.instance.currentUser;
            final phoneNumber = user?.phoneNumber ?? 'Unknown';
            return HomePage(phoneNumber: phoneNumber);
          }
          // User is not logged in
          else {
            return const LoginOrRegisterPage();
          }
        },
      ),
    );
  }
}
