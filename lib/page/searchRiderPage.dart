import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jonk_lab/component/checkLatestRide.dart';
import 'package:jonk_lab/global/color.dart';
import 'package:jonk_lab/global/globalData.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:quickalert/quickalert.dart';
import 'package:uuid/uuid.dart';

import '../controller/lab_basic_details.dart';
import '../controller/push_notification_controller.dart';
import '../controller/searching_rider_controller.dart';
import '../model/active_nearby_available_drivers.dart';
import '../model/direction_detail_info.dart';
import '../service/pushNotificationService.dart';
import '../services/networkRequest.dart';
import 'homePage.dart';
import 'newPatient.dart';

class SearchRiderPage extends StatefulWidget {
  const SearchRiderPage({super.key});

  @override
  State<SearchRiderPage> createState() => _SearchRiderPageState();
}

class _SearchRiderPageState extends State<SearchRiderPage> {
  PushNotificationService pushNotificationService = PushNotificationService();

  SearchingRideController searchingRideController =
      Get.put(SearchingRideController());
  LabBasicDetailsController labBasicDetailsController = Get.find();
  PushNotificationController pushNotificationController =
      Get.put(PushNotificationController());
  BitmapDescriptor? customMarkerLabIcon;
  BitmapDescriptor? customMarkerPatientIcon;
  BitmapDescriptor? customMarkerRiderIcon;

  List<LatLng> pLineCoordinatesList = [];
  Set<Polyline> polyLineSet = {};
  var uuid = const Uuid();
  final ScrollController _scrollController = ScrollController();
  Timer? _timer;
  String? uId;
  bool? isRideBook;

  Set<Marker> driversMarkerSet = <Marker>{};

  checkRide() async {
    isRideBook = await checkLatestRide();
    setState(() {});
  }

