import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../global/globalData.dart';

class trackSample extends GetxController {
  RxList<dynamic> listOfSample = RxList<dynamic>();


  @override
  void onInit() {
    super.onInit();
    getAllSampleData();
  }

  Future getAllSampleData() async {


    await FirebaseDatabase.instance
        .ref()
        .child("active_labs/$auth")
        .once()
        .then((DatabaseEvent event) {
      if (event.snapshot.exists) {
        Map<dynamic, dynamic> data = event.snapshot.value as Map<dynamic, dynamic>;
        data.forEach((key, value) {
          listOfSample.add(value);
        });
      }
      else {
        Fluttertoast.showToast(msg: "No data available");
      }
    });
  }

}


