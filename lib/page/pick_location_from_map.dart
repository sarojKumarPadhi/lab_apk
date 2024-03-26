import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jonk_lab/controller/lab_basic_details.dart';
import 'package:jonk_lab/global/color.dart';
import 'package:jonk_lab/page/newPatient.dart';

import '../controller/new_ride_controller.dart';
import '../controller/ride_price_controller.dart';
import '../controller/rider_price_controller.dart';
import '../model/direction_detail_info.dart';
import '../services/networkRequest.dart';

class PickLocationFromMap extends StatefulWidget {
  const PickLocationFromMap({Key? key}) : super(key: key);

  @override
  _PickLocationFromMapState createState() => _PickLocationFromMapState();
}

class _PickLocationFromMapState extends State<PickLocationFromMap> {
  late LatLng _pickedLocation;
  BitmapDescriptor? customMarker;
  String? street;
  String? locality;
  String? subLocality;
  String? pinCode;
  String? administrativeArea;
  String? subAdministrativeArea;
  PriceController priceController = Get.put(PriceController());
  LabBasicDetailsController labBasicDetailsController = Get.find();
  RidePriceController ridePriceController = Get.put(RidePriceController());
  NewRideController newRideController = Get.find();

  @override
  void initState() {
    super.initState();
    _pickedLocation = const LatLng(30.6942, 76.8606);
    createMarker();
  }

  createMarker() async {
    customMarker = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(10, 10)), "assets/icon/pin.png");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
      ),
      body: Stack(
        children: [
          GoogleMap(
            compassEnabled: true,
            indoorViewEnabled: true,
            myLocationButtonEnabled: true,
            initialCameraPosition: CameraPosition(
              zoom: 15,
              target: _pickedLocation,
            ),
            onCameraMove: (CameraPosition? position) {
              if (_pickedLocation != position!.target) {
                setState(() {
                  _pickedLocation = position.target;
                });
              }
            },
            onCameraIdle: () async {
              newRideController.patientLatLng = _pickedLocation;
              await getDistanceBetweenPoints(
                  LatLng(_pickedLocation.latitude, _pickedLocation.longitude));
              latLngToAddress(_pickedLocation);
            },
            onMapCreated: (GoogleMapController controller) {},
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 35),
              child: Image.asset(
                "assets/icon/pin.png",
                height: 35,
                width: 35,
              ),
            ),
          ),
          street != null
              ? Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16.0),
                        topRight: Radius.circular(16.0),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 3,
                          blurRadius: 7,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          'Address Details',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                        ),
                        Text(
                          "${street ?? ""}, ${subLocality ?? ""}, ${locality ?? ""}, ${administrativeArea ?? ""}, ${pinCode ?? ""}",
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                newRideController.patientLocation.value =
                                    "${street ?? ""}, ${subLocality ?? ""}, ${locality ?? ""}, ${administrativeArea ?? ""}, ${pinCode ?? ""}";
                                newRideController.patientLocation.value =
                                    "${street ?? ""}, ${subLocality ?? ""}, ${locality ?? ""}, ${administrativeArea ?? ""}, ${pinCode ?? ""}";

                                // newSampleDataModel.latLng = _pickedLocation;
                                Get.to(() => NewPatient());
                              },
                              child: const Text("Confirm"),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                )
              : const SizedBox()
        ],
      ),
    );
  }

  latLngToAddress(LatLng location) async {
    List<Placemark> address =
        await placemarkFromCoordinates(location.latitude, location.longitude);
    street = address.first.street;
    locality = address.first.locality;
    subLocality = address.first.subLocality;
    pinCode = address.first.postalCode;
    administrativeArea = address.first.administrativeArea;
    subAdministrativeArea = address.first.subAdministrativeArea;
    setState(() {});
  }

  getDistanceBetweenPoints(LatLng destinationLatLng) async {
    DirectionDetailsInfo? directionInfoDetails =
        await obtainOriginToDestinationDirectionDetails(
            LatLng(
                labBasicDetailsController
                    .labBasicDetailsData.value.address!.geoPoint.latitude,
                labBasicDetailsController
                    .labBasicDetailsData.value.address!.geoPoint.longitude),
            LatLng(destinationLatLng.latitude, destinationLatLng.longitude));
    DateTime now = DateTime.now();
    int hours = now.hour;
    int kmPrice = hours <= 21
        ? ridePriceController.timeZonePrice.value.day
        : ridePriceController.timeZonePrice.value.night;
    int riderCharges =
        (directionInfoDetails!.distance_value! ~/ 1000 * kmPrice);
    priceController.price.value =
        riderCharges > ridePriceController.minimumRidePrice.value
            ? riderCharges
            : ridePriceController.minimumRidePrice.value;
  }
}
