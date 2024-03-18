import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart';

Future<void> deviceLocationPermissions() async {
  Location location = Location();
  bool serviceEnabled;
  serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await location.requestService();
    if (!serviceEnabled) {
      Fluttertoast.showToast(msg: "Device location permission denied");
      return;
    }
  }
}
