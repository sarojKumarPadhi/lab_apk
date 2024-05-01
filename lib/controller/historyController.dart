import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import 'dateController.dart';



class toDayRideS extends GetxController {
  List<dynamic> listOfTodayRide = <dynamic>[].obs;

  Future<List<dynamic>> getMYRideData({required String uid}) async {
    try {
      DocumentSnapshot snapshot =
      await FirebaseFirestore.instance.collection("lab").doc(uid).get();
      if (snapshot.data() != null) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        Map<String, dynamic> myRide = data["myRide"];
        listOfTodayRide.clear();
        DateTime today = DateTime.now();
        String documentName = "${today.day}-${today.month}-${today.year}";
        List<dynamic> myRideData = myRide[documentName] ?? [];
        listOfTodayRide.addAll(myRideData);
      } else {
        print("No data found");
      }
    } catch (e) {
      print(e);
    }
    listOfTodayRide.forEach((element) {});
    return listOfTodayRide;
  }
}

class myAllRideS extends GetxController {
  final DateController controller = Get.put(DateController());

  Map<String, dynamic> allDataOfMyRide = {};
  List<dynamic> listOfMyRide = [].obs;
  RxList rideList = [].obs;

  Future<List<dynamic>> getMYRideHistoryData({required String userUid}) async {
    DateTime today = DateTime.now();
    try {
      DocumentSnapshot snapshot =
      await FirebaseFirestore.instance.collection("lab").doc(userUid).get();
      if (snapshot.data() != null) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        Map<String, dynamic> myRide = data["myRide"];
        allDataOfMyRide = myRide;

        listOfMyRide.clear();
        rideList.clear();
        for (int i = 1; i <= 3600; i++) {
          DateTime previousDay = today.subtract(Duration(days: i));
          String documentName =
              "${previousDay.day}-${previousDay.month}-${previousDay.year}";
          List<dynamic> myRideData = myRide[documentName] ?? [];
          listOfMyRide.addAll(myRideData);
          rideList.addAll(myRideData);
        }
      } else {
        print("Not data found");
      }
    } catch (e) {
      print(e);
    }
    print(rideList.length);
    return listOfMyRide;
  }

  filterDataByDate() {
    rideList.clear();
    DateTime? date = controller.pickedDate.value;
    String documentName = "${date?.day}-${date?.month}-${date?.year}";
    List<dynamic> myRideData = allDataOfMyRide[documentName] ?? [];
    rideList.addAll(myRideData);
  }
}