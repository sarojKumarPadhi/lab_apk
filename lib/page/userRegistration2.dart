import 'package:animate_do/animate_do.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jonk_lab/global/color.dart';
import 'package:jonk_lab/page/userRegistration3.dart';

import '../controller/registration_lab_location_controller.dart';
import '../global/globalData.dart';
import '../model/predected_place.dart';
import '../permission_handler/device_location_permission.dart';
import '../services/networkRequest.dart';

final _formKey = GlobalKey<FormState>();

class UserRegistration2 extends StatefulWidget {
  const UserRegistration2({super.key});

  @override
  State<UserRegistration2> createState() => _UserRegistration2State();
}

class _UserRegistration2State extends State<UserRegistration2> {
  final labLocationController = TextEditingController();
  final selectedLabLocationController = TextEditingController();
  RegistrationLabLocationController registrationLabLocationController =
      Get.put(RegistrationLabLocationController());
  GetStorage getStorage = GetStorage();
  List<PredictedPlaces> predictedList = [];
  double? latitude;
  double? longitude;
  String? deviceToken;

  @override
  initState() {
    deviceLocationPermissions();
    super.initState();
    Map<String, dynamic> mapData =
        getStorage.read("labLatLongWithLocation") ?? {};
    if (mapData["labLocation"] != null) {
      selectedLabLocationController.text = mapData["labLocation"];
    }
    if (mapData["latitude"] != null) {
      latitude = mapData["latitude"];
    }
    if (mapData["longitude"] != null) {
      longitude = mapData["longitude"];
    }
    getDeviceToken();
  }

