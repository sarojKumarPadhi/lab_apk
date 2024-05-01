import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final _formKey = GlobalKey<FormState>();

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
                addBasicDetails(context);
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
                Obx(() => Expanded(
                    child: masterListController.masterList.isNotEmpty
                        ? Obx(() => ListView.builder(
                              itemCount: masterListController.masterList.length,
                              itemBuilder: (context, index) {
                                String samples = masterListController
                                    .masterList[index].samples!
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
                                          .masterList[index].name!,
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
                                          'Age: ${masterListController.masterList[index].age!}',
                                          style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.white),
                                        ),
                                        Text(
                                          'Gender: ${masterListController.masterList[index].gender!}',
                                          style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.white),
                                        ),
                                        Text(
                                          'Phone: ${masterListController.masterList[index].phone!}',
                                          style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.white),
                                        ),
                                        Text(
                                          samples,
                                          style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    trailing: IconButton(
                                      icon: const Icon(
                                        Icons.more_vert,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        showGeneralDialog(
                                          context: context,
                                          transitionBuilder: (context,
                                              animation,
                                              secondaryAnimation,
                                              child) {
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
                                                        constraints:
                                                            BoxConstraints(
                                                                maxWidth: 300),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors.grey
                                                                  .withOpacity(
                                                                      0.5),
                                                              spreadRadius: 2,
                                                              blurRadius: 4,
                                                              offset: Offset(0,
                                                                  2), // changes position of shadow
                                                            ),
                                                          ],
                                                        ),
                                                        padding:
                                                            EdgeInsets.all(16),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            ListTile(
                                                              leading:
                                                                  const Icon(
                                                                      Icons
                                                                          .edit),
                                                              title: const Text(
                                                                  'Edit'),
                                                              onTap: () {
                                                                masterListController
                                                                        .customerId
                                                                        .value =
                                                                    masterListController
                                                                        .masterList[
                                                                            index]
                                                                        .id!;

                                                                masterListController
                                                                        .name
                                                                        .value =
                                                                    masterListController
                                                                        .masterList[
                                                                            index]
                                                                        .name!;
                                                                masterListController
                                                                        .age
                                                                        .value =
                                                                    masterListController
                                                                        .masterList[
                                                                            index]
                                                                        .age!;
                                                                masterListController
                                                                        .gender
                                                                        .value =
                                                                    masterListController
                                                                        .masterList[
                                                                            index]
                                                                        .gender!;
                                                                masterListController
                                                                        .phoneNumber
                                                                        .value =
                                                                    masterListController
                                                                        .masterList[
                                                                            index]
                                                                        .phone!;
                                                                masterListController
                                                                        .selectedSubcategories
                                                                        .value =
                                                                    masterListController
                                                                        .masterList[
                                                                            index]
                                                                        .samples!;
                                                                masterListController
                                                                    .isEditable
                                                                    .value = true;
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
                                                                masterListController.deleteFromMasterList(
                                                                    masterListController
                                                                        .masterList[
                                                                            index]
                                                                        .id!,
                                                                    context,
                                                                    false);
                                                              },
                                                            ),
                                                            const SizedBox(
                                                                height: 16),
                                                            ElevatedButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              style:
                                                                  ElevatedButton
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
                                  ),
                                );
                              },
                            ))
                        : const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [Text("Looks like no any master list")],
                            ),
                          )))
              ],
            )
          : const Center(
              child: CircularProgress(),
            )),
    );
  }

  addBasicDetails(BuildContext context) {
    final nameController = TextEditingController();
    final ageController = TextEditingController();
    final phoneController = TextEditingController();
    nameController.text = masterListController.name.value;
    ageController.text = masterListController.age.value;
    phoneController.text = masterListController.phoneNumber.value;

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
                    masterListController.name.value = nameValue;
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
                    masterListController.age.value = value;
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
                    masterListController.phoneNumber.value = value;
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
                          groupValue: masterListController.gender.value,
                          onChanged: (value) {
                            masterListController.gender.value = value!;
                          },
                        )),
                    const Text('Male'),
                    Obx(
                      () => Radio<String>(
                        value: 'female',
                        groupValue: masterListController.gender.value,
                        onChanged: (value) {
                          masterListController.gender.value = value!;
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
                    title:
                        Text(testMenuController.testMenuList[index].category!),
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

                if (masterListController.isEditable.value) {
                  Navigator.of(context).pop();
                  masterListController.updateDetails(
                      masterListController.customerId.value, context);
                } else {
                  masterListController.addDetails(context);
                }
              },
              child: Text(
                  masterListController.isEditable.value ? 'Update' : 'Save'),
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
                        value: masterListController.selectedSubcategories
                            .contains(subcategory),
                        onChanged: (value) {
                          if (value != null && value) {
                            masterListController.selectedSubcategories
                                .add(subcategory);
                          } else {
                            masterListController.selectedSubcategories
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

class Category {
  final String name;
  final List<String> subcategories;

  Category({required this.name, required this.subcategories});
}
