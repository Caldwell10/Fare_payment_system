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

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: controller,
        obscureText: obscureTest,
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          fillColor: Colors.white70,
          filled: true,
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey)
        ),
      ),
    );
  }
}
