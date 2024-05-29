import 'package:fare_payment_system/pages/home_page.dart';
import 'package:fare_payment_system/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body :StreamBuilder<User?>(
      stream:FirebaseAuth.instance.authStateChanges(),
      builder: (context ,snapshot){
           //user is logged in 
           if(snapshot.hasData){
            return HomePage();
           }

           //user os not logged in

           return LoginPage();
      },
    ),
    );
  }
}