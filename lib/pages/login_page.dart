import 'package:fare_payment_system/components/my_button.dart';
import 'package:fare_payment_system/components/my_textfield.dart';
import 'package:fare_payment_system/components/square_tile.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text editing controllers
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  // sign user in
  void signUserIn() async {

    //loading circle
       showDialog(
        context : context, 
        builder : (context)
        {
          return  Center( 
            child: CircularProgressIndicator()
            ) ;
          
        },
       );
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
       }on FirebaseAuthException catch (e){
          if (e.code == 'user-not-found') {
            //show error to user 
        print( 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        //show 
        print( 'Wrong password!');
      } else {
        print('An error occurred. Please try again.');
      }

        
       }
      Navigator.pop(context);

  }
 void wrongEmailMessage() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Incorrect Email'),
        content: Text('Please enter a valid email address.'),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 188, 194, 197),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 50),
                Icon(
                  // logo
                  Icons.lock,
                  size: 100,
                ),
                SizedBox(height: 50),

                // welcome back
                Text(
                  'Welcome back',
                  style: TextStyle(
                    color: Colors.black45,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 25),

                // username textfield
                MyTextfield(
                  controller: emailController,
                  hintText: 'Email',
                  obscureTest: false,
                ),

                SizedBox(height: 10),

                // password textfield
                MyTextfield(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureTest: true,
                ),
                SizedBox(height: 10),

                // forgot password
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Forgot password?',
                        style: TextStyle(color: Colors.black45),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 25),

                // sign in button
                MyButton(
                  onTap: signUserIn,
                ),
                SizedBox(height: 50),

                // continue with
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 5,
                        color: Colors.grey[400],
                      ),
                    ),
                    Text('Or continue with'),
                    Expanded(
                      child: Divider(
                        thickness: 5,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                // google + apple sign in buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //google button
                    SquareTile(imagepath: 'lib/images/google.png'),

                    const SizedBox(width: 15),
                    //apple button
                    SquareTile(imagepath: 'lib/images/apple.png'),
                  ],
                ),
                const SizedBox(height: 50),
                // not a member? register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Not a member?'),
                    const SizedBox(width: 4),
                    Text(
                      'Register now',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
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
