import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jonk_lab/global/globalData.dart';
import 'package:jonk_lab/global/sucessAlert.dart';

verifyOtp(BuildContext context, String otpByInput) async {
  try {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationToken!, smsCode: otpByInput);
    await FirebaseAuth.instance.signInWithCredential(credential);
    successAlert(context);
  } catch (e) {
    Navigator.pop(context);

    Get.snackbar(
      colorText: Colors.white,
      icon: const Icon(Icons.dangerous, color: Colors.white),
      "Alert",
      "Enter a Valid Otp ",
      backgroundColor: Colors.red,
    );
  }
}
