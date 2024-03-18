import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';

import '../permission_handler/device_location_permission.dart';

class RegistrationLabLocationController extends GetxController {
  RxDouble latitude = 0.0.obs;
  RxDouble longitude = 0.0.obs;

  getLocation() async {
    Location location = Location();
    bool permission;
    LocationData locationData;
    permission=await location.serviceEnabled();
    if(permission){
      locationData = await location.getLocation();
      latitude.value = locationData.latitude!;
      longitude.value = locationData.longitude!;
    }
    else{
     await deviceLocationPermissions();
     getLocation();
    }


  }
}