  getDeviceToken() async {
    deviceToken = (await FirebaseMessaging.instance.getToken())!;
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("Set Lab Location",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            )),
      ),
      body: FadeInUp(
        duration: const Duration(milliseconds: 3000),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: TextFormField(
                controller: selectedLabLocationController,
                readOnly: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    focusedBorder: InputBorder.none,
                    hintText: "Selected Address",
                    filled: true,
                    fillColor: Colors.grey[200],
                    hintStyle: const TextStyle(color: Colors.black)),
              ),
            ),
            SizedBox(
              height: deviceHeight * .02,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Form(
                key: _formKey,
                child: TextFormField(
                  onChanged: (value) async {
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
                  },
                  controller: labLocationController,
                  decoration: const InputDecoration(
                      hintText: "Search You Lab",
                      suffixIcon: Icon(Icons.search),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey))),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Search You Lab";
                    }
                    return null;
                  },
                ),
              ),
            ),
            Expanded(
                child: predictedList.isNotEmpty
                    ? ListView.separated(
                        itemBuilder: (context, index) {
                          return Card(
                            elevation: 4,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(16),
                              title: Text(
                                predictedList[index].main_text!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.orange,
                                ),
                              ),
                              subtitle: Text(
                                predictedList[index].secondary_id!,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              leading: const Icon(
                                Icons.location_on,
                                color: Colors.orange,
                              ),
                              trailing: const Icon(
                                Icons.arrow_forward,
                                color: Colors.orange,
                              ),
                              onTap: () async {
                                selectedLabLocationController.text =
                                    "${predictedList[index].main_text!} ${predictedList[index].secondary_id!}";
                                String apiUrl =
                                    "https://maps.googleapis.com/maps/api/place/details/json?&place_id=${predictedList[index].place_id!}&key=AIzaSyCudnOm2h7hs1412HqGRn58uFpLn6Pdw18";
                                var response = await apiRequest(apiUrl);
                                if (response != "response error") {
                                  latitude = response["result"]["geometry"]
                                      ["location"]["lat"];
                                  longitude = response["result"]["geometry"]
                                      ["location"]["lng"];
                                }
                              },
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox(height: 8);
                        },
                        itemCount: predictedList.length,
                      )
                    : const Center()),
          ],
        ),
      ),
      floatingActionButton: FadeInRight(
        duration: const Duration(milliseconds: 3000),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            FloatingActionButton(
              onPressed: () {
                showGeneralDialog(
                  context: context,
                  barrierDismissible: false,
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return Builder(
                      builder: (context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(deviceWidth! * .02)),
                          title: Text("Location Confirmation"),
                          content: Text(
                              "Make Sure Now you are on your lab Location"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                // Add functionality for confirm button here
                                Navigator.of(context).pop();
                                // Add your confirmation logic here
                                showSetLocationDialog();
                              },
                              child: Text("Confirm"),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text("Cancel"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  transitionBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return ZoomIn(child: child);
                  },
                );
              },
              child: const Icon(Icons.add),
            ),
            FloatingActionButton(
              onPressed: () {
                if (selectedLabLocationController.text.isNotEmpty) {
                  if (latitude != null &&
                      longitude != null &&
                      deviceToken != null) {
                    Map<String, dynamic> mapLocationDetails = {
                      "latitude": latitude!,
                      "longitude": longitude!,
                      "labLocation": selectedLabLocationController.text
                    };
                    getStorage.write(
                        "labLatLongWithLocation", mapLocationDetails);
                    getStorage.write("fcmToken", deviceToken);
                    Get.to(() => const UserRegistration3());
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Please enter lab location from search")));
                }
              },
              backgroundColor: buttonColor,
              child: Icon(Icons.navigate_next,
                  color: Colors.white, size: deviceWidth * .1),
            ),
          ],
        ),
      ),
    );
  }

  showSetLocationDialog() {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      pageBuilder: (context, animation, secondaryAnimation) {
        return Builder(
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(deviceWidth! * .02)),
              title: const Text("Set Lab Location"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: labLocationController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText:
                          "SCO 801, NAC Manimajra, Sector 13, Chandigarh, Panchkula, Chandigarh 160101",
                      hintStyle: TextStyle(fontSize: deviceWidth! * .04),
                      enabledBorder: const OutlineInputBorder(),
                      focusedBorder: const OutlineInputBorder(),
                      fillColor: Colors.white54,
                      filled: true,
                    ),
                  ),
                  SizedBox(
                    height: deviceHeight! * .02,
                  ),
                  Obx(
                    () => TextFormField(
                      readOnly: true,
                      maxLines: 1,
                      decoration: InputDecoration(
                        hintText: registrationLabLocationController
                                    .latitude.value ==
                                0.0
                            ? "30.6543, 76.45678"
                            : "${registrationLabLocationController.latitude.value.toString()}, ${registrationLabLocationController.longitude.value.toString()}",
                        hintStyle: TextStyle(fontSize: deviceWidth! * .04),
                        enabledBorder: const OutlineInputBorder(),
                        focusedBorder: const OutlineInputBorder(),
                        fillColor: Colors.white54,
                        filled: true,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                          style: ButtonStyle(
                              shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          deviceWidth! * .02))),
                              backgroundColor:
                                  MaterialStatePropertyAll(primaryColor)),
                          onPressed: () {
                            registrationLabLocationController.getLocation();
                          },
                          child: const Text(
                            "Get Location",
                            style: TextStyle(color: Colors.white),
                          )),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    if (labLocationController.text.isNotEmpty &&
                        registrationLabLocationController.latitude.value !=
                            0.0 &&
                        registrationLabLocationController.longitude.value !=
                            0.0) {
                      Map<String, dynamic> mapLocationDetails = {
                        "latitude":
                            registrationLabLocationController.latitude.value,
                        "longitude":
                            registrationLabLocationController.longitude.value,
                        "labLocation": labLocationController.text
                      };
                      getStorage.write(
                          "labLatLongWithLocation", mapLocationDetails);
                      getStorage.write("fcmToken", deviceToken);

                      Get.to(() => const UserRegistration3());
                    } else {
                      Fluttertoast.showToast(msg: "Enter all fields");
                    }
                  },
                  child: Text("Confirm"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Cancel"),
                ),
              ],
            );
          },
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ZoomIn(child: child);
      },
    );
  }
}
