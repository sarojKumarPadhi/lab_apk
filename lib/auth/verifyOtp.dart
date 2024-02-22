import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jonk_lab/global/globalData.dart';
import 'package:jonk_lab/global/sucessAlert.dart';

verifyOtp(BuildContext context) async {
  try {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationToken!, smsCode: otp!);

    await FirebaseAuth.instance.signInWithCredential(credential);
    // Get.offAll(() => const UserRegistration(),
    //     transition: Transition.leftToRight,
    //     duration: const Duration(milliseconds: 400));
    // GetStorage auth=GetStorage();
    // auth.write("auth", FirebaseAuth.instance.currentUser!.uid);
    successAlert(context);
  } catch (e) {
    Get.snackbar(
      colorText: Colors.white,
        icon: const Icon(Icons.dangerous,color: Colors.white),
        "Alert", "Enter a Valid Otp",
      backgroundColor: Colors.red,
    );
  }
}
