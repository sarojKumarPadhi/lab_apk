// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
//
// import '../global/globalData.dart';
// import '../page/newPatient.dart';
//
// Future<bool> checkLatestRide() async {
//   final DatabaseReference databaseReference = FirebaseDatabase.instance
//       .ref("active_labs")
//       .child(FirebaseAuth.instance.currentUser!.uid);
//
//   final DataSnapshot snapshot = await databaseReference.get();
//
//   // Check if the snapshot value is not null and is a Map
//   if (snapshot.value != null && snapshot.value is Map) {
//     final Map<dynamic, dynamic> mapData = snapshot.value as Map<dynamic, dynamic>;
//
//     // Iterate through the entries of the map
//     for (final entry in mapData.entries) {
//       latestRideId=entry.key;
//       final Map<dynamic, dynamic> data = entry.value as Map<dynamic, dynamic>;
//
//       // Check if the data contains the "rideStatus" field and its value is "idle"
//       if (data.containsKey("rideStatus") && data["rideStatus"] == "idle") {
//         // Extract necessary details and assign them to NewPatient class fields
//         NewPatient.patientName = data["patientDetails"]["name"];
//         NewPatient.age = data["patientDetails"]["age"];
//         NewPatient.patientLocation = data["patientDetails"]["location"];
//         NewPatient.mobileNumber = data["patientDetails"]["phone"];
//         NewPatient.latLng = LatLng(
//           data["patientDetails"]["latitude"],
//           data["patientDetails"]["longitude"],
//         );
//         NewPatient.tests = data["patientDetails"]["test"];
//
//         return true; // Exit the function if an idle ride is found
//       }
//     }
//   }
//
//   return false; // Return false if no idle ride is found or data structure is unexpected
// }
