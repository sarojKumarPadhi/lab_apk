import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jonk_lab/page/track_sample.dart';

import '../controller/transition_controller.dart';
import '../global/globalData.dart';
import '../global/progressIndicator.dart';
import '../services/networkRequest.dart';
import 'homePage.dart';

class AfterAcceptanceRidePage extends StatefulWidget {
  final String requestId;
  final String labUid;

  const AfterAcceptanceRidePage(
      {Key? key, required this.requestId, required this.labUid})
      : super(key: key);

  @override
  State<AfterAcceptanceRidePage> createState() =>
      _AfterAcceptanceRidePageState();
}

class _AfterAcceptanceRidePageState extends State<AfterAcceptanceRidePage> {
  LatLng? labLatLng;
  LatLng? riderLatLng;
  LatLng? patientLatLng;
  Set<Polyline> polyLineSet = {};
  List<LatLng> pLineCoordinatesList = [];
  BitmapDescriptor? customMarkerLabIcon;
  BitmapDescriptor? customMarkerPatientIcon;
  BitmapDescriptor? customMarkerRiderIcon;
  bool dataLoaded = false;
  String rideStatus = "accept";
  String riderName = " ";
  String labOtp = '';
  String riderPhone = " ";
  Set<Marker> setOfMarkers = <Marker>{};
  StreamSubscription<DatabaseEvent>? _driverLocationSubscription;

  @override
  void initState() {
    super.initState();
    getDataFromRealtime();
    createCustomMarker();
    listenToDriverLocationChanges();
  }

  @override
  void dispose() {
    _driverLocationSubscription?.cancel();
    super.dispose();
  }

