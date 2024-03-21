import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jonk_lab/global/color.dart';
import 'package:jonk_lab/global/globalData.dart';
import 'package:shimmer/shimmer.dart';
import '../controller/master_list_controller.dart';
import '../controller/new_ride_controller.dart';
import '../controller/test_menu_controller.dart';
import '../controller/test_samples_controller.dart';
import '../global/progressIndicator.dart';

class MasterList extends StatelessWidget {
  MasterList({super.key});
  MasterListController masterListController = Get.put(MasterListController());
  NewRideController newRideController = Get.put(NewRideController());
  TestMenuController testMenuController = Get.put(TestMenuController());
  TestSamplesController testSamplesController =
      Get.put(TestSamplesController());
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final phoneController = TextEditingController();
  final genderController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text("Master List"),
        titleTextStyle:
            GoogleFonts.acme(color: Colors.black, fontSize: deviceWidth! * .06),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: deviceWidth! * .05),
            child: InkWell(
              onTap: () {
                newRideController.isEditable = false;
                newRideController.isAdd = true;

                nameController.clear();
                ageController.clear();
                genderController.clear();
                phoneController.clear();
                newRideController.gender.value = "";
                testSamplesController.testSamples.value = [];
                addNameAge(context, null, null, null, null, null);
              },
              child: Icon(
                Icons.add,
                size: deviceWidth! * .1,
              ),
            ),
          )
        ],
      ),
      body: Obx(() => masterListController.isLoading.value
          ? Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    onChanged: (value) {
                      masterListController.filterData(value);
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200],
                      // Change the fill color
                      hintText: "Search by name & phone number",
                      hintStyle: const TextStyle(color: Colors.grey),
                      // Change the hint text color
                      prefixIcon: const Icon(Icons.search),
                      // Add a search icon as prefix
                      border: OutlineInputBorder(
                        // Add border with rounded corners
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16), // Add padding for text input
                    ),
                  ),
                ),
                Expanded(
                    child: masterListController.masterListController.isNotEmpty
                        ? ListView.builder(
                            itemCount: masterListController
                                .masterListController.length,
                            itemBuilder: (context, index) {
                              String samples = masterListController
                                  .masterListController[index].samples!
                                  .join(', ');
                              return Card(
                                color: Colors.black54,
                                elevation: 4,
                                margin: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 16),
                                  title: Text(
                                    masterListController
                                        .masterListController[index].name!,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.white),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 4),
                                      Text(
                                        'Age: ${masterListController.masterListController[index].age!}',
                                        style: const TextStyle(
                                            fontSize: 16, color: Colors.white),
                                      ),
                                      Text(
                                        'Gender: ${masterListController.masterListController[index].gender!}',
                                        style: const TextStyle(
                                            fontSize: 16, color: Colors.white),
                                      ),
                                      Text(
                                        'Phone: ${masterListController.masterListController[index].phone!}',
                                        style: const TextStyle(
                                            fontSize: 16, color: Colors.white),
                                      ),
                                      Text(
                                        samples,
                                        style: const TextStyle(
                                            fontSize: 16, color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      newRideController.isEditable = true;
                                      newRideController.isAdd = false;
                                      nameController.text = masterListController
                                          .masterListController[index].name!;
                                      ageController.text = masterListController
                                          .masterListController[index].age!;
                                      genderController.text =
                                          masterListController
                                              .masterListController[index]
                                              .gender!;
                                      phoneController.text =
                                          masterListController
                                              .masterListController[index]
                                              .phone!;
                                      newRideController.gender.value =
                                          masterListController
                                              .masterListController[index]
                                              .gender!;

                                      addNameAge(
                                          context,
                                          masterListController
                                              .masterListController[index]
                                              .name!,
                                          masterListController
                                              .masterListController[index].age!,
                                          masterListController
                                              .masterListController[index]
                                              .phone!,
                                          index,
                                          masterListController
                                              .masterListController[index]
                                              .samples!);
                                    },
                                  ),
                                ),
                              );
                            },
                          )
                        : const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [Text("Looks like no any master list")],
                            ),
                          ))
              ],
            )
          : const Center(
              child: CircularProgress(),
            )),
    );
  }
  addNameAge(BuildContext context, String? name, String? age,
      String? phoneNumber, int? index, List<String>? samples) {
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
                    controller: nameController,
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
                    controller: ageController,
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
                    controller: phoneController,
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
                              addTestList(context, samples, index);
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
  addTestList(BuildContext context, List<String>? samples, int? index) async {
    if (samples != null) {
      testSamplesController.testSamples.value = samples;
    }
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
                        if (newRideController.isEditable) {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => const CircularProgress(),
                          );
                          masterListController.updateDetails(index!, context);
                        } else {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => const CircularProgress(),
                          );
                          masterListController.addDetails(context);
                        }
                      },
                      child: Text(
                        "Add to Master List",
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
}