  @override
  void initState() {
    initializeGeofireListener();
    checkRide();
    super.initState();
    getPolyline();
    createCustomMarker();
    uId = uuid.v1();
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  sendDataInRealTimeDataBase() async {
    // DatabaseReference ref = FirebaseDatabase.instance.ref();
    DatabaseReference ref = FirebaseDatabase.instance.ref("active_labs/$uId");
    latestRideId = uId!;
    await ref.set({
      "rideStatus": "idle",
      "labDetails": {
        "labName": labBasicDetailsController
            .labBasicDetailsData.value.basicDetails!.labName,
        "labLocation": labBasicDetailsController
            .labBasicDetailsData.value.address!.labLocation,
        "latitude": labBasicDetailsController
            .labBasicDetailsData.value.address!.geoPoint.latitude,
        "longitude": labBasicDetailsController
            .labBasicDetailsData.value.address!.geoPoint.latitude
      },
      "patientDetails": {
        "latitude": NewPatient.latLng?.latitude,
        "longitude": NewPatient.latLng?.longitude,
        "name": NewPatient.patientName,
        "phone": NewPatient.mobileNumber,
        "age": NewPatient.age,
        "test": NewPatient.tests,
        "location": NewPatient.patientLocation
      },
    }).then((value) {
      List<String> devicesTokens =
          pushNotificationController.deviceToken.toSet().toList();
      pushNotificationService.sendPushNotification(
          tokens: devicesTokens, rideRequestId: latestRideId!);
    });
  }

  //
  createCustomMarker() async {
    customMarkerLabIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(10, 10)),
        "assets/icon/labLocation.png");
    customMarkerPatientIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(10, 10)),
        "assets/icon/patientIcon.png");
    customMarkerRiderIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(10, 10)), "assets/icon/rider.png");
  }

  getPolyline() async {
    DirectionDetailsInfo? directionInfoDetails =
        await obtainOriginToDestinationDirectionDetails(
            LatLng(
                labBasicDetailsController
                    .labBasicDetailsData.value.address!.geoPoint.latitude,
                labBasicDetailsController
                    .labBasicDetailsData.value.address!.geoPoint.longitude),
            LatLng(NewPatient.latLng!.latitude, NewPatient.latLng!.longitude));

    if (directionInfoDetails != null) {
      PolylinePoints polylinePoints = PolylinePoints();
      List<PointLatLng> linePoints =
          polylinePoints.decodePolyline(directionInfoDetails.e_points!);
      for (var element in linePoints) {
        pLineCoordinatesList.add(LatLng(element.latitude, element.longitude));
        Polyline polyline = Polyline(
            polylineId: const PolylineId("PolylineID"),
            points: pLineCoordinatesList,
            color: Colors.black,
            width: 5);
        polyLineSet.add(polyline);
      }

      setState(() {});
    } else {
      Fluttertoast.showToast(msg: "Please choose a different location");
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    String allTest = NewPatient.tests != null
        ? NewPatient.tests!.join(",")
        : "No Test Selected";

    return Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          iconTheme: const IconThemeData(color: Colors.black),
          title: Text("Search Rider for Pickups",
              style: GoogleFonts.acme(letterSpacing: 1)),
        ),
        body: WillPopScope(
            onWillPop: () => _onBackPressed(context),
            child: Obx(() => Column(
                  children: [
                    Expanded(
                      child: GoogleMap(
                        polylines: polyLineSet,
                        mapType: MapType.normal,
                        markers: <Marker>{
                          customMarkerLabIcon != null
                              ? Marker(
                                  markerId: const MarkerId('lab_location'),
                                  position: LatLng(
                                      labBasicDetailsController
                                          .labBasicDetailsData
                                          .value
                                          .address!
                                          .geoPoint
                                          .latitude,
                                      labBasicDetailsController
                                          .labBasicDetailsData
                                          .value
                                          .address!
                                          .geoPoint
                                          .longitude),
                                  infoWindow: const InfoWindow(
                                    title: 'Lab Location',
                                  ),
                                  icon:
                                      customMarkerLabIcon!, // You can customize the marker icon here
                                )
                              : Marker(
                                  markerId: const MarkerId('patient_location'),
                                  position: LatLng(NewPatient.latLng!.latitude,
                                      NewPatient.latLng!.longitude),
                                  // Position of the marker
                                  infoWindow: const InfoWindow(
                                    title: 'Patient Location',
                                  ),
                                  icon: BitmapDescriptor
                                      .defaultMarker, // You can customize the marker icon here
                                ),
                          customMarkerPatientIcon != null
                              ? Marker(
                                  markerId: const MarkerId('patient_location'),
                                  position: LatLng(NewPatient.latLng!.latitude,
                                      NewPatient.latLng!.longitude),
                                  infoWindow: const InfoWindow(
                                    title: 'Patient Location',
                                  ),
                                  icon:
                                      customMarkerPatientIcon!, // You can customize the marker icon here
                                )
                              : Marker(
                                  markerId: const MarkerId('patient_location'),
                                  position: LatLng(NewPatient.latLng!.latitude,
                                      NewPatient.latLng!.longitude),
                                  infoWindow: const InfoWindow(
                                    title: 'Patient Location',
                                  ),
                                  icon: BitmapDescriptor
                                      .defaultMarker, // You can customize the marker icon here
                                ),
                          ...driversMarkerSet
                        },
                        initialCameraPosition: CameraPosition(
                            zoom: 14,
                            target: labBasicDetailsController
                                        .labBasicDetailsData.value.address !=
                                    null
                                ? LatLng(
                                    labBasicDetailsController
                                        .labBasicDetailsData
                                        .value
                                        .address!
                                        .geoPoint
                                        .latitude,
                                    labBasicDetailsController
                                        .labBasicDetailsData
                                        .value
                                        .address!
                                        .geoPoint
                                        .longitude)
                                : const LatLng(30.7117829, 76.84531799999999)),
                        onMapCreated: (controller) {
                          Future.delayed(
                            const Duration(seconds: 2),
                            () {
                              controller.showMarkerInfoWindow(
                                  const MarkerId('lab_location'));
                              controller.showMarkerInfoWindow(
                                  const MarkerId('patient_location'));

                              controller.animateCamera(
                                  CameraUpdate.newCameraPosition(CameraPosition(
                                      target: LatLng(
                                          labBasicDetailsController
                                              .labBasicDetailsData
                                              .value
                                              .address!
                                              .geoPoint
                                              .latitude,
                                          labBasicDetailsController
                                              .labBasicDetailsData
                                              .value
                                              .address!
                                              .geoPoint
                                              .longitude),
                                      zoom: 15)));
                              Future.delayed(
                                const Duration(seconds: 10),
                                () {
                                  controller.animateCamera(
                                      CameraUpdate.newCameraPosition(
                                          CameraPosition(
                                              target: LatLng(
                                                  NewPatient.latLng!.latitude,
                                                  NewPatient.latLng!.longitude),
                                              zoom: 14)));
                                },
                              );
                            },
                          );

                          // geoFireInitialize();
                        },
                      ),
                    ),
                    isRideBook == true
                        ? Column(
                            children: [
                              SizedBox(
                                height: deviceHeight! * .01,
                              ),
                              FadeInDown(
                                duration: const Duration(milliseconds: 1200),
                                child: Text(
                                  searchingRideController.allSearchShowText[
                                      searchingRideController.textIndex.value],
                                  style: GoogleFonts.acme(
                                      fontSize: deviceWidth! * .06,
                                      color: Colors.black),
                                ),
                              ),
                              SizedBox(
                                height: deviceHeight! * .03,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FadeInLeft(
                                    duration:
                                        const Duration(milliseconds: 1200),
                                    child: LinearPercentIndicator(
                                      width: deviceWidth! * .3,
                                      animation: true,
                                      animationDuration: 10000,
                                      lineHeight: deviceHeight! * .03,
                                      percent: searchingRideController
                                          .firstPercentage.value,
                                      progressColor: Colors.green,
                                      barRadius:
                                          Radius.circular(deviceWidth! * .2),
                                    ),
                                  ),
                                  FadeInDown(
                                    duration:
                                        const Duration(milliseconds: 1200),
                                    child: LinearPercentIndicator(
                                      width: deviceWidth! * .3,
                                      animation: true,
                                      animationDuration: 10000,
                                      lineHeight: deviceHeight! * .03,
                                      percent: searchingRideController
                                          .secondPercentage.value,
                                      progressColor: Colors.green,
                                      barRadius:
                                          Radius.circular(deviceWidth! * .2),
                                    ),
                                  ),
                                  FadeInRight(
                                    duration:
                                        const Duration(milliseconds: 1200),
                                    child: LinearPercentIndicator(
                                      width: deviceWidth! * .3,
                                      animation: true,
                                      animationDuration: 10000,
                                      lineHeight: deviceHeight! * .03,
                                      percent: searchingRideController
                                          .thirdPercentage.value,
                                      progressColor: Colors.green,
                                      barRadius:
                                          Radius.circular(deviceWidth! * .2),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: deviceHeight! * .04,
                              ),
                              FadeInDown(
                                duration: const Duration(milliseconds: 1200),
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        backgroundColor:
                                            const Color(0xFF111111),
                                        elevation: 10,
                                        shadowColor: Colors.black),
                                    onPressed: () async {
                                      QuickAlert.show(
                                        context: context,
                                        type: QuickAlertType.success,
                                        title:
                                            "Are you sure you want to cancel",
                                        onConfirmBtnTap: () async {
                                          await FirebaseDatabase.instance
                                              .ref()
                                              .child(
                                                  "active_labs/$latestRideId")
                                              .remove()
                                              .then((value) {
                                            Get.offAll(() => const HomePage());
                                          });
                                        },
                                        onCancelBtnTap: () {
                                          Navigator.pop(context);
                                        },
                                        showConfirmBtn: true,
                                        showCancelBtn: true,
                                        cancelBtnText: "NO",
                                        confirmBtnText: "YES",
                                      );
                                    },
                                    child: Text(
                                      "Cancel Rider",
                                      style: GoogleFonts.acme(
                                          color: Colors.white,
                                          fontSize: deviceWidth! * .05),
                                    )),
                              )
                            ],
                          )
                        : SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            controller: _scrollController,
                            child: Row(
                              children: [
                                FadeInLeft(
                                  child: Container(
                                    width: deviceWidth! * .8,
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 1,
                                          blurRadius: 3,
                                          offset: const Offset(0,
                                              2), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "All Tests:",
                                          style: TextStyle(
                                            fontSize: deviceWidth! * .05,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          allTest,
                                          style: TextStyle(
                                              fontSize: deviceWidth! * .04),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                FadeInRight(
                                  child: Container(
                                    color: Colors.white,
                                    width: deviceWidth,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        ListTile(
                                          title: Text("Address:",
                                              style: GoogleFonts.acme(
                                                  fontSize:
                                                      deviceWidth! * .05)),
                                          subtitle:
                                              Text(NewPatient.patientLocation!),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  right: deviceWidth! * .1),
                                              child: ElevatedButton(
                                                  onPressed: () {
                                                    isRideBook = true;

                                                    setState(() {});
                                                    sendDataInRealTimeDataBase();
                                                    // showDialog(
                                                    //   context: context,
                                                    //   builder: (context) {
                                                    //     return Column(
                                                    //       children: [
                                                    //     Text(pushNotificationController.allOnlineDriverData[0].
                                                    //       rideStatus,)
                                                    //     ],
                                                    //                                                   );
                                                    //   },
                                                    // );
                                                  },
                                                  child: const Text("Confirm")),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ],
                ))));
  }

  initializeGeofireListener() async {
    Geofire.initialize("activeDrivers");
    Geofire.queryAtLocation(
            NewPatient.latLng!.latitude, NewPatient.latLng!.longitude, 10)!
        .listen((map) {
      if (map != null) {
        var callBack = map['callBack'];

        switch (callBack) {
          case Geofire.onKeyEntered:
            ActiveNearbyAvailableDrivers activeNearbyAvailableDriver =
                ActiveNearbyAvailableDrivers();
            activeNearbyAvailableDriver.locationLatitude = map['latitude'];
            activeNearbyAvailableDriver.locationLongitude = map['longitude'];
            activeNearbyAvailableDriver.driverId = map['key'];
            pushNotificationController.riderUid.add(map['key']);
            GeoFireAssistant.activeNearbyAvailableDriversList
                .add(activeNearbyAvailableDriver);
            // if (activeNearbyDriverKeysLoaded == true) {
            displayActiveDriversOnUsersMap();
            // }
            break;

          //whenever any driver become non-active/offline
          case Geofire.onKeyExited:
            GeoFireAssistant.deleteOfflineDriverFromList(map['key']);
            pushNotificationController.riderUid.remove(map['key']);
            displayActiveDriversOnUsersMap();
            print("whenever any driver become non-active/offline");
            break;

          //whenever driver moves - update driver location
          case Geofire.onKeyMoved:
            ActiveNearbyAvailableDrivers activeNearbyAvailableDriver =
                ActiveNearbyAvailableDrivers();
            activeNearbyAvailableDriver.locationLatitude = map['latitude'];
            activeNearbyAvailableDriver.locationLongitude = map['longitude'];
            activeNearbyAvailableDriver.driverId = map['key'];
            GeoFireAssistant.updateActiveNearbyAvailableDriverLocation(
                activeNearbyAvailableDriver);
            displayActiveDriversOnUsersMap();
            print("whenever driver moves - update driver location");
            break;

          //display those online/active drivers on user's map
          case Geofire.onGeoQueryReady:
            displayActiveDriversOnUsersMap();
            break;
        }
        setState(() {});
      }
    });
  }

  displayActiveDriversOnUsersMap() {
    driversMarkerSet.clear();
    for (ActiveNearbyAvailableDrivers eachDriver
        in GeoFireAssistant.activeNearbyAvailableDriversList) {
      LatLng eachDriverPosition =
          LatLng(eachDriver.locationLatitude!, eachDriver.locationLongitude!);
      Marker eachDriverMarker = Marker(
          infoWindow: const InfoWindow(),
          rotation: 360,
          icon: customMarkerRiderIcon!,
          markerId: MarkerId(eachDriver.driverId!),
          position: eachDriverPosition);
      driversMarkerSet.add(eachDriverMarker);
    }
  }

  Future<bool> _onBackPressed(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: Text(
            'Confirm Exit',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Are you sure you want to exit?',
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await FirebaseDatabase.instance
                      .ref()
                      .child("active_labs")
                      .child(latestRideId!)
                      .remove()
                      .then((value) {
                    Get.offAll(() => const HomePage());
                  });
                } catch (e) {
                  Get.offAll(() => const HomePage());
                }
              },
              child: const Text(
                'Exit',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
