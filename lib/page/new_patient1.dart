import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jonk_lab/page/search_rider_page.dart';
import 'package:shimmer/shimmer.dart';

import '../controller/lab_basic_details.dart';
import '../controller/master_list_controller.dart';
import '../controller/new_ride_controller.dart';
import '../controller/ride_price_controller.dart';
import '../controller/rider_price_controller.dart';
import '../controller/test_menu_controller.dart';
import '../controller/test_samples_controller.dart';
import '../global/color.dart';
import '../global/globalData.dart';
import '../model/patient_data_model.dart';

class NewPatient1 extends StatefulWidget {
  NewPatient1({super.key});

  @override
  State<NewPatient1> createState() => _NewPatient1State();
}

class _NewPatient1State extends State<NewPatient1>
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

  LabBasicDetailsController labBasicDetailsController = Get.find();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showButtonSheet();
    });
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  showButtonSheet() async {
    if (masterListController.masterList.isNotEmpty) {
      showChoosePatients(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          actions: [
            Obx(() => newRideController.labPrice.value != ""
                ? ElevatedButton(
                    style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.black)),
                    onPressed: () {
                      if (newRideController.labPrice.value != "") {
                        List<PatientDataModel> dataAfterSelection =
                            newRideController.patientList
                                .where((element) => newRideController
                                    .checkedPatientsId
                                    .contains(element.id))
                                .toList();
                        newRideController.patientListAfterSelection.value =
                            dataAfterSelection;

                        Get.to(() => const SearchRiderPage());
                      }
                    },
                    child: const Text(
                      "Proceed to book",
                      style: TextStyle(color: Colors.white),
                    ))
                : const SizedBox())
          ],
        ),
        body: ColorfulSafeArea(
            child: Column(
          children: [
            Obx(
              () => newRideController.patientList.isNotEmpty
                  ? Expanded(
                      child: Container(
                        color: Colors.black26,
                        child: ListView.builder(
                          itemCount: newRideController.patientList.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: ListTile(
                                leading: Obx(() => Checkbox(
                                      value: newRideController.checkedPatientsId
                                          .contains(newRideController
                                              .patientList[index].id),
                                      onChanged: (value) {
                                        newRideController.checkUncheck(
                                            newRideController
                                                .patientList[index].id!);
                                      },
                                    )),
                                trailing: IconButton(
                                  icon: const Icon(
                                    Icons.more_vert,
                                    color: Colors.black87,
                                  ),
                                  onPressed: () {
                                    showGeneralDialog(
                                      context: context,
                                      transitionBuilder: (context, animation,
                                          secondaryAnimation, child) {
                                        return BounceInLeft(child: child);
                                      },
                                      pageBuilder: (context, animation,
                                          secondaryAnimation) {
                                        return Builder(
                                          builder: (context) {
                                            return Scaffold(
                                                backgroundColor:
                                                    Colors.transparent,
                                                body: Center(
                                                  child: Container(
                                                    constraints: BoxConstraints(
                                                        maxWidth: 300),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.grey
                                                              .withOpacity(0.5),
                                                          spreadRadius: 2,
                                                          blurRadius: 4,
                                                          offset: const Offset(
                                                              0,
                                                              2), // changes position of shadow
                                                        ),
                                                      ],
                                                    ),
                                                    padding: EdgeInsets.all(16),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        ListTile(
                                                          leading: const Icon(
                                                              Icons.edit),
                                                          title: const Text(
                                                              'Edit'),
                                                          onTap: () {
                                                            /// for editing purposes
                                                            newRideController
                                                                    .isEditable =
                                                                true;
                                                            newRideController
                                                                    .customerIndex =
                                                                index;
                                                            newRideController
                                                                    .patientName
                                                                    .value =
                                                                newRideController
                                                                    .patientList[
                                                                        index]
                                                                    .name;
                                                            newRideController
                                                                    .patientAge
                                                                    .value =
                                                                newRideController
                                                                    .patientList[
                                                                        index]
                                                                    .age;
                                                            newRideController
                                                                    .patientPhoneNumber
                                                                    .value =
                                                                newRideController
                                                                    .patientList[
                                                                        index]
                                                                    .phone;
                                                            newRideController
                                                                    .gender
                                                                    .value =
                                                                newRideController
                                                                    .patientList[
                                                                        index]
                                                                    .gender
                                                                    .toLowerCase();
                                                            testSamplesController
                                                                    .testSamples
                                                                    .value =
                                                                List.from(newRideController
                                                                    .patientList[
                                                                        index]
                                                                    .sampleList);
                                                            addBasicDetails(
                                                                context);
                                                          },
                                                        ),
                                                        const Divider(),
                                                        ListTile(
                                                          leading: const Icon(
                                                              Icons.delete),
                                                          title: const Text(
                                                              'Delete'),
                                                          onTap: () {
                                                            newRideController
                                                                .deleteFromPatientList(
                                                                    index,
                                                                    context);
                                                          },
                                                        ),
                                                        const SizedBox(
                                                            height: 16),
                                                        ElevatedButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                Colors.red,
                                                          ),
                                                          child: const Text(
                                                            'Close',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ));
                                          },
                                        );
                                      },
                                    );
                                  },
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 8.0),

                                title: Row(
                                  children: [
                                    Obx(() => Text(
                                          newRideController.patientList[index]
                                                      .name!.length >
                                                  15
                                              ? newRideController
                                                  .patientList[index].name!
                                                  .substring(0, 15)
                                              : newRideController
                                                  .patientList[index].name!,
                                          style: TextStyle(
                                            fontSize: deviceWidth! * 0.04,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )),
                                    SizedBox(width: deviceWidth! * 0.02),
                                    // Adjust the spacing between name and age
                                    Text(
                                      newRideController
                                                  .patientList[index].gender
                                                  .toLowerCase() ==
                                              "male"
                                          ? "(M)"
                                          : "(F)",
                                      style: TextStyle(
                                        fontSize: deviceWidth! * 0.04,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                subtitle: Obx(
                                  () => Text(newRideController
                                      .patientList[index].sampleList
                                      .join(", ")),
                                ),

                                // You can further customize other properties like leading, trailing, onTap, etc.
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  : const SizedBox(),
            ),
            newRideController.isNewAddButtonShow.value == false
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                        onPressed: () {
                          addBasicDetails(context);
                        },
                        child: Text(
                          "+ Add New ",
                          style: TextStyle(
                              color: Colors.blue, fontSize: deviceWidth! * .04),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          if (masterListController.masterList.isNotEmpty) {
                            showChoosePatients(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("No Master List Found")));
                          }
                        },
                        child: Text(
                          "+ Add Existing ",
                          style: TextStyle(
                              color: Colors.blue, fontSize: deviceWidth! * .04),
                        ),
                      ),
                    ],
                  )
                : const SizedBox(),
            Obx(
              () => newRideController.patientList.isNotEmpty
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
                                  newRideController.labPrice.value = value;
                                },
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
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
                                      hintStyle: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
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
                  : const SizedBox(),
            ),
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
                            if (newRideController.isRecording.value)
                              const Text("Recording"),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    primaryColor, // Set the background color
                              ),
                              onPressed: newRideController.isRecording.value
                                  ? newRideController.stopRecording
                                  : newRideController.startRecording,
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
                                        newRideController.isRecording.value
                                            ? Icons.stop
                                            : Icons.mic,
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
                            if (!newRideController.isRecording.value &&
                                newRideController.audioPath.value != null)
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
        )));
  }

  showChoosePatients(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SizedBox(
            height: deviceHeight! * .75,
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
                  () => masterListController.masterList.isNotEmpty
                      ? Obx(() => ListView.builder(
                            itemCount: newRideController.isViewAll.value
                                ? masterListController.masterList.length
                                : masterListController.masterList.length >= 4
                                    ? 4
                                    : masterListController.masterList.length,
                            // Replace this with your actual item count
                            itemBuilder: (context, index) {
                              String sampleList = masterListController
                                  .masterList[index].samples!
                                  .join(",");
                              return ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                title: Text(
                                  masterListController.masterList[index].name!,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: deviceWidth! * 0.05,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.phone, size: 16),
                                        const SizedBox(width: 8),
                                        Text(
                                          masterListController
                                              .masterList[index].phone!,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(width: deviceWidth! * 0.02),
                                        Text(
                                          "${masterListController.masterList[index].age!} years",
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      sampleList.isEmpty
                                          ? "No Sample"
                                          : sampleList,
                                      style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ],
                                ),
                                leading: Obx(
                                  () => Checkbox(
                                    value: newRideController.selectedPatientsId
                                        .contains(masterListController
                                            .masterList[index].id!),
                                    onChanged: (value) {
                                      if (newRideController.selectedPatientsId
                                          .contains(masterListController
                                              .masterList[index].id!)) {
                                        newRideController.selectedPatientsId
                                            .remove(masterListController
                                                .masterList[index].id!);
                                      } else {
                                        newRideController.selectedPatientsId
                                            .add(masterListController
                                                .masterList[index].id!);
                                      }
                                    },
                                  ),
                                ),
                                trailing: PopupMenuButton<String>(
                                  itemBuilder: (BuildContext context) {
                                    return ['Edit', 'Delete']
                                        .map((String choice) {
                                      return PopupMenuItem<String>(
                                        value: choice,
                                        child: Text(choice),
                                      );
                                    }).toList();
                                  },
                                  onSelected: (String value) {
                                    if (value == 'Edit') {
                                      newRideController.isAdd = false;

                                      newRideController.patientName.value =
                                          masterListController
                                              .masterList[index].name!;

                                      newRideController.patientAge.value =
                                          masterListController
                                              .masterList[index].age!;
                                      newRideController
                                              .patientPhoneNumber.value =
                                          masterListController
                                              .masterList[index].phone!;
                                      newRideController.gender.value =
                                          masterListController
                                              .masterList[index].gender!;
                                      // MasterList masterList = MasterList();
                                      // masterList.addNameAge(
                                      //     context,
                                      //     masterListController
                                      //         .masterList[index].name!,
                                      //     masterListController
                                      //         .masterList[index].age!,
                                      //     masterListController
                                      //         .masterList[index].phone!,
                                      //     index,
                                      //     masterListController
                                      //         .masterList[index].samples!);
                                    } else if (value == 'Delete') {
                                      masterListController.deleteFromMasterList(
                                          masterListController
                                              .masterList[index].id!,
                                          context,
                                          true);
                                    }
                                  },
                                  icon: Icon(Icons.more_vert),
                                ),
                              );
                            },
                          ))
                      : const Center(
                          child: Text("There is no any master list"),
                        ),
                )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Obx(
                      () => TextButton.icon(
                        onPressed: () {
                          newRideController.viewAllViewLess();
                        },
                        icon: Icon(newRideController.isViewAll.value
                            ? Icons.arrow_upward
                            : Icons.arrow_downward),
                        label: Text(newRideController.isViewAll.value
                            ? "View Less"
                            : "View All"),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        addBasicDetails(context);
                      },
                      icon: const Icon(Icons.add),
                      label: const Text("Add New "),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: deviceWidth! * .7,
                      height: deviceHeight! * .065,
                      child: ElevatedButton(
                        onPressed: () {
                          newRideController.selectedPatientsId.forEach(
                              (element) => newRideController
                                  .addNewPatientFromMasterList(element));
                          priceController.price.value +=
                              (newRideController.patientList.length - 1) *
                                  ridePriceController.minimumRidePrice.value;
                          newRideController.selectedPatientsId.clear();
                          FocusScope.of(context).unfocus();
                          Navigator.pop(context);
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
                        child: const Text(
                          "Proceed to Book",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: deviceHeight! * .03,
                )
              ],
            ),
          ),
        );
      },
    );
  }

  addBasicDetails(BuildContext context) {
    final nameController = TextEditingController();
    final ageController = TextEditingController();
    final phoneController = TextEditingController();
    nameController.text = newRideController.patientName.value;
    ageController.text = newRideController.patientAge.value;
    phoneController.text = newRideController.patientPhoneNumber.value;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: const Text('Add Basic Details'),
          content: SingleChildScrollView(
              child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Can not be empty";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z\s]*$')),
                  ],
                  onChanged: (nameValue) {
                    newRideController.patientName.value = nameValue;
                  },
                ),
                SizedBox(
                  height: deviceHeight! * .02,
                ),
                TextFormField(
                  controller: ageController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Can not be empty";
                    }
                    return null;
                  },
                  maxLength: 2,
                  decoration: const InputDecoration(
                    labelText: 'Age',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    newRideController.patientAge.value = value;
                  },
                ),
                TextFormField(
                  controller: phoneController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Can not be empty";
                    }
                    return null;
                  },
                  maxLength: 10,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  onChanged: (value) {
                    newRideController.patientPhoneNumber.value = value;
                  },
                ),
                const Text(
                  'Gender',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Obx(() => Radio<String>(
                          value: 'male',
                          groupValue: newRideController.gender.value,
                          onChanged: (value) {
                            newRideController.gender.value = value!;
                          },
                        )),
                    const Text('Male'),
                    Obx(
                      () => Radio<String>(
                        value: 'female',
                        groupValue: newRideController.gender.value,
                        onChanged: (value) {
                          newRideController.gender.value = value!;
                        },
                      ),
                    ),
                    const Text('Female'),
                  ],
                ),
              ],
            ),
          )),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Navigator.pop(context);
                  addTestList(context);
                }
              },
              child: const Text('Next'),
            ),
          ],
        );
      },
    );
  }

  addTestList(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: Text(
            'Add Test List',
            style: GoogleFonts.acme(),
          ),
          content: Obx(() => ListView.builder(
                itemCount: testMenuController.testMenuList.length,
                itemBuilder: (context, index) {
                  return ExpansionTile(
                    title:
                        Text(testMenuController.testMenuList[index].category!),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(deviceWidth!*.005),
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                          imageUrl:
                              testMenuController.testMenuList[index].imageUrl!,
                        height: deviceHeight!*.04,
                        width: deviceWidth!*.08,
                        errorWidget: (context, url, error) {
                          return const Icon(Icons.error);
                        },
                        placeholder: (context, url) {
                          return Shimmer.fromColors(
                              baseColor: Colors.white10,
                              highlightColor: Colors.black26,
                              child: SizedBox(
                                height: deviceHeight!*.03,
                                width: deviceWidth!*.05,
                              )
                          );
                        },
                      ),
                    ),
                    children: _buildSubcategories(
                        testMenuController.testMenuList[index].subCategories!),
                  );
                },
              )),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                addBasicDetails(context);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();

                if (newRideController.isEditable) {
                  Navigator.of(context).pop();
                  newRideController.editPatientDetailsUsingIndex(
                      context, newRideController.customerIndex);
                } else {
                  newRideController.addNewPatient(context);
                }
              },
              child: Text(newRideController.isEditable ? 'Update' : 'Save'),
            ),
          ],
        );
      },
    );
  }

  _buildSubcategories(List<String> subcategories) {
    return subcategories
        .map((subcategory) => ListTile(
              title: Row(
                children: [
                  Obx(() => Checkbox(
                        value: testSamplesController.testSamples
                            .contains(subcategory),
                        onChanged: (value) {
                          if (value != null && value) {
                            testSamplesController.testSamples.add(subcategory);
                          } else {
                            testSamplesController.testSamples
                                .remove(subcategory);
                          }
                        },
                      )),
                  Text(subcategory),
                ],
              ),
            ))
        .toList();
  }
}
