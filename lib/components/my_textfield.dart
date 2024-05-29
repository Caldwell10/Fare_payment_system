import 'package:flutter/material.dart';

class MyTextfield extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscureTest;

  const MyTextfield(
      {super.key,
      required this.controller, //access what the user has typed
      required this.hintText,
      required this.obscureTest});

  Widget build(BuildContext context) {
    return  Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: controller,
        obscureText: obscureTest,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          fillColor: Colors.white70,
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey)
        ),
      ),
    );
  }
}
