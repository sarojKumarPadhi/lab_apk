import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

import '../global/globalData.dart';
import '../page/after_ride_accept_by_rider.dart';

class ListenAcceptedRideController extends GetxController {
  RxString labUid = "".obs;
  RxString requestUid = "".obs;

  void listenDataMethod() {
    String labUid = FirebaseAuth.instance.currentUser!.uid;
    DatabaseReference reference = FirebaseDatabase.instance
        .ref()
        .child("active_labs/$labUid/$latestRideId");
    reference.get().then((value){
      final data = value.value;
      if (value.exists&&
          data is Map<dynamic, dynamic> &&
          data.containsKey("riderId")) {
        Get.offAll(() => AfterAcceptanceRidePage(
            requestId: latestRideId!, labUid: labUid)
        );
      } else {
        listenDataMethod();
      }
    });
  }
}
