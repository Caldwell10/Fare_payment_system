import 'package:fare_payment_system/pages/auth_page.dart';

import 'pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
  options:DefaultFirebaseOptions.currentPlatform;
}
class MyApp extends StatelessWidget{
  const MyApp({super.key});


Widget build(BuildContext context){
  return  MaterialApp(
    debugShowCheckedModeBanner: false,
     home:AuthPage()
    );
}


}