import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jonk_lab/page/homePage.dart';
import 'package:jonk_lab/page/userRegistration.dart';

Future<bool> checkUserOldOrNew() async {
  String? auth = FirebaseAuth.instance.currentUser?.uid;

  var docSnap =
      await FirebaseFirestore.instance.collection("lab").doc(auth).get();

  if (docSnap.exists) {
    return true;
  } else {
    return false;
  }
}

successAlert(context) {
  Future.delayed(
    const Duration(seconds: 3),
    () async {
      if (await checkUserOldOrNew()) {
        Get.offAll(() => const HomePage());
      } else {
        GetStorage data = GetStorage();
        data.write("auth", FirebaseAuth.instance.currentUser!.uid);
        Get.offAll(() => const UserRegistration())?.then((value) {
          Navigator.pop(context);
        });
      }
    },
  );
}