  void createCustomMarker() async {
    customMarkerLabIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(10, 10)),
        "assets/icon/labLocation.png");
    customMarkerPatientIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(10, 10)),
        "assets/icon/patientIcon.png");
    customMarkerRiderIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(10, 10)), "assets/icon/rider.png");
  }

  void listenToDriverLocationChanges() {
    _driverLocationSubscription = FirebaseDatabase.instance
        .ref()
        .child(
            "active_labs/${widget.labUid}/${widget.requestId}/driverLocation")
        .onValue
        .listen((event) {
      DataSnapshot dataSnapshot = event.snapshot;
      if (dataSnapshot.value != null) {
        Map<dynamic, dynamic> dataSnapshotValue =
            dataSnapshot.value as Map<dynamic, dynamic>;
        // Access specific values from the driver location
        double latitude = dataSnapshotValue['latitude'];
        double longitude = dataSnapshotValue['longitude'];
        // Print or use the latitude and longitude
        LatLng newPosition = LatLng(latitude, longitude);
        Marker marker = Marker(
          markerId: const MarkerId(
            "new_marker",
          ),
          position: newPosition,
          icon: customMarkerRiderIcon!,
          infoWindow: const InfoWindow(title: "Driver"),
        );
        setOfMarkers.removeWhere(
            (element) => element.markerId == const MarkerId("new_marker"));
        setOfMarkers.add(marker);
        setState(() {});
      }
    });
  }

  Future<void> getDataFromRealtime() async {
    final dataSnapshot = await FirebaseDatabase.instance
        .ref()
        .child("active_labs/${widget.labUid}/${widget.requestId}")
        .once();

    if (dataSnapshot.snapshot.value != null) {
      final dataSnap = dataSnapshot.snapshot.value as Map<dynamic, dynamic>;

      riderLatLng = LatLng(dataSnap["driverInitialLocation"]["initialLatitude"],
          dataSnap["driverInitialLocation"]["initialLongitude"]);
      labLatLng = LatLng(dataSnap["labDetails"]["latitude"],
          dataSnap["labDetails"]["longitude"]);
      patientLatLng = LatLng(dataSnap["patientDetails"]["latitude"],
          dataSnap["patientDetails"]["longitude"]);
      rideStatus = dataSnap["rideStatus"];
      riderName = dataSnap["riderDetails"]["riderName"];
      riderPhone = dataSnap["riderDetails"]["riderPhone"];
      labOtp = dataSnap["labOtp"] ?? "****";
      dataLoaded = true;
      getPolyline();
    } else {
      Fluttertoast.showToast(msg: "Data not found");
    }
  }

  Future<void> getPolyline() async {
    final directionInfoDetails =
        await obtainOriginToDestinationDirectionDetails(
            riderLatLng!, rideStatus == "accept" ? patientLatLng! : labLatLng!);

    if (directionInfoDetails != null) {
      final polylinePoints = PolylinePoints();
      final linePoints =
          polylinePoints.decodePolyline(directionInfoDetails.e_points!);
      pLineCoordinatesList.clear();
      for (final element in linePoints) {
        pLineCoordinatesList.add(LatLng(element.latitude, element.longitude));
      }

      final polyline = Polyline(
        polylineId: const PolylineId("PolylineID"),
        points: pLineCoordinatesList,
        color: Colors.black,
        width: 5,
      );
      polyLineSet.removeWhere(
          (element) => element.polylineId == const PolylineId("PolylineID"));
      polyLineSet.add(polyline);
      setState(() {});
    } else {
      Fluttertoast.showToast(msg: "Please choose a different location");
    }
  }

  RefreshTransitionController refreshTransitionController =
      Get.put(RefreshTransitionController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            DatabaseReference ref = FirebaseDatabase.instance
                .ref("active_labs/${widget.labUid}/${widget.requestId}");

            ref.once().then((DatabaseEvent event) {
              if (!event.snapshot.exists) {
                Get.offAll(() => const HomePage());
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  backgroundColor: Colors.green,
                  content: Text("This ride has been completed"),
                ));
              } else {
                getDataFromRealtime();
              }
            });

            refreshTransitionController.rotateIcon();
          },
          child: Obx(() => RotationTransition(
              turns: AlwaysStoppedAnimation(
                  refreshTransitionController.rotateTransition.value ? 1 : 0),
              child: const Icon(Icons.refresh))),
        ),
        body: WillPopScope(
            onWillPop: () {
              Get.to(const HomePage());
              return Future.value(false);
            },
            child: Stack(
              children: [
                dataLoaded
                    ? GoogleMap(
                        initialCameraPosition: riderLatLng != null
                            ? CameraPosition(target: riderLatLng!, zoom: 14)
                            : const CameraPosition(target: LatLng(0, 0)),
                        polylines: polyLineSet,
                        markers: {
                          Marker(
                            markerId: const MarkerId('lab_location'),
                            position: labLatLng!,
                            infoWindow: const InfoWindow(title: 'Lab Location'),
                            icon: customMarkerLabIcon!,
                          ),
                          Marker(
                            markerId: const MarkerId('patient_location'),
                            position: patientLatLng!,
                            infoWindow:
                                const InfoWindow(title: 'Patient Location'),
                            icon: customMarkerPatientIcon!,
                          ),
                          ...setOfMarkers
                        },
                      )
                    : const Center(child: CircularProgress()),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: deviceHeight! * .25,
                    decoration: const BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15)),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.white30,
                              blurRadius: 18,
                              spreadRadius: .5,
                              offset: Offset(0.6, 0.6))
                        ]),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: deviceWidth! * .05),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    showGeneralDialog(
                                      context: context,
                                      transitionBuilder: (context, animation,
                                          secondaryAnimation, child) {
                                        return BounceInLeft(child: child);
                                      },
                                      pageBuilder: (context, animation,
                                          secondaryAnimation) {
                                        return Builder(
                                          builder: (context) {
                                            return Scaffold(
                                                backgroundColor:
                                                    Colors.transparent,
                                                body: Center(
                                                  child: Container(
                                                    constraints:
                                                        const BoxConstraints(
                                                            maxWidth: 300),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.grey
                                                              .withOpacity(0.5),
                                                          spreadRadius: 2,
                                                          blurRadius: 4,
                                                          offset: const Offset(
                                                              0,
                                                              2), // changes position of shadow
                                                        ),
                                                      ],
                                                    ),
                                                    padding: EdgeInsets.all(16),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        const ListTile(
                                                          title: Text(
                                                              'Cancel This Ride'),
                                                        ),
                                                        const Divider(),
                                                        const SizedBox(
                                                            height: 16),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                          children: [
                                                            ElevatedButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                backgroundColor:
                                                                    Colors
                                                                        .green,
                                                              ),
                                                              child: const Text(
                                                                'Back',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            ),
                                                            ElevatedButton(
                                                              onPressed:
                                                                  () async {
                                                                if (rideStatus ==
                                                                    "accepted") {
                                                                  await FirebaseDatabase
                                                                      .instance
                                                                      .ref(
                                                                          "active_labs/${widget.labUid}/${widget.requestId}")
                                                                      .update({
                                                                    "rideStatus":
                                                                        "cancelled",
                                                                  }).then((value) {
                                                                    Get.off(()=>const TrackSample());

                                                                  });
                                                                } else {
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(const SnackBar(
                                                                          content:
                                                                              Text("Ride Canot be cancelled")));
                                                                }
                                                              },
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                backgroundColor:
                                                                    Colors.red,
                                                              ),
                                                              child: const Text(
                                                                'Cancel',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ));
                                          },
                                        );
                                      },
                                    );
                                  },
                                  icon: Icon(
                                    Icons.more_vert,
                                    color: Colors.white,
                                    size: deviceWidth! * .08,
                                  ))
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(
                                        top: 10, bottom: 10, right: 10),
                                    child: Icon(
                                      Icons.directions_bike_outlined,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    riderName.length >= 15
                                        ? riderName.substring(0, 15)
                                        : riderName,
                                    style: TextStyle(
                                        fontSize: deviceWidth! * .06,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.lightGreenAccent),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: IconButton(
                                      onPressed: () {
                                        _launchPhoneCall(riderPhone);
                                      },
                                      icon: const Icon(
                                        Icons.phone_android_outlined,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              // Replace "digit" with the actual value of each digit of the OTP
                              for (int i = 0; i < labOtp.length; i++)
                                Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: deviceWidth! * .01),
                                  width: deviceWidth! * .07,
                                  // Adjust width and height as needed
                                  height: deviceHeight! * 0.04,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.blue),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    labOtp[i], // Display each digit of the OTP
                                    style: const TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            )));
  }

  /// create function to calling

  Future<void> _launchPhoneCall(String phoneNumber) async {
    //   final Uri phoneCallUri = Uri(scheme: 'tel', path: phoneNumber);
    //   if (await canLaunch(phoneCallUri.toString())) {
    //     await launch(phoneCallUri.toString());
    //   }
    //   else {
    //     throw 'Could not launch $phoneCallUri';
    //   }
    await FlutterPhoneDirectCaller.callNumber(phoneNumber);
  }
}
