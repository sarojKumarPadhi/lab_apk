import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import '../global/globalData.dart';

class TrackSampleController extends GetxController {
  RxList<dynamic> listOfSampleData = RxList<dynamic>();
  RxBool isLoading=false.obs;
  @override
  void onInit() {
    super.onInit();
    getAllSampleData();
  }
   getAllSampleData() {
    FirebaseDatabase.instance
        .ref()
        .child("active_labs/$auth")
        .onValue
        .listen(( event) {
      if (event.snapshot.exists) {
        Map<dynamic, dynamic> data = event.snapshot.value as Map<dynamic, dynamic>;
        List<dynamic> listOfSample = [];
        data.forEach((key, value) {
          listOfSample.add(value);
        });
        listOfSampleData.value=listOfSample;
      } else {
        Fluttertoast.showToast(msg: "No data available");
      }
    });
    isLoading.value=true;

  }
}


