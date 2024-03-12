import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../model/time_price_zone.dart';

class RidePriceController extends GetxController {
  RxInt minimumRidePrice = 0.obs;
  Rx<TimePriceZone> timeZonePrice = TimePriceZone(day: 0, night: 0).obs;
  @override
  void onInit() {
    getPrice();
    super.onInit();
  }

  getPrice() {
    FirebaseFirestore.instance
        .collection("admin")
        .doc("6JedNJxfiaSrVtey9wk9cjGEIrp2")
        .get()
        .then((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        Map<String, dynamic> mapData = snapshot.data() as Map<String, dynamic>;
        minimumRidePrice.value = mapData["minimumPrice"] ?? "0";
        timeZonePrice.value = TimePriceZone.fromJson(mapData["timePrice"]);
      }
    });
  }
}
