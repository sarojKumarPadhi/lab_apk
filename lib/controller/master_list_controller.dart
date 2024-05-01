import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jonk_lab/controller/test_samples_controller.dart';

import '../model/master_list.dart';
import 'new_ride_controller.dart';

class MasterListController extends GetxController {
  RxList<MasterListModel> masterList = <MasterListModel>[].obs;
  List<MasterListModel> rawData = [];
  RxBool isLoading = false.obs;

  /// ------for new user--------//
  RxString name = "".obs;
  RxString age = "".obs;
  RxString phoneNumber = "".obs;
  RxString gender = "male".obs;
  RxList<String> selectedSubcategories = <String>[].obs;
  RxBool isEditable = false.obs;
  RxString customerId = "".obs;

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
          masterList
              .assignAll(list.map((e) => MasterListModel.fromJson(e)).toList());
          rawData
              .assignAll(list.map((e) => MasterListModel.fromJson(e)).toList());
        } else {
          masterList.clear();
        }
        isLoading.value = true;
      }
    });
  }

  updateDetails(String customerId, BuildContext context) async {
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
        int indexNumber = list.indexWhere((e) => e["customerId"] == customerId);
        if (indexNumber >= 0 && indexNumber < list.length) {
          // Update the specific index
          list[indexNumber] = {
            "name": name.value,
            "age": age.value,
            "phoneNumber": phoneNumber.value,
            "samples": List.from(selectedSubcategories),
            "gender": gender.value,
            "customerId": customerId
          };

          // Update the Firestore document
          await FirebaseFirestore.instance
              .collection("lab")
              .doc(auth)
              .update({"masterData": list}).then((value) {
            getDetails();

          });
        } else {
          print("Index out of bounds");
        }
      }
    });
  }

  addDetails(BuildContext context) async {
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
          "customerId": customerId,
          "name": name.value,
          "age": age.value,
          "phoneNumber": phoneNumber.value,
          "samples": List.from(selectedSubcategories),
          "gender": gender.value
        });
        await FirebaseFirestore.instance
            .collection("lab")
            .doc(auth)
            .update({"masterData": list}).then((value) {
          getDetails();
          name.value = "";
          age.value = "";
          phoneNumber.value = "";
          selectedSubcategories.clear();
          // context is the BuildContext of the current widget
        });
      }
    });
  }

  deleteFromMasterList(
      String customerId, BuildContext context, bool isFromNewPatient) async {
    String auth = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection("lab")
        .doc(auth)
        .get()
        .then((DocumentSnapshot snapshot) async {
      Map<String, dynamic> mapData = snapshot.data() as Map<String, dynamic>;
      List<dynamic> mapDataList = mapData["masterData"] ?? [];
      int index = mapDataList
          .indexWhere((element) => element["customerId"] == customerId);
      mapDataList.removeAt(index);

      await FirebaseFirestore.instance
          .collection("lab")
          .doc(auth)
          .update({"masterData": mapDataList}).then((value) async {
        await getDetails();
        if (!isFromNewPatient) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              backgroundColor: Colors.redAccent, content: Text("Deleted")));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              backgroundColor: Colors.redAccent, content: Text("Deleted")));
        }
      });
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
      masterList.clear();
      masterList.value = newList;
    } else {
      masterList.clear();
    }
  }

  Future<String> generateId() async {
    int id = Random().nextInt(10000);
    return id.toString();
  }
}
