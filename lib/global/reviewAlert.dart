import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jonk_lab/global/progressIndicator.dart';
import 'package:jonk_lab/page/homePage.dart';
import 'package:quickalert/quickalert.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';



GetStorage data = GetStorage();

Map<String, dynamic> basicDetails = data.read("basicDetails");
Map<String, dynamic> addressDetails = data.read("addressDetails");
Map<String, dynamic> labLocation = data.read("labLatLongWithLocation");
Map<String, dynamic> bankDetails = data.read("bankDetails");
String phoneNumber = FirebaseAuth.instance.currentUser!.phoneNumber!;
String fcmToken = data.read("fcmToken");


File aadharImageFile = File(data.read("aadharImageFile"));
File panImageFile = File(data.read("panImageFile"));
File bankPassBookFile = File(data.read("bankPassBookFile"));
File labCertificateFile = File(data.read("labCertificateFile"));
File picture1 = File(data.read("picture1"));
File picture2 = File(data.read("picture2"));
File picture3 = File(data.read("picture3"));
File picture4 = File(data.read("picture4"));

List<File> documents = [
  aadharImageFile,
  panImageFile,
  bankPassBookFile,
  labCertificateFile,
  picture1,
  picture2,
  picture3,
  picture4
];


List<String> downloadImageUrls = [];




uploadImage() async {
  for (int i = 0; i < 8; i++) {
    Reference ref = FirebaseStorage.instance.ref().child('lab').child(basicDetails["labName"]).child("${DateTime.now().toString()}.jpg");
    UploadTask uploadTask = ref.putFile(File(documents[i].path));
    TaskSnapshot snapshot = await uploadTask;
    downloadImageUrls.add(await snapshot.ref.getDownloadURL());
  }
}




reviewAlert(context) {
  Future.delayed(
    const Duration(seconds: 0),
        () async {
      try {
        showDialog(
          context: context,
          barrierDismissible: false, // This makes the dialog dismissible
          builder: (BuildContext context) {
            return const CircularProgress(); // Replace with your actual dialog widget
          },
        );
        await uploadImage();
        data.remove("auth");
        GeoPoint geoPoint = GeoPoint(labLocation["latitude"], labLocation["longitude"]);

        FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
        await firebaseFirestore.collection("lab").doc(
            FirebaseAuth.instance.currentUser!.uid).set({
          "accountStatus": false,
          "phoneNumber": phoneNumber,
          "deviceToken": fcmToken,
          "basicDetails": basicDetails,
          "address": {
            "country": "india",
            "state": addressDetails["state"],
            "district": addressDetails["district"],
            "pinCode": addressDetails["pinCode"],
            "city": addressDetails["city"],
            "latLong": geoPoint,
            "labLocation": labLocation["labLocation"],
          },
          "bankDetails": bankDetails,
          "documentVerification": {
            "aadhar": false,
            "bankPassbook": false,
            "labPicture": false,
            "labCertificate": false,
            "panCard": false,
          },
          "documentUrl": {
            "aadharUrl": downloadImageUrls[0],
            "panCardUrl": downloadImageUrls[1],
            "bankPassBookUrl": downloadImageUrls[2],
            "labCertificateUrl": downloadImageUrls[3],
            "labPictureUrl": [
              downloadImageUrls[4],downloadImageUrls[5],downloadImageUrls[6],downloadImageUrls[7]
            ]
          }
        });


        showCongratulationsDialog(context);

      } catch (e) {
        print('Error sending data to Firestore: $e');
      }
    },
  );

}

void showCongratulationsDialog(BuildContext context){
  QuickAlert.show(
    barrierDismissible: false, // This makes the dialog dismissible
    context: context,
    type: QuickAlertType.success,
    title: "Congratulations",
    showConfirmBtn: true,
    onConfirmBtnTap: () async {
      Get.offAll(() => const HomePage(), transition: Transition.leftToRight,
          duration: const Duration(milliseconds: 600));
    },
  );


  Future.delayed(const Duration(seconds: 2), () {
    Get.offAll(() => const HomePage(), transition: Transition.leftToRight,
        duration: const Duration(milliseconds: 600));

  });
}