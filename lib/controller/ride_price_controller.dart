import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class RidePriceController extends GetxController {
  RxString minimumRidePrice = "".obs;
  RxString perKmPrice = "".obs;

  @override
  void onInit() {
    getPrice();
    super.onInit();
  }

  getPrice() {
    FirebaseFirestore.instance
        .collection("lab")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        Map<String, dynamic> mapData = snapshot.data() as Map<String, dynamic>;
        minimumRidePrice.value = mapData["minimumRidePrice"] ?? "0";
        perKmPrice.value = mapData["perKmPrice"] ?? "0";
      }
    });
  }

  updateRate(String minRate, String perKmPrice) {
    FirebaseFirestore.instance
        .collection("lab")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({"minimumRidePrice": minRate, "perKmPrice": perKmPrice}).then(
            (value) {
      getPrice();
      Fluttertoast.showToast(msg: "Updated price");
    });
  }
}
