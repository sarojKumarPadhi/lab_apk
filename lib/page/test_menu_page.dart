import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jonk_lab/global/color.dart';
import 'package:jonk_lab/global/globalData.dart';
import 'package:quickalert/quickalert.dart';

import '../controller/test_menu_controller.dart';

class TestMenuPage extends StatefulWidget {
  const TestMenuPage({super.key});

  @override
  State<TestMenuPage> createState() => _TestMenuPageState();
}

class _TestMenuPageState extends State<TestMenuPage> {
  List<String> menu = [];
  TestMenuController testMenuController = Get.put(TestMenuController());
  final testNameController = TextEditingController();
  final testPriceController = TextEditingController();
  final testSampleNameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(
          "Menu Card",
          style: GoogleFonts.acme(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: deviceWidth! * .04),
            child: ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(deviceWidth! * .03)),
                      title: Text("Add menu",
                          style: GoogleFonts.acme(color: Colors.white)),
                      backgroundColor: Colors.black,
                      content: SingleChildScrollView(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text("Enter Test Name",
                                      style: GoogleFonts.acme(
                                          color: Colors.white)),
                                ],
                              ),
                              SizedBox(
                                height: deviceHeight! * .01,
                              ),
                              TextFormField(
                                controller: testNameController,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                                decoration: const InputDecoration(
                                  hintText: "Blood  Test",
                                  hintStyle: TextStyle(color: Colors.white38),
                                  filled: true,
                                  fillColor: Colors.brown,
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Enter Test Name";
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: deviceHeight! * .01,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text("Enter Test Price",
                                      style: GoogleFonts.acme(
                                          color: Colors.white)),
                                ],
                              ),
                              SizedBox(
                                height: deviceHeight! * .01,
                              ),
                              TextFormField(
                                controller: testPriceController,
                                keyboardType: TextInputType.number,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.currency_rupee_outlined,
                                    color: Colors.white,
                                  ),
                                  filled: true,
                                  fillColor: Colors.brown,
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Enter Test Price";
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: deviceHeight! * .01,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text("Enter Sample Name",
                                      style: GoogleFonts.acme(
                                          color: Colors.white)),
                                ],
                              ),
                              SizedBox(
                                height: deviceHeight! * .01,
                              ),
                              TextFormField(
                                controller: testSampleNameController,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                                decoration: const InputDecoration(
                                  hintText: "Blood",
                                  hintStyle: TextStyle(color: Colors.white38),
                                  filled: true,
                                  fillColor: Colors.brown,
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Enter Sample Name";
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: deviceHeight! * .05,
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      testMenuController.addTestMenu(
                                        testNameController.text,
                                        testSampleNameController.text,
                                        testPriceController.text,
                                      );
                                      testPriceController.clear();
                                      testSampleNameController.clear();
                                      testNameController.clear();
                                      Navigator.pop(context);
                                    }
                                  },
                                  child: Text(
                                    "Add Test Name",
                                    style: GoogleFonts.acme(),
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.add),
                label: Text(
                  "Add",
                  style: GoogleFonts.acme(),
                )),
          )
        ],
      ),
      body: Obx(
        () => testMenuController.testMenuList.isNotEmpty
            ? ListView.builder(
                itemCount: testMenuController.testMenuList.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onLongPress: () {

                      QuickAlert.show(context: context,
                          type: QuickAlertType.success,
                        onCancelBtnTap: () {
                          Navigator.pop(context);
                        },
                        onConfirmBtnTap: () {
                          testMenuController.deleteTestMenu(index);
                          Navigator.pop(context);
                        },
                        showConfirmBtn: true,
                        showCancelBtn: true,
                        title: ("Are you sure you want to delete"),
                        confirmBtnText: "Yes",
                        cancelBtnText: "No"
                      )
                      ;
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(
                          vertical: deviceHeight! * .01,
                          horizontal: deviceWidth! * .03),
                      decoration: const BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.all(Radius.circular(2))),
                      child: ListTile(
                        title: Text(
                            testMenuController.testMenuList[index].testName,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: deviceWidth! * .05,
                                color: Colors.white)),
                        subtitle: Text(
                            testMenuController
                                .testMenuList[index].testSampleName,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: deviceWidth! * .05,
                                color: Colors.white)),
                        trailing: Text(
                            "${testMenuController.testMenuList[index].testPrice} ₹",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: deviceWidth! * .05,
                                color: Colors.white)),
                      ),
                    ),
                  );
                },
              )
            : const Center(
                child: Text("No test menu"),
              ),
      ),
    );
  }
}
