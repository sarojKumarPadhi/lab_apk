import 'package:audioplayers/audioplayers.dart' as audio;
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_selector/widget/flutter_multi_select.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jonk_lab/global/color.dart';
import 'package:jonk_lab/global/globalData.dart';
import 'package:jonk_lab/model/test_menu_model.dart';
import 'package:jonk_lab/page/patientLocationPage.dart';
import 'package:jonk_lab/page/searchRiderPage.dart';
import 'package:record/record.dart';

import '../controller/test_menu_controller.dart';

class NewPatient extends StatefulWidget {
  const NewPatient({Key? key}) : super(key: key);

  static String? patientName;
  static String? mobileNumber;
  static String? age;
  static String? tests;
  static String? samples;
  static String? patientLocation;
  static LatLng? latLng;

  @override
  State<NewPatient> createState() => _NewPatientState();
}

class _NewPatientState extends State<NewPatient>
    with SingleTickerProviderStateMixin {
  String audioPath = "";
  late Record audioRecord;
  late AudioPlayer audioPlayer;
  bool isRecording = false;
  late AnimationController _controller;
  final nameTextEditing = TextEditingController();
  final mobileTextEditing = TextEditingController();
  final ageTextEditing = TextEditingController();
  final testTextEditing = TextEditingController();
  final sampleTextEditing = TextEditingController();
  TestMenuController testMenuController = Get.find();

  @override
  void initState() {
    audioPlayer = AudioPlayer();
    audioRecord = Record();
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    NewPatient.patientName != null
        ? nameTextEditing.text = NewPatient.patientName!
        : "";
    NewPatient.mobileNumber != null
        ? mobileTextEditing.text = NewPatient.mobileNumber!
        : "";
    NewPatient.age != null ? ageTextEditing.text = NewPatient.age! : "";
    NewPatient.tests != null ? testTextEditing.text = NewPatient.tests! : "";
    NewPatient.samples != null
        ? sampleTextEditing.text = NewPatient.samples!
        : "";
  }

  @override
  void dispose() {
    audioRecord.dispose();
    audioPlayer.dispose();
    super.dispose();
  }

  Future<void> startRecording() async {
    try {
      if (await audioRecord.hasPermission()) {
        await audioRecord.start();
        setState(() {
          isRecording = true;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> stopRecording() async {
    try {
      String? path = await audioRecord.stop();
      setState(() {
        isRecording = false;
        audioPath = path!;
      });
      // await uploadAudioToFirebaseStorage();
    } catch (e) {
      print(e);
    }
  }

  Future<void> playRecording() async {
    try {
      audio.Source urlSource = UrlSource(audioPath);
      await audioPlayer.play(urlSource);
    } catch (e) {
      print("playing $e");
    }
  }

  List<dynamic> selectedDataString = [];
  int totalPrice = 0;
  List<TestMenuModel> selectedTestMenu = [];

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height; //834
    var width = MediaQuery.of(context).size.width; //392
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: Text(
          "New Ride",
          style:
              GoogleFonts.acme(fontSize: deviceWidth! * .06, letterSpacing: 1),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: deviceWidth! * .04),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: const Color(0xFF111111),
                    elevation: 10,
                    shadowColor: Colors.black),
                onPressed: () async {
                  if (nameTextEditing.text.isNotEmpty &&
                      mobileTextEditing.text.isNotEmpty &&
                      ageTextEditing.text.isNotEmpty &&
                      testTextEditing.text.isNotEmpty &&
                      sampleTextEditing.text.isNotEmpty &&
                      NewPatient.patientLocation!.isNotEmpty) {
                    NewPatient.patientName = nameTextEditing.text;
                    NewPatient.mobileNumber = mobileTextEditing.text;
                    NewPatient.age = ageTextEditing.text;
                    NewPatient.samples = sampleTextEditing.text;
                    NewPatient.tests = testTextEditing.text;

                    Get.to(() => SearchRiderPage(),
                        transition: Transition.leftToRight,
                        duration: Duration(milliseconds: 500));
                  } else {
                    Fluttertoast.showToast(msg: "Enter all fields");
                  }
                },
                child: Text(
                  "Book Rider",
                  style: GoogleFonts.acme(
                      color: Colors.white, fontSize: deviceWidth! * .05),
                )),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: ListView(
          children: [
            SizedBox(
              height: height * 13 / 100,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10, bottom: 5),
                        child: Text(
                          "Patient Name",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: width * 3.9 / 100),
                        ),
                      )
                    ],
                  ),
                  Container(
                    height: height * 7 / 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(deviceWidth! * .01),
                      color: const Color(0xFFE7E3E3),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: TextField(
                        controller: nameTextEditing,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Name",
                            hintStyle: TextStyle(
                                fontSize: width * 3.9 / 100,
                                color: const Color(0xFFC0C0C0))),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: height * 13 / 100,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10, bottom: 5),
                        child: Text(
                          "Mobile Number*",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: width * 3.9 / 100),
                        ),
                      )
                    ],
                  ),
                  Container(
                    height: height * 7 / 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(deviceWidth! * .01),
                      color: const Color(0xFFE7E3E3),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: TextField(
                        controller: mobileTextEditing,
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "+91",
                            hintStyle: TextStyle(
                                fontSize: width * 3.9 / 100,
                                color: const Color(0xFFC0C0C0))),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: height * 13 / 100,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10, bottom: 5),
                        child: Text(
                          "Age*",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: width * 3.9 / 100),
                        ),
                      )
                    ],
                  ),
                  Container(
                    height: height * 7 / 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(deviceWidth! * .01),
                      color: const Color(0xFFE7E3E3),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: TextField(
                        controller: ageTextEditing,
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Patient age",
                            hintStyle: TextStyle(
                                fontSize: width * 3.9 / 100,
                                color: const Color(0xFFC0C0C0))),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10, bottom: 5),
                  child: Text(
                    "Test*",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: width * 3.9 / 100),
                  ),
                )
              ],
            ),
            Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(deviceWidth! * .01),
                  // Set border radius
                  color: const Color(0xFFE7E3E3), // Set fill color
                ),
                child: Obx(
                  () => CustomMultiSelectField<String>(
                    decoration: InputDecoration(
                      suffixText: "$totalPrice ₹",
                      border: InputBorder.none, // Set border to none
                      filled: true,
                      fillColor:
                          Colors.transparent, // Set transparent fill color
                    ),
                    selectedItemColor: Colors.red,
                    title: "Test",
                    items: testMenuController.testMenuList
                        .map((e) => e.testName)
                        .toList(),
                    enableAllOptionSelect: true,
                    onSelectionDone: _onCountriesSelectionComplete,
                    itemAsString: (item) => item.toString(),
                  ),
                )),
            SizedBox(
              height: deviceHeight! * .02,
            ),
            SizedBox(
              height: height * 13 / 100,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10, bottom: 5),
                        child: Text(
                          "patient location*",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: width * 3.9 / 100),
                        ),
                      )
                    ],
                  ),
                  Container(
                    height: height * 7 / 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(deviceWidth! * .01),
                      color: const Color(0xFFE7E3E3),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: TextField(
                          onTap: () {
                            NewPatient.patientName = nameTextEditing.text;
                            NewPatient.mobileNumber = mobileTextEditing.text;
                            NewPatient.age = ageTextEditing.text;
                            NewPatient.tests = testTextEditing.text;
                            NewPatient.samples = sampleTextEditing.text;
                            Get.to(() => const PatientLocationPage());
                          },
                          readOnly: true,
                          cursorColor: Colors.black,
                          maxLines: 3,
                          decoration: NewPatient.patientLocation == null
                              ? InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Address",
                                  hintStyle: TextStyle(
                                      fontSize: width * 3.9 / 100,
                                      color: const Color(0xFFC0C0C0)))
                              : InputDecoration(
                                  border: InputBorder.none,
                                  hintText: NewPatient.patientLocation,
                                  hintStyle: TextStyle(
                                      fontSize: width * 3.9 / 100,
                                      color: Colors.black))),
                    ),
                  )
                ],
              ),
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10, bottom: 5),
                      child: Text(
                        "Voice Description",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: width * 3.9 / 100),
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (isRecording) const Text("Recording"),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            primaryColor, // Set the background color
                      ),
                      onPressed: isRecording ? stopRecording : startRecording,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ScaleTransition(
                              scale: Tween<double>(begin: 1.0, end: 1.2)
                                  .animate(_controller),
                              child: Icon(
                                isRecording ? Icons.stop : Icons.mic,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              isRecording
                                  ? 'Stop Recording'
                                  : 'Start Recording',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    if (!isRecording && audioPath != null)
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.green, // Set the background color
                          ),
                          onPressed: playRecording,
                          child: const Icon(
                            Icons.speaker_phone,
                            color: Colors.white,
                          ))
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onCountriesSelectionComplete(value) {
    if (kDebugMode) {
      print(value.toString());
    }

    // Get the list of selected test names
    List<String> selectedTestNames = List.from(value);

    // Clear the selected test menu
    selectedTestMenu.clear();

    // Reset the total price to zero
    totalPrice = 0;

    // Iterate over each test menu model
    testMenuController.testMenuList.forEach((TestMenuModel testMenuModel) {
      // Check if the test name is selected
      if (selectedTestNames.contains(testMenuModel.testName)) {
        // Add the test menu model to the selected test menu
        selectedTestMenu.add(testMenuModel);

        // Add the price to the total price
        totalPrice += int.parse(testMenuModel.testPrice);
      }
    });

    // Trigger a UI update
    setState(() {});
  }
}
