// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
//
// import '../model/direction_detail_info.dart';
// import '../services/networkRequest.dart';
// import 'lab_basic_details.dart';
//
// class PolyLineController extends GetxController {
//   RxList<LatLng> pLineCoordinatesList = <LatLng>[].obs;
//   RxSet<Polyline> polyLineSet = <Polyline>{}.obs;
//   LabBasicDetailsController labBasicDetailsController = Get.find();
//
//   @override
//   onInit() {
//     super.onInit();
//     getPolyline();
//   }
//
//   void getPolyline() async {
//     DirectionDetailsInfo? resultOriginToDestination =
//     await obtainOriginToDestinationDirectionDetails(
//       LatLng(
//         labBasicDetailsController
//             .labBasicDetailsData.value.address!.geoPoint.latitude,
//         labBasicDetailsController
//             .labBasicDetailsData.value.address!.geoPoint.longitude,
//       ),
//       const LatLng(30.6949, 76.8826),
//     );
//     if (resultOriginToDestination != null) {
//       PolylinePoints polylinePoints = PolylinePoints();
//       List<PointLatLng> pointLatLng =
//       polylinePoints.decodePolyline(resultOriginToDestination.e_points!);
//
//       int index = 0;
//       const duration = Duration(milliseconds: 10); // Adjust the duration as needed
//       Timer.periodic(duration, (timer) {
//         if (index < pointLatLng.length) {
//           pLineCoordinatesList.add(
//             LatLng(pointLatLng[index].latitude, pointLatLng[index].longitude),
//           );
//           Polyline polyline = Polyline(
//             geodesic: true,
//             endCap: Cap.squareCap,
//             startCap: Cap.roundCap,
//             jointType: JointType.round,
//             width: 4,
//             color: Colors.black,
//             points: List<LatLng>.from(pLineCoordinatesList),
//             polylineId: const PolylineId("PolylineID"),
//           );
//           polyLineSet.add(polyline); // Add the polyline to the set
//           index++;
//         } else {
//           timer.cancel(); // Stop the timer when all points are added
//         }
//       });
//     }
//   }
// }
