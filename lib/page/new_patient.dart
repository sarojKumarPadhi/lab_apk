import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jonk_lab/controller/master_list_controller.dart';
import 'package:jonk_lab/global/color.dart';
import 'package:jonk_lab/global/globalData.dart';
import 'package:jonk_lab/page/new_patient1.dart';
import 'package:jonk_lab/page/patientLocationPage.dart';
import 'package:jonk_lab/page/pick_location_from_map.dart';

import '../controller/lab_basic_details.dart';
import '../controller/new_ride_controller.dart';
import '../controller/ride_price_controller.dart';
import '../controller/rider_price_controller.dart';
import '../controller/test_menu_controller.dart';
import '../controller/test_samples_controller.dart';

class NewPatient extends StatefulWidget {
  const NewPatient({Key? key}) : super(key: key);
  static String audioUrl = "";

  @override
  State<NewPatient> createState() => _NewPatientState();
}

class _NewPatientState extends State<NewPatient>{
  TestMenuController testMenuController = Get.find();
  TestSamplesController testSamplesController =
      Get.put(TestSamplesController());
  PriceController distanceController = Get.put(PriceController());
  NewRideController newRideController = Get.put(NewRideController());
  MasterListController masterListController = Get.put(MasterListController());
  RidePriceController ridePriceController = Get.put(RidePriceController());
  PriceController priceController = Get.find();
  LabBasicDetailsController labBasicDetailsController = Get.find();

  @override
  void initState() {
    print(testMenuController.testMenuList.length.toString());
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: Text(
          "New Ride",
          style:
              GoogleFonts.acme(fontSize: deviceWidth! * .06, letterSpacing: 1),
        ),
        actions: [
          Obx(() => newRideController.patientActualLocation.value.length > 10
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: deviceWidth! * .04),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: const Color(0xFF111111),
                          elevation: 10,
                          shadowColor: Colors.black),
                      onPressed: () {
                        Get.to(() => NewPatient1());
                      },
                      child: Text(
                        "Proceed to Book",
                        style: GoogleFonts.acme(
                            color: Colors.white, fontSize: deviceWidth! * .04),
                      )),
                )
              : const SizedBox())
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: SingleChildScrollView(
            child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 20.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(deviceWidth! * .01),
                    color: Colors.grey[200],
                  ),
                  child: Text(
                    labBasicDetailsController
                            .labBasicDetailsData.value.address?.labLocation ??
                        "",
                    style: GoogleFonts.acme(
                        fontSize: deviceWidth! * 0.045, color: Colors.black87),
                  )),
              SizedBox(height: deviceHeight! * .01),
              Transform.rotate(
                  angle: 1.5708,
                  child: SvgPicture.asset(
                    "assets/icon/source-to-destination.svg",
                    height: deviceHeight! * .05,
                  )),
              SizedBox(height: deviceHeight! * .01),
              InkWell(
                onTap: () {
                  Get.to(() => const PatientLocationPage());
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 20.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(deviceWidth! * .01),
                    color: Colors.grey[200],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Text(newRideController.patientLocation.value)),
                      InkWell(
                        onTap: () {
                          Get.to(() => const PickLocationFromMap());
                        },
                        child: Image.asset("assets/icon/map_location.png",
                            width: deviceWidth! * .15),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: deviceHeight! * .03,
              ),
              newRideController.patientLocation.value !=
                      "Enter Patient Location"
                  ? TextFormField(
                      onChanged: (value) {
                        newRideController.patientActualLocation.value = value;
                      },
                      maxLines: 2,
                      decoration: InputDecoration(
                          fillColor: Colors.grey[200],
                          filled: true,
                          hintText: "Enter Patient Location in details",
                          focusedBorder: const OutlineInputBorder(),
                          enabledBorder: const OutlineInputBorder()),
                    )
                  : const SizedBox(),
            ],
          ),
        )),
      ),
    );
  }
}
