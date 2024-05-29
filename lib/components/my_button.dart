import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MyButton extends StatelessWidget {
  const MyButton({super.key, required this.onTap});
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          print("Button pressed");
          onTap!();
        } else {
          print("onTap is null");
        }
      },
      child: Container(
        padding: EdgeInsets.all(25),
        margin: EdgeInsets.symmetric(
          horizontal: 25,
        ),
        decoration: BoxDecoration(
            color: Colors.black, borderRadius: BorderRadius.circular(8)),
        child: Center(
          child: Text(
            'Sign in',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
