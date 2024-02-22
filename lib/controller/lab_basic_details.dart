import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../model/lab_basic_details.dart';

class LabBasicDetailsController extends GetxController {
  Rx<LabBasicDetailsModel> labBasicDetailsData = LabBasicDetailsModel().obs;

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  getData() async {
    FirebaseFirestore.instance
        .collection("lab")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((docSnap) {
      if (docSnap.exists) {
        Map<String, dynamic> mapData = docSnap.data() as Map<String, dynamic>;
        labBasicDetailsData.value = LabBasicDetailsModel.fromJson(mapData);
      }
    });
  }
}
