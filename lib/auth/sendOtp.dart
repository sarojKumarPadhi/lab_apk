import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jonk_lab/global/globalData.dart';

import '../page/otpVerify.dart';

sendOtp(BuildContext context) async {
  try {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+91$phoneNumber',
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        Navigator.pop(context);
        Get.snackbar(
          "SMS verification code request failed",
          colorText: Colors.white,
          "Enter a valid number",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.redAccent,
        );
      },
      codeSent: (String verificationId, int? resendToken) {
        verificationToken = verificationId;

        Get.to(() => const OtpVerify(),
            duration: const Duration(milliseconds: 300),
            transition: Transition.leftToRight)?.then((value){
              Navigator.pop(context);
        });

      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  } catch (e) {
    Get.snackbar(
      "OTP sent failed ",
      colorText: Colors.white,
      "Enter a valid number",
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.redAccent,
    );  }
}
