import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jonk_lab/global/color.dart';
import 'package:jonk_lab/global/globalData.dart';
import 'package:jonk_lab/page/newPatient.dart';
import 'package:jonk_lab/page/pick_location_from_map.dart';
import '../controller/lab_basic_details.dart';
import '../controller/ride_price_controller.dart';
import '../controller/rider_price_controller.dart';
import '../model/direction_detail_info.dart';
import '../model/predected_place.dart';
import '../services/networkRequest.dart';

class PatientLocationPage extends StatefulWidget {
  const PatientLocationPage({super.key});

  @override
  State<PatientLocationPage> createState() => _PatientLocationPageState();
}

class _PatientLocationPageState extends State<PatientLocationPage> {
  List<PredictedPlaces> predictedList = [];
  LabBasicDetailsController labBasicDetailsController = Get.find();
  PriceController priceController = Get.put(PriceController());
  RidePriceController ridePriceController = Get.put(RidePriceController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: Text("Search Patient Location",
            style: GoogleFonts.acme(letterSpacing: 1)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
              onChanged: (value) async {
                if (value.isNotEmpty) {
                  String mapKey = "AIzaSyCudnOm2h7hs1412HqGRn58uFpLn6Pdw18";
                  String apiUrl =
                      "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$value&key=$mapKey&components=country:IN";
                  var result = await apiRequest(apiUrl);
                  if (result != "response error") {
                    List<PredictedPlaces> listData = (result["predictions"]
                            as List)
                        .map((jsonData) => PredictedPlaces.fromJson(jsonData))
                        .toList();
                    predictedList = listData;
                    setState(() {});
                  }
                } else {
                  predictedList.clear();
                  setState(() {});
                }
              },
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.location_pin),
                  hintText: "Search Patient Location",
                  enabledBorder: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder()),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton.icon(
                      onPressed: () {
                        Get.to(() => const PickLocationFromMap());
                      },
                      icon: const Icon(
                        Icons.fmd_good_rounded,
                        color: Colors.red,
                      ),
                      label: Text(
                        "Select from map",
                        style: GoogleFonts.acme(),
                      )),
                ),
              ],
            ),
            Expanded(
              child: predictedList.isNotEmpty
                  ? ListView.builder(
                      itemCount: predictedList.length,
                      itemBuilder: (context, index) => InkWell(
                        onTap: () async {
                          NewPatient.patientLocation =
                              predictedList[index].main_text! +
                                  predictedList[index].secondary_id!;
                          String mapUrl =
                              "AIzaSyCudnOm2h7hs1412HqGRn58uFpLn6Pdw18";
                          String apiUrl =
                              "https://maps.googleapis.com/maps/api/place/details/json?place_id=${predictedList[index].place_id!}&key=$mapUrl";
                          LatLng? result = await apiRequestForLatLng(apiUrl);
                          NewPatient.latLng =
                              LatLng(result!.latitude, result.longitude);
                          print(result.toString());
                          await getDistanceBetweenPoints(
                              LatLng(result.latitude, result.longitude));
                          Get.back();
                        },
                        child: ListTile(
                          title: Text(predictedList[index].main_text ?? ""),
                          subtitle:
                              Text(predictedList[index].secondary_id ?? ""),
                        ),
                      ),
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search,
                            size: deviceWidth! * .15,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Search a location',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
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
    NewPatient.riderPrice =
        priceController.price.value.toString();
  }
}
