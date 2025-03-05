import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PhoneAuthentication {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Send OTP Code to Phone Number
  Future<void> sendOTPCode(String phoneNo, Function(String) onCodeSent, Function(dynamic) onError) async {
    try {
      // Ensure the phone number is correctly formatted
      final formattedPhoneNo = phoneNo.startsWith('+254') ? phoneNo : '+254$phoneNo';
      print("Sending OTP to $formattedPhoneNo"); // Debug statement
      await _auth.verifyPhoneNumber(
        timeout: const Duration(seconds: 40),
        phoneNumber: formattedPhoneNo,
        verificationCompleted: (PhoneAuthCredential credential) {
          // Auto-resolving cases
          print("Verification completed with credential: $credential"); // Debug statement
        },
        verificationFailed: (FirebaseAuthException e) {
          print("Verification failed with error: ${e.message}"); // Debug statement
          onError(e); // Properly call the error handler
        },
        codeSent: (String verificationId, int? resendToken) {
          print("Code sent, verificationId: $verificationId"); // Debug statement
          onCodeSent(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print("Auto retrieval timeout, verificationId: $verificationId"); // Debug statement
          // Handle auto-retrieval time out if needed
        },
      );
    } catch (e) {
      print("Error in sendOTPCode: $e"); // Debug statement
      onError(e);
    }
  }

  // Verify OTP Code
  Future<String> verifyOTPCode({
    required String verifyId,
    required String otp,
  }) async {
    try {
      final PhoneAuthCredential authCredential = PhoneAuthProvider.credential(
        verificationId: verifyId,
        smsCode: otp,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(authCredential);
      if (userCredential.user != null) {
        await storeNumber(userCredential.user!.phoneNumber!);
        return 'success';
      } else {
        return 'Error in OTP';
      }
    } catch (e) {
      return e.toString();
    }
  }

  // Store phone number
  Future<void> storeNumber(String phoneNo) async {
    try {
      await _firestore.collection('users').doc(phoneNo).set({
        'phoneNumber': phoneNo,
      });
      print("Phone number $phoneNo stored successfully"); // Debug statement
    } catch (e) {
      print("Error storing phone number: $e"); // Debug statement
    }
  }
}
