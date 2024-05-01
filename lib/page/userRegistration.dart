import 'package:animate_do/animate_do.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jonk_lab/component/myTextField.dart';
import 'package:jonk_lab/global/color.dart';
import 'package:jonk_lab/page/userRegistration1.dart';
import 'package:url_launcher/url_launcher.dart';

import '../global/globalData.dart';
import '../global/progressIndicator.dart';

final _formKey = GlobalKey<FormState>();

class UserRegistration extends StatefulWidget {
  const UserRegistration({super.key});

  @override
  State<UserRegistration> createState() => _UserRegistrationState();
}

class _UserRegistrationState extends State<UserRegistration> {
  TextEditingController labNameController = TextEditingController();
  TextEditingController labRegistrationController = TextEditingController();
  TextEditingController labOwnerNameController = TextEditingController();
  TernAndConditionsController ternAndConditionsController =
  Get.put(TernAndConditionsController());
  GetStorage data = GetStorage();

  @override
  initState() {
    super.initState();
    if (data.read("basicDetails") != null) {
      Map<String, dynamic> getData = data.read("basicDetails");
      labNameController.text = getData["labName"];
      labRegistrationController.text = getData["labRegistrationNumber"];
      labOwnerNameController.text = getData["labOwnerName"];
    }
  }

  storeData() {
    Map<String, dynamic> value = {
      "labName": labNameController.text,
      "labRegistrationNumber": labRegistrationController.text,
      "labOwnerName": labOwnerNameController.text,
    };
    data.write("basicDetails", value);
  }

  @override
  Widget build(BuildContext context) {
    deviceWidth = MediaQuery
        .of(context)
        .size
        .width;
    deviceHeight = MediaQuery
        .of(context)
        .size
        .height;
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: appBarColor,
        title: const Text("Basic details",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              linearProgress(),
              SizedBox(
                height: deviceHeight! * .1,
              ),
              FadeInUp(
                duration: const Duration(milliseconds: 2000),
                child: MyTextField(
                  textInputType: TextInputType.name,
                  controller: labNameController,
                  hintText: 'Enter lab name',
                  prefixIcon: const Icon(
                    Icons.medical_information,
                  ),
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return "Enter lab name";
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(
                height: deviceHeight! * .02,
              ),
              FadeInUp(
                duration: const Duration(milliseconds: 2000),
                child: MyTextField(
                  textInputType: TextInputType.number,
                  hintText: 'Enter lab registration number',
                  prefixIcon: const Icon(Icons.app_registration),
                  controller: labRegistrationController,
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return "Enter lab registration number";
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(
                height: deviceHeight! * .02,
              ),
              FadeInUp(
                duration: const Duration(milliseconds: 2000),
                child: MyTextField(
                  textInputType: TextInputType.name,
                  hintText: 'Enter lab owner name',
                  prefixIcon: const Icon(Icons.person),
                  controller: labOwnerNameController,
                  validator: (String? value) {
                    if (value!.isEmpty) return "Enter lab owner name";
                    return null;
                  },
                ),
              ),
              SizedBox(
                height: deviceHeight! * .08,
              ),
              FadeInUp(
                duration: const Duration(milliseconds: 2000),
                child: SizedBox(
                    width: deviceWidth! - 50,
                    height: deviceHeight! * .06,
                    child: Obx(() =>
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              if (ternAndConditionsController.isChecked.value) {
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (
                                      context) => const CircularProgress(),
                                );
                                registrationPercentage = 0.30;

                                ///----------store data in GetStorage of this page---------
                                storeData();
                                Future.delayed(
                                  const Duration(milliseconds: 2000),
                                      () {
                                    Get.to(() => const UserRegistration1(),
                                        duration:
                                        const Duration(milliseconds: 400),
                                        transition: Transition.circularReveal)
                                        ?.then((value) {
                                      Navigator.pop(context);
                                    });
                                  },
                                );
                              }
                              else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Please Accept Terms & Conditions")));
                              }
                            }
                          },
                          style: ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(
                                  ternAndConditionsController.isChecked.value
                                      ? primaryColor
                                      : secondaryColor),
                              shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              )),
                          child: const Text("Save & Continue",
                              style: TextStyle(color: Colors.white)),
                        ))),
              ),
              SizedBox(
                height: deviceHeight! * .03,
              ),
              FadeInUp(
                duration: const Duration(milliseconds: 3000),
                child: Row(
                  children: [
                    Obx(() =>
                        Checkbox(
                          checkColor: Colors.blue,
                          activeColor: Colors.black,
                          value: ternAndConditionsController.isChecked.value,
                          onChanged: (bool? value) {
                            setState(() {
                              ternAndConditionsController.isChecked.value =
                              value!;
                            });
                          },
                        )),
                    RichText(
                      text: TextSpan(
                        text: 'Accept our terms of services & ',
                        style: TextStyle(color: Colors.black),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'privacy policy.',
                            style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                _launchURL();
                              },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _launchURL() async {
    final Uri url = Uri.parse(
        'https://sites.google.com/view/jonkk-terms-and-conditions/home');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}

class TernAndConditionsController extends GetxController {
  RxBool isChecked = false.obs;
}
