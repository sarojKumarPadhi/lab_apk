import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jonk_lab/global/color.dart';
import 'package:jonk_lab/page/newPatient.dart';


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
            markers: {
              customMarker != null
                  ? Marker(
                      icon: customMarker!,
                      markerId: const MarkerId('picked-location'),
                      position: _pickedLocation,
                      consumeTapEvents:
                          true, // Fixed marker, won't respond to tap events
                    )
                  : Marker(
                      icon: BitmapDescriptor.defaultMarker,
                      markerId: const MarkerId('picked-location'),
                      position: _pickedLocation,
                      consumeTapEvents:
                          true, // Fixed marker, won't respond to tap events
                    ),
            },
            onMapCreated: (GoogleMapController controller) {},
            onTap: (LatLng location) {
              setState(() {
                _pickedLocation = location;
                NewPatient.latLng=location;
              });
              latLngToAddress(location);
            },
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
                              onPressed: () {
                                NewPatient.patientLocation =
                                    "${street ?? ""}, ${subLocality ?? ""}, ${locality ?? ""}, ${administrativeArea ?? ""}, ${pinCode ?? ""}";
                                // newSampleDataModel.latLng = _pickedLocation;
                                Get.to(() =>  NewPatient());
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
}
