import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
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
import '../controller/searching_rider_controller.dart';
import '../model/direction_detail_info.dart';
import '../services/networkRequest.dart';
import 'homePage.dart';
import 'newPatient.dart';

class SearchRiderPage extends StatefulWidget {
  const SearchRiderPage({super.key});

  @override
  State<SearchRiderPage> createState() => _SearchRiderPageState();
}

class _SearchRiderPageState extends State<SearchRiderPage> {
  SearchingRideController searchingRideController =
      Get.put(SearchingRideController());
  LabBasicDetailsController labBasicDetailsController = Get.find();

  BitmapDescriptor? customMarkerLabIcon;
  BitmapDescriptor? customMarkerPatientIcon;

  List<LatLng> pLineCoordinatesList = [];
  Set<Polyline> polyLineSet = {};
  var uuid = const Uuid();
  final ScrollController _scrollController = ScrollController();
  Timer? _timer;
  String? uId;
  bool? isRideBook;

  checkRide() async {
    isRideBook = await checkLatestRide();
    setState(() {});
  }

  @override
  void initState() {
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

  sendDataInFirebaseFirestore() async {
    // DatabaseReference ref = FirebaseDatabase.instance.ref();
    DatabaseReference ref = FirebaseDatabase.instance.ref(
        "active_labs/${labBasicDetailsController.labBasicDetailsData.value.userId}/$uId");
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
        "samples": NewPatient.samples,
        "location": NewPatient.patientLocation
      },
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

    return Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          iconTheme: const IconThemeData(color: Colors.black),
          title: Text("Search Rider for Pickups",
              style: GoogleFonts.acme(letterSpacing: 1)),
        ),
        body: Obx(() => Column(
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
                                  labBasicDetailsController.labBasicDetailsData
                                      .value.address!.geoPoint.latitude,
                                  labBasicDetailsController.labBasicDetailsData
                                      .value.address!.geoPoint.longitude),
                              // Position of the marker
                              infoWindow: const InfoWindow(
                                title: 'Lab Location',
                              ),
                              // Info window content
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
                              // Info window content
                              icon: BitmapDescriptor
                                  .defaultMarker, // You can customize the marker icon here
                            ),
                      customMarkerPatientIcon != null
                          ? Marker(
                              markerId: const MarkerId('patient_location'),
                              position: LatLng(NewPatient.latLng!.latitude,
                                  NewPatient.latLng!.longitude),
                              // Position of the marker
                              infoWindow: const InfoWindow(
                                title: 'Patient Location',
                              ),
                              // Info window content
                              icon:
                                  customMarkerPatientIcon!, // You can customize the marker icon here
                            )
                          : Marker(
                              markerId: const MarkerId('patient_location'),
                              position: LatLng(NewPatient.latLng!.latitude,
                                  NewPatient.latLng!.longitude),
                              // Position of the marker
                              infoWindow: const InfoWindow(
                                title: 'Patient Location',
                              ),
                              // Info window content
                              icon: BitmapDescriptor
                                  .defaultMarker, // You can customize the marker icon here
                            ),
                    },
                    initialCameraPosition: CameraPosition(
                        zoom: 14,
                        target: labBasicDetailsController
                                    .labBasicDetailsData.value.address !=
                                null
                            ? LatLng(
                                labBasicDetailsController.labBasicDetailsData
                                    .value.address!.geoPoint.latitude,
                                labBasicDetailsController.labBasicDetailsData
                                    .value.address!.geoPoint.longitude)
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
                                      zoom: 14)));
                            },
                          );
                        },
                      );
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
                                duration: const Duration(milliseconds: 1200),
                                child: LinearPercentIndicator(
                                  width: deviceWidth! * .3,
                                  animation: true,
                                  animationDuration: 10000,
                                  lineHeight: deviceHeight! * .03,
                                  percent: searchingRideController
                                      .firstPercentage.value,
                                  progressColor: Colors.green,
                                  barRadius: Radius.circular(deviceWidth! * .2),
                                ),
                              ),
                              FadeInDown(
                                duration: const Duration(milliseconds: 1200),
                                child: LinearPercentIndicator(
                                  width: deviceWidth! * .3,
                                  animation: true,
                                  animationDuration: 10000,
                                  lineHeight: deviceHeight! * .03,
                                  percent: searchingRideController
                                      .secondPercentage.value,
                                  progressColor: Colors.green,
                                  barRadius: Radius.circular(deviceWidth! * .2),
                                ),
                              ),
                              FadeInRight(
                                duration: const Duration(milliseconds: 1200),
                                child: LinearPercentIndicator(
                                  width: deviceWidth! * .3,
                                  animation: true,
                                  animationDuration: 10000,
                                  lineHeight: deviceHeight! * .03,
                                  percent: searchingRideController
                                      .thirdPercentage.value,
                                  progressColor: Colors.green,
                                  barRadius: Radius.circular(deviceWidth! * .2),
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
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    backgroundColor: const Color(0xFF111111),
                                    elevation: 10,
                                    shadowColor: Colors.black),
                                onPressed: () async {
                                  QuickAlert.show(
                                      context: context,
                                      type: QuickAlertType.success,
                                      title: "Are you sure you want to cancel",
                                      onConfirmBtnTap: () async {
                                        await FirebaseDatabase.instance
                                            .ref()
                                            .child("active_labs/"
                                                "${labBasicDetailsController.labBasicDetailsData.value.userId}/$latestRideId")
                                            .remove()
                                            .then((value) {
                                          Get.offAll(() => const HomePage());
                                        });
                                      },
                                      onCancelBtnTap: () {
                                        Navigator.pop(context);
                                      },
                                      showConfirmBtn: true,
                                      showCancelBtn: true);
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
                                color: Colors.grey,
                                width: deviceWidth! * .8,
                                child: Column(
                                  children: [
                                    ListTile(
                                      title: Text("All Test :",
                                          style: GoogleFonts.acme(
                                              fontSize: deviceWidth! * .05)),
                                      subtitle: Text(NewPatient.tests!),
                                    ),
                                    ListTile(
                                      title: Text("Sample :",
                                          style: GoogleFonts.acme(
                                              fontSize: deviceWidth! * .05)),
                                      subtitle: Text(NewPatient.samples!),
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
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    ListTile(
                                      title: Text("Address:",
                                          style: GoogleFonts.acme(
                                              fontSize: deviceWidth! * .05)),
                                      subtitle:
                                          Text(NewPatient.patientLocation!),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              right: deviceWidth! * .1),
                                          child: ElevatedButton(
                                              onPressed: () {
                                                isRideBook = true;

                                                setState(() {});
                                                sendDataInFirebaseFirestore();
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
            )));
  }
}
