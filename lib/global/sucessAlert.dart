import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jonk_lab/page/userRegistration.dart';

successAlert(context) {
  Future.delayed(
    const Duration(seconds: 3),
    () {
      GetStorage data = GetStorage();
      data.write("auth", FirebaseAuth.instance.currentUser!.uid);
      Get.offAll(() => const UserRegistration())
          ?.then((value) {
            Navigator.pop(context);
      });
    },
  );

  // QuickAlert.show(
  //   context: context,
  //   type: QuickAlertType.success,
  //   title: "Success",
  //   showConfirmBtn: true,
  //   onConfirmBtnTap: () async {
  //     GetStorage data = GetStorage();
  //     data.write("auth", FirebaseAuth.instance.currentUser!.uid);
  //     Get.offAll(() => const UserRegistration(),
  //         transition: Transition.leftToRight,
  //         duration: const Duration(milliseconds: 600));
  //   },
  // );
  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("OTP verified")));
}
