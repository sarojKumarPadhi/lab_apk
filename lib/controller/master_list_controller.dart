import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jonk_lab/controller/test_samples_controller.dart';

import '../model/master_list.dart';
import 'new_ride_controller.dart';

class MasterListController extends GetxController {
  RxList<MasterListModel> masterListController = <MasterListModel>[].obs;
  List<MasterListModel> rawData = [];
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    getDetails();
    super.onInit();
  }

  getDetails() async {
    String auth = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection("lab")
        .doc(auth)
        .get()
        .then((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        Map<String, dynamic> mapData = snapshot.data() as Map<String, dynamic>;
        List<dynamic> list = mapData["masterData"] ?? [];
        if (list.isNotEmpty) {
          masterListController
              .assignAll(list.map((e) => MasterListModel.fromJson(e)).toList());
          rawData
              .assignAll(list.map((e) => MasterListModel.fromJson(e)).toList());
        }
        isLoading.value = true;
      }
    });
  }

  updateDetails(int index, BuildContext context) async {
    NewRideController newRideController = Get.put(NewRideController());
    TestSamplesController testSamplesController = Get.find();
    String auth = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection("lab")
        .doc(auth)
        .get()
        .then((DocumentSnapshot snapshot) async {
      if (snapshot.exists) {
        List<dynamic> list = snapshot.get("masterData") ?? [];

        // Check if the index is within the bounds of the list
        if (index >= 0 && index < list.length) {
          // Update the specific index
          list[index] = {
            "name": newRideController.patientName.value,
            "age": newRideController.patientAge.value,
            "phoneNumber": newRideController.patientPhoneNumber.value,
            "samples": List.from(testSamplesController.testSamples),
            "gender": newRideController.gender.value
          };

          // Update the Firestore document
          await FirebaseFirestore.instance
              .collection("lab")
              .doc(auth)
              .update({"masterData": list}).then((value) {
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.pop(context);
            getDetails();
          });
        } else {
          print("Index out of bounds");
        }
      }
    });
  }

  addDetails(BuildContext context) async {
    NewRideController newRideController = Get.find();
    TestSamplesController testSamplesController = Get.find();
    String auth = FirebaseAuth.instance.currentUser!.uid;
    String customerId = await generateId();
    await FirebaseFirestore.instance
        .collection("lab")
        .doc(auth)
        .get()
        .then((DocumentSnapshot snapshot) async {
      if (snapshot.exists) {
        Map<String, dynamic> mapData = snapshot.data() as Map<String, dynamic>;
        List<dynamic> list = mapData["masterData"] ?? [];
        list.add({
          "customerId":customerId,
          "name": newRideController.patientName.value,
          "age": newRideController.patientAge.value,
          "phoneNumber": newRideController.patientPhoneNumber.value,
          "samples": List.from(testSamplesController.testSamples),
          "gender": newRideController.gender.value
        });
        await FirebaseFirestore.instance
            .collection("lab")
            .doc(auth)
            .update({"masterData": list}).then((value) {
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
          getDetails(); // context is the BuildContext of the current widget
        });
      }
    });
  }

  filterData(String data) {
    List<MasterListModel>? newList = [];
    newList = rawData
        .where((p0) =>
            p0.phone!.contains(data) ||
            (p0.name!.toLowerCase()).contains(data.toLowerCase()))
        .toList();
    if (newList.isNotEmpty) {
      masterListController.clear();
      masterListController.value = newList;
    } else {
      masterListController.clear();
    }
  }

  Future<String> generateId() async {
    int id=Random().nextInt(10000);
    return id.toString();
  }
}
