import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // This imports the generated Firebase options
import 'package:fare_payment_system/pages/auth_page.dart'; // Ensure the correct path

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase with the default options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Correctly placed inside the method call
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthPage(), 
    );
  }
}
