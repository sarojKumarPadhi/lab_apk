import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:get/get.dart';
import 'package:jonk_lab/page/newPatient.dart';

import '../model/active_driver_in_realtime_database.dart';

class PushNotificationController extends GetxController {
  RxList<String> riderUid = <String>[].obs;
  RxList<ActiveDriverRealTimeDataBase> allOnlineDriverData =
      <ActiveDriverRealTimeDataBase>[].obs;
  RxList<String> keysRetrieved = <String>[].obs;

  @override
  onInit() {
    super.onInit();

    getAllOnlineDriverId();
  }


  void getDataFromRealTimeDatabase(String key) {
    DatabaseReference databaseReference = FirebaseDatabase.instance.ref().child("rider");

    // Query the database for the specific key
    databaseReference.orderByKey().equalTo(key).onValue.listen((event) {
      if (event.snapshot.value != null) {
        dynamic riderData = event.snapshot.value;
        if (riderData is Map<dynamic, dynamic>) {
          riderData.forEach((riderKey, riderInfo) {
            // Ensure riderInfo is a Map<dynamic, dynamic>
            if (riderInfo is Map<dynamic, dynamic>) {
              allOnlineDriverData.add(ActiveDriverRealTimeDataBase(
                  name: riderInfo['name'],
                  deviceToken: riderInfo['deviceTokens'],
                  phoneNumber: riderInfo['phoneNumber'],
                  rideStatus: riderInfo['rideStatus'],
                  currentLocation: riderInfo['currentLocation']
              ));
            }
          });
        }
      }
    }, onError: (Object error) {
      print("Error: $error");
    });
  }


  void forLoop() {
    List<String> keysList=keysRetrieved.toSet().toList();
    for (String keys in keysList){
      getDataFromRealTimeDatabase( keys);
    }
  }

  void getAllOnlineDriverId() {
    Geofire.initialize("activeDrivers");
    Geofire.queryAtLocation(
            NewPatient.latLng!.latitude, NewPatient.latLng!.latitude, 10)!
        .listen((map) {
      if (map != null) {
        var callBack = map["callBack"];
        switch (callBack) {
          case Geofire.onKeyEntered:
            keysRetrieved.add(map["key"]);
            break;

          case Geofire.onKeyExited:
            keysRetrieved.remove(map["key"]);
            break;

          case Geofire.onKeyMoved:
             keysRetrieved.add(map["key"]);
            break;

          case Geofire.onGeoQueryReady:
             map["result"].forEach((key){
               keysRetrieved.add(key);
             });

            // print(keysRetrieved.toSet().toList().length.toString());
            // print(keysRetrieved.toSet().toList().length.toString());
            // print(keysRetrieved.toSet().toList().length.toString());
             forLoop();
            break;

        }
      }
    });

  }
  
}
