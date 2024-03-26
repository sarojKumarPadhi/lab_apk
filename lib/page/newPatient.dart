import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jonk_lab/controller/master_list_controller.dart';
import 'package:jonk_lab/global/color.dart';
import 'package:jonk_lab/global/globalData.dart';
import 'package:jonk_lab/page/patientLocationPage.dart';
import 'package:jonk_lab/page/pick_location_from_map.dart';
import 'package:jonk_lab/page/searchRiderPage.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shimmer/shimmer.dart';
import '../controller/new_ride_controller.dart';
import '../controller/ride_price_controller.dart';
import '../controller/rider_price_controller.dart';
import '../controller/test_menu_controller.dart';
import '../controller/test_samples_controller.dart';

class NewPatient extends StatefulWidget {
  const NewPatient({Key? key}) : super(key: key);


  @override
  State<NewPatient> createState() => _NewPatientState();
}

class _NewPatientState extends State<NewPatient>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  TestMenuController testMenuController = Get.find();
  TestSamplesController testSamplesController =
      Get.put(TestSamplesController());
  PriceController distanceController = Get.put(PriceController());
  NewRideController newRideController = Get.put(NewRideController());
  MasterListController masterListController = Get.put(MasterListController());
  RidePriceController ridePriceController = Get.put(RidePriceController());
  PriceController priceController = Get.find();

  @override
  void initState() {
    print("this is a test menu");
    print(testMenuController.testMenuList.length.toString());

    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }



  // List<dynamic> selectedDataString = [];
  // List<TestMenuModel> selectedTestMenu = [];

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
                        FocusScope.of(context).unfocus();
                        newRideController.isNewAddButtonShow.value = true;
                        if(newRideController.labPrice.value!=""){
                          Get.to(()=>const SearchRiderPage());
                        }
                        else{
                          if (masterListController
                              .masterListController.isNotEmpty) {
                            showChoosePatients();
                          }
                        }

                      },
                      child: Text(
                        "Book Rider",
                        style: GoogleFonts.acme(
                            color: Colors.white, fontSize: deviceWidth! * .05),
                      )),
                )
              : const SizedBox())
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: SingleChildScrollView(
          child: Column(
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
                  "SCO 801, NAC Manimajra,Sector 13, Chandigarh,Panchkula, Chandigarh 160101",
                  style: GoogleFonts.acme(
                      fontSize: deviceWidth! * 0.045, color: Colors.black87),
                ),
              ),
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
                      Obx(
                        () => Expanded(
                            child:
                                Text(newRideController.patientLocation.value)),
                      ),
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
              Obx(() => newRideController.patientLocation.value !=
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
                  : const SizedBox()),
              SizedBox(
                height: deviceHeight! * .01,
              ),
              Obx(
                () => newRideController.patientList.isNotEmpty
                    ? ListView.builder(
                        itemCount: newRideController.patientList.length,
                        shrinkWrap: true, // Add shrinkWrap property
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          String sample = List.from(
                                  newRideController.patientList[index].samples!)
                              .join(", ");
                          return ListTile(
                            trailing: IconButton(
                              onPressed: () {
                                QuickAlert.show(
                                  context: context,
                                  type: QuickAlertType.success,
                                  title: "Are you sure you want to delete",
                                  onCancelBtnTap: () {
                                    Navigator.pop(context);
                                  },
                                  confirmBtnText: "yes",
                                  cancelBtnText: "No",
                                  showConfirmBtn: true,
                                  showCancelBtn: true,
                                  onConfirmBtnTap: () {
                                    newRideController
                                        .deleteFromPatientList(index);
                                    Navigator.pop(context);
                                  },
                                );
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.redAccent,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 8.0),
                            title: Row(
                              children: [
                                Text(
                                  newRideController
                                              .patientList[index].name!.length >
                                          12
                                      ? newRideController
                                          .patientList[index].name!
                                          .substring(0, 16)
                                      : newRideController
                                          .patientList[index].name!,
                                  style: TextStyle(
                                    fontSize: deviceWidth! * 0.05,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: deviceWidth! * 0.02),
                                // Adjust the spacing between name and age
                                Text(
                                  newRideController.patientList[index].gender ==
                                          "Male"
                                      ? "(M)"
                                      : "(F)",
                                  style: TextStyle(
                                    fontSize: deviceWidth! * 0.04,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Text(
                              sample,
                              style: TextStyle(
                                fontSize: deviceWidth! * 0.04,
                                // Decreased font size for the subtitle
                                fontWeight: FontWeight.normal,
                                // Set a normal font weight for the subtitle
                                color: Colors.grey[
                                    600], // Adjust text color for subtitle
                              ),
                            ),
                            // You can further customize other properties like leading, trailing, onTap, etc.
                          );
                        },
                      )
                    : const SizedBox(),
              ),
              Obx(() => newRideController.isNewAddButtonShow.value != false
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton(
                          onPressed: () {
                            addNameAge(context);
                          },
                          child: Text(
                            "+ Add New ",
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize: deviceWidth! * .04),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            if (masterListController
                                .masterListController.isNotEmpty) {
                              showChoosePatients();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("No Master List Found")));
                            }
                          },
                          child: Text(
                            "+ Add Existing ",
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize: deviceWidth! * .04),
                          ),
                        ),
                      ],
                    )
                  : const SizedBox()),
              Obx(() => newRideController.patientList.isNotEmpty
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: deviceWidth! * .4,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, bottom: 5),
                                    child: Text(
                                      "Enter Price*",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: deviceWidth! * 3.9 / 100),
                                    ),
                                  )
                                ],
                              ),
                              TextFormField(
                                maxLength: 10,
                                onChanged: (value) {
                                  newRideController.labPrice.value=value;
                                },
                                style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                                cursorColor: Colors.black,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  focusedBorder: OutlineInputBorder(),
                                  enabledBorder: OutlineInputBorder(),
                                  fillColor: Color(0xFFE7E3E3),
                                  filled: true,
                                  border: InputBorder.none,
                                  suffixIcon:
                                      Icon(Icons.currency_rupee_outlined),
                                  prefixStyle:
                                      TextStyle(fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: deviceWidth! * .4,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, bottom: 5),
                                    child: Text(
                                      "Rider Price*",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: deviceWidth! * 3.9 / 100),
                                    ),
                                  )
                                ],
                              ),
                              Obx(() => TextFormField(
                                    maxLength: 10,
                                    readOnly: true,
                                    cursorColor: Colors.black,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      focusedBorder: const OutlineInputBorder(),
                                      enabledBorder: const OutlineInputBorder(),
                                      hintText:
                                          "${distanceController.price.value}",
                                      hintStyle: const TextStyle(color:Colors.black,fontWeight: FontWeight.bold),
                                      fillColor: const Color(0xFFE7E3E3),
                                      filled: true,
                                      border: InputBorder.none,
                                      suffixIcon: const Icon(
                                          Icons.currency_rupee_outlined),
                                      prefixStyle: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ))
                            ],
                          ),
                        ),
                      ],
                    )
                  : const SizedBox()),
              SizedBox(
                height: deviceHeight! * .01,
              ),
              Obx(
                () => newRideController.patientList.isNotEmpty
                    ? Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, bottom: 5),
                                child: Text(
                                  "Voice Message",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: deviceWidth! * 3.9 / 100),
                                ),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (newRideController.isRecording.value) const Text("Recording"),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      primaryColor, // Set the background color
                                ),
                                onPressed: newRideController.isRecording.value
                                    ? newRideController.startRecording
                                    : newRideController.stopRecording,
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ScaleTransition(
                                        scale:
                                            Tween<double>(begin: 1.0, end: 1.2)
                                                .animate(_controller),
                                        child: Icon(
                                          newRideController.isRecording.value ? Icons.stop : Icons.mic,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        newRideController.isRecording.value
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
                              if (!newRideController.isRecording.value && newRideController.audioPath.value != null)
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors
                                          .green, // Set the background color
                                    ),
                                    onPressed: newRideController.listenRecording,
                                    child: const Icon(
                                      Icons.speaker_phone,
                                      color: Colors.white,
                                    ))
                            ],
                          )
                        ],
                      )
                    : const SizedBox(),
              ),
              SizedBox(
                height: deviceHeight! * .05,
              ),
            ],
          ),
        ),
      ),
    );
  }

  addNameAge(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Add Patient Details",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: TextField(
                    onChanged: (value) {
                      newRideController.patientName.value = value;
                    },
                    decoration: const InputDecoration(
                      hintText: "Name",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: TextField(
                    onChanged: (value) {
                      newRideController.patientAge.value = value;
                    },
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: "Age",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: TextField(
                    onChanged: (value) {
                      newRideController.patientPhoneNumber.value = value;
                    },
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: "Phone Number",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Gender',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Obx(
                      () => Row(
                        children: [
                          Radio<String>(
                            value: 'Male',
                            groupValue: newRideController.gender.value,
                            onChanged: (value) {
                              FocusScope.of(context).unfocus();
                              newRideController.gender.value = value!;
                            },
                          ),
                          const Text('Male'),
                          Radio<String>(
                            value: 'Female',
                            groupValue: newRideController.gender.value,
                            onChanged: (value) {
                              FocusScope.of(context).unfocus();
                              newRideController.gender.value = value!;
                            },
                          ),
                          const Text('Female'),
                          Radio<String>(
                            value: 'Other',
                            groupValue: newRideController.gender.value,
                            onChanged: (value) {
                              FocusScope.of(context).unfocus();
                              newRideController.gender.value = value!;
                            },
                          ),
                          const Text('Other'),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              addTestList(context);
                            },
                            style: ButtonStyle(
                                backgroundColor: const MaterialStatePropertyAll(
                                  Colors.black,
                                ),
                                shape: MaterialStatePropertyAll(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            deviceWidth! * .01)))),
                            child: const Text(
                              "Next",
                              style: TextStyle(color: Colors.white),
                            )),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  addTestList(BuildContext context) async {
    testSamplesController.testSamples.clear();
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            // Set column height to minimum
            children: [
              Row(
                children: [
                  Text(
                    "Select Test Samples",
                    style: TextStyle(
                        fontSize: deviceWidth! * .05,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: testMenuController.testMenuList.length,
                  itemBuilder: (context, index) {
                    return Obx(() => Column(
                          children: [
                            ListTile(
                              leading: CachedNetworkImage(
                                imageUrl: testMenuController
                                    .testMenuList[index].imageUrl,
                                width: deviceWidth! * 0.1,
                                height: deviceWidth! * 0.1,
                                placeholder: (context, url) {
                                  return Shimmer.fromColors(
                                      baseColor: Colors.grey[100]!,
                                      highlightColor: Colors.grey[300]!,
                                      child: SizedBox(
                                          width: deviceWidth! * 0.1,
                                          height: deviceWidth! * 0.1));
                                },
                                // Placeholder widget while loading
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons
                                        .error), // Widget to display if image fails to load
                              ),
                              title: Text(
                                testMenuController
                                    .testMenuList[index].testSampleName,
                                style: GoogleFonts.acme(
                                  fontSize: deviceWidth! * 0.05,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                              trailing: Checkbox(
                                value: testSamplesController.testSamples
                                        .contains(testMenuController
                                            .testMenuList[index].testSampleName)
                                    ? true
                                    : false,
                                onChanged: (value) {
                                  testSamplesController.addSample(
                                      testMenuController
                                          .testMenuList[index].testSampleName);
                                },
                              ),
                            ),
                            const Divider(),
                            // Add a divider between items
                          ],
                        ));
                  },
                ),
              ),
              // "Done" button
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: deviceWidth! * .5,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      deviceWidth! * .01))),
                          backgroundColor:
                              const MaterialStatePropertyAll(Colors.black)),
                      onPressed: () {
                        newRideController.addNewPatient(context);
                      },
                      child: Text(
                        "Add",
                        style: GoogleFonts.acme(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  showChoosePatients() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SizedBox(
            height: deviceHeight! * .6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Select Patient Details",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(5)),
                  child: TextField(
                    onChanged: (value) {
                      masterListController.filterData(value);
                    },
                    decoration: const InputDecoration(
                      hintText: "Search by name & phone number",
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                    ),
                  ),
                ),
                Expanded(
                    child: Obx(
                  () => masterListController.masterListController.isNotEmpty
                      ? ListView.builder(
                          itemCount:
                              masterListController.masterListController.length,
                          // Replace this with your actual item count
                          itemBuilder: (context, index) {
                            // Replace this with your actual item widget
                            return ListTile(
                                title: Text(
                                    masterListController
                                        .masterListController[index].name!,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: deviceWidth! * .05)),
                                subtitle: Row(
                                  children: [
                                    Text(
                                      masterListController
                                          .masterListController[index].phone!,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: deviceWidth! * .02,
                                    ),
                                    Text(
                                      "${masterListController.masterListController[index].age!} years",
                                    ),
                                  ],
                                ),
                                trailing: Obx(
                                  () => Checkbox(
                                    value: newRideController.selectedPatientsId
                                        .contains(masterListController
                                            .masterListController[index].id!),
                                    onChanged: (value) {
                                      if (newRideController.selectedPatientsId
                                          .contains(masterListController
                                              .masterListController[index]
                                              .id!)) {
                                        newRideController.selectedPatientsId
                                            .remove(masterListController
                                                .masterListController[index]
                                                .id!);
                                      } else {
                                        newRideController.selectedPatientsId
                                            .add(masterListController
                                                .masterListController[index]
                                                .id!);
                                      }
                                    },
                                  ),
                                ));
                          },
                        )
                      : const Center(
                          child: Text("There is no any master list"),
                        ),
                )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        newRideController.selectedPatientsId.forEach(
                            (element) => newRideController
                                .addNewPatientFromMasterList(element));
                        priceController.price.value +=
                            (newRideController.patientList.length -
                                    1) *
                                ridePriceController.minimumRidePrice.value;
                        Navigator.pop(context);
                        newRideController.selectedPatientsId.clear();
                        FocusScope.of(context).unfocus();
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.black),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                      icon: const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      label: const Text(
                        "Add",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Skip button action
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.red),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                      child: const Text(
                        "Skip",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
