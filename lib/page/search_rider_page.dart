import 'dart:async';
import 'dart:math';
import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jonk_lab/controller/new_ride_controller.dart';
import 'package:jonk_lab/global/color.dart';
import 'package:jonk_lab/global/globalData.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:quickalert/quickalert.dart';
import 'package:uuid/uuid.dart';
import '../controller/lab_basic_details.dart';
import '../controller/listen_accepted_ride_controller.dart';
import '../controller/push_notification_controller.dart';
import '../controller/rider_price_controller.dart';
import '../controller/searching_rider_controller.dart';
import '../controller/test_samples_controller.dart';
import '../model/active_nearby_available_drivers.dart';
import '../model/direction_detail_info.dart';
import '../service/push_notification_service.dart';
import '../services/networkRequest.dart';
import 'homePage.dart';
import 'new_patient.dart';

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
  NewRideController newRideController = Get.find();
  PushNotificationController pushNotificationController =
      Get.put(PushNotificationController());
  PriceController priceController = Get.put(PriceController());
  TestSamplesController testSamplesController = Get.find();
  BitmapDescriptor? customMarkerLabIcon;
  BitmapDescriptor? customMarkerPatientIcon;
  BitmapDescriptor? customMarkerRiderIcon;

  ListenAcceptedRideController listenAcceptedRideController =
      Get.put(ListenAcceptedRideController());

  List<LatLng> pLineCoordinatesList = [];
  Set<Polyline> polyLineSet = {};
  var uuid = const Uuid();
  final ScrollController _scrollController = ScrollController();
  Timer? _timer;
  String? uId;
  bool? isRideBook;

  StreamSubscription<dynamic>? _geofireSubscription;
  Set<Marker> driversMarkerSet = <Marker>{};


  @override
  void initState() {
    initializeGeofireListener();
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
  Future<DateTime> date() async {
    DateTime dateTime = DateTime.now();
    return dateTime;
  }
  sendDataInRealTimeDataBase() async {
    String? deviceToken = await FirebaseMessaging.instance.getToken();
    String currentUid = FirebaseAuth.instance.currentUser!.uid;
    DatabaseReference ref =
        FirebaseDatabase.instance.ref("active_labs/$currentUid/$uId");
    List<Map<String, dynamic>> patientListJson = newRideController.patientListAfterSelection
        .map((patient) => {
              "id": patient.id,
              "name": patient.name,
              "age": patient.age,
              "gender": patient.gender,
              "phone": patient.phone,
              "samples": List.from(patient.sampleList).toList()
            })
        .toList();
// Now you can include patientListJson in your data to be sent to Firebase
    latestRideId = uId!;
    await ref.set({
      "rideStatus": "idle",
      "requestId": uId!,
      "dateTime": (await date()).toString(),
      "labDetails": {
        "phoneNumber": labBasicDetailsController
            .labBasicDetailsData.value.phoneNumber
            ?.replaceAll("+91", ""),
        "deviceToken": deviceToken!,
        "labName": labBasicDetailsController
            .labBasicDetailsData.value.basicDetails!.labName,
        "labLocation": labBasicDetailsController
            .labBasicDetailsData.value.address!.labLocation,
        "latitude": labBasicDetailsController
            .labBasicDetailsData.value.address!.geoPoint.latitude,
        "longitude": labBasicDetailsController
            .labBasicDetailsData.value.address!.geoPoint.longitude
      },
      "patientDetails": {
        "latitude": newRideController.patientLatLng?.latitude,
        "longitude": newRideController.patientLatLng?.longitude,
        "patientList": patientListJson,
        "location": newRideController.patientActualLocation.value,
        "patientLocation": newRideController.patientLocation.value,
        "totalDistance": totalDistance,
        "labPrice": newRideController.labPrice.value,
        "riderPrice": priceController.price.value.toString(),
        "audioUrl": NewPatient.audioUrl
      },
    }).then((value) async {
      List<String> devicesTokens =
          pushNotificationController.deviceToken.toSet().toList();
      pushNotificationService.sendPushNotification(
          tokens: devicesTokens,
          rideRequestId: latestRideId!,
          labUid: currentUid);

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
            LatLng(newRideController.patientLatLng!.latitude,
                newRideController.patientLatLng!.longitude));

    if (directionInfoDetails != null) {
      /// initialize total distance in global variable
      totalDistance = directionInfoDetails.distance_value;

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
    _geofireSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

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
                                  position: LatLng(
                                      newRideController.patientLatLng!.latitude,
                                      newRideController
                                          .patientLatLng!.longitude),
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
                                  position: LatLng(
                                      newRideController.patientLatLng!.latitude,
                                      newRideController
                                          .patientLatLng!.longitude),
                                  infoWindow: const InfoWindow(
                                    title: 'Patient Location',
                                  ),
                                  icon:
                                      customMarkerPatientIcon!, // You can customize the marker icon here
                                )
                              : Marker(
                                  markerId: const MarkerId('patient_location'),
                                  position: LatLng(
                                      newRideController.patientLatLng!.latitude,
                                      newRideController
                                          .patientLatLng!.longitude),
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
                                                  newRideController
                                                      .patientLatLng!.latitude,
                                                  newRideController
                                                      .patientLatLng!
                                                      .longitude),
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
                                          String labUid = FirebaseAuth
                                              .instance.currentUser!.uid;
                                          await FirebaseDatabase.instance
                                              .ref()
                                              .child(
                                                  "active_labs/$labUid/$latestRideId")
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
                                    height: deviceHeight! * .2,
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.black87,
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(10)),
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
                                    child: ListView.builder(
                                      itemCount: newRideController.patientListAfterSelection.length,
                                      itemBuilder: (context, index) {
                                        return ListTile(
                                          title: Text(
                                            newRideController.patientListAfterSelection[index].name!,
                                            style: GoogleFonts.acme(
                                                color: Colors.white,
                                                fontSize: deviceWidth! * .06),
                                          ),
                                          subtitle:Text(
                                            newRideController.patientListAfterSelection[index].sampleList!.join(','),
                                            style: GoogleFonts.acme(
                                                color: Colors.white,
                                                fontSize: deviceWidth! * .04),
                                          ) ,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                FadeInRight(
                                  child: Container(
                                    color: Colors.white,
                                    width: deviceWidth,
                                    height: deviceHeight! * .2,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        ListTile(
                                          title: Text("Address:",
                                              style: GoogleFonts.acme(
                                                  fontSize:
                                                      deviceWidth! * .05)),
                                          subtitle: Text(newRideController
                                              .patientActualLocation.value),
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

                                                    listenAcceptedRideController
                                                        .listenDataMethod();
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
    _geofireSubscription = Geofire.queryAtLocation(
            newRideController.patientLatLng!.latitude,
            newRideController.patientLatLng!.longitude,
            10)!
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
          title: const Text(
            'Confirm Exit',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
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
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                try {
                  String labUid = FirebaseAuth.instance.currentUser!.uid;
                  await FirebaseDatabase.instance
                      .ref()
                      .child("active_labs/$labUid/$latestRideId")
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
