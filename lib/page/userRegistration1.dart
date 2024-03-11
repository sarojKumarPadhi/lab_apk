import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jonk_lab/global/color.dart';
import 'package:jonk_lab/page/userRegistration2.dart';

import '../component/myTextField.dart';
import '../global/globalData.dart';
import '../global/progressIndicator.dart';

final _formKey = GlobalKey<FormState>();

class UserRegistration1 extends StatefulWidget {
  const UserRegistration1({super.key});

  @override
  State<UserRegistration1> createState() => _UserRegistration1State();
}

class _UserRegistration1State extends State<UserRegistration1> {
  // TextEditingController labNameController = TextEditingController();
  // TextEditingController labRegistrationController = TextEditingController();

  TextEditingController pinCode = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController district = TextEditingController();

  ///---------GetStorage initialize---------------------

  GetStorage getStorage = GetStorage();

  @override
  initState() {
    super.initState();
    if (getStorage.read("addressDetails") != null) {
      Map<String, dynamic> getData = getStorage.read("addressDetails");
      state.text = getData["state"];
      district.text = getData["district"];
      cityController.text = getData["city"];
      pinCode.text = getData["pinCode"];
    }
  }

  storeData() {
    Map<String, dynamic> addressDetails = {
      "state": state.text,
      "district": district.text,
      "city": cityController.text,
      "pinCode": pinCode.text,
    };
    getStorage.write("addressDetails", addressDetails);
  }

  Future<void> stateAlert(BuildContext context) async {
    return showGeneralDialog<void>(
      context: context,
      pageBuilder: (BuildContext buildContext, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return Builder(
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(deviceWidth! * .01)),
              backgroundColor: Colors.white,
              title: const Text('Select State',
                  style: TextStyle(
                      color: Colors.black87, fontWeight: FontWeight.bold)),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: stateData['state']!.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        ListTile(
                          title: Text(stateData['state']![index]),
                          onTap: () {
                            setState(() {
                              state.text = stateData['state']![index];
                            });
                            Navigator.of(context)
                                .pop(); // Close the dialog on item selection
                          },
                        ),
                        const Divider()
                      ],
                    );
                  },
                ),
              ),
              actions: <Widget>[
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          const MaterialStatePropertyAll<Color>(Colors.black),
                      shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)))),
                  onPressed: () {
                    Navigator.of(context)
                        .pop(); // Close the dialog without selecting any item
                  },
                  child: const Text('Cancel',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ],
            );
          },
        );
      },
      transitionBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) {
        return ZoomIn(
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black.withOpacity(0.5),
      useRootNavigator: true,
    );
  }

  Future<Future<Object?>> districtAlert(
      BuildContext context, String selectedState) async {
    return showGeneralDialog(
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) {
        return Builder(
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(deviceWidth!*.01)
              ),
              title: const Text('Select District',
                  style: TextStyle(
                      color: Colors.black87, fontWeight: FontWeight.bold)),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: stateData[selectedState]!.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        ListTile(
                          title: Text(stateData[selectedState]![index]),
                          onTap: () {
                            setState(() {
                              district.text = stateData[selectedState]![index];
                            });
                            Navigator.of(context)
                                .pop(); // Close the dialog on item selection
                          },
                        ),
                        const Divider()
                      ],
                    );
                  },
                ),
              ),
              actions: <Widget>[
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          const MaterialStatePropertyAll<Color>(Colors.black),
                      shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)))),
                  onPressed: () {
                    Navigator.of(context)
                        .pop(); // Close the dialog without selecting any item
                  },
                  child: const Text('Cancel',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ],
            );
          },
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ZoomIn(child: child);
      },
      transitionDuration: const Duration(milliseconds: 300),
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black.withOpacity(0.5),
      useRootNavigator: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("Address details",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              linearProgress(),
              SizedBox(
                height: deviceHeight * .02,
              ),

              ///--------for country---------------

              FadeInUp(
                duration: const Duration(milliseconds: 2000),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: TextFormField(
                    readOnly: true,
                    decoration: InputDecoration(
                        hintText: "India",
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: deviceWidth * 4.2 / 100,
                            color: Colors.black87),
                        filled: true,
                        suffixIcon:
                            Image.asset("assets/icon/india.png", width: 10),
                        fillColor: Colors.grey[300],
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        )),
                  ),
                ),
              ),
              SizedBox(
                height: deviceHeight * .02,
              ),

              ///-----------------for state----------------
              FadeInUp(
                duration: const Duration(milliseconds: 2000),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: TextFormField(
                    onTap: () {
                      stateAlert(context);
                    },
                    controller: state,
                    cursorColor: Colors.black,
                    readOnly: true,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[300],
                        enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey)),
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)),
                        border: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red)),
                        hintText: "State",
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: deviceWidth * 4.2 / 100,
                            color: Colors.black87),
                        suffixIcon: const Icon(
                          Icons.arrow_drop_down_sharp,
                          size: 30,
                        )),
                    validator: (value) {
                      if (value.toString().isEmpty) {
                        return 'Select State';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              SizedBox(
                height: deviceHeight * .02,
              ),

              ///----------------for district--------------
              FadeInUp(
                duration: const Duration(milliseconds: 2000),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: TextFormField(
                    onTap: () {
                      state.text.isNotEmpty
                          ? districtAlert(context, state.text)
                          : Get.snackbar(
                              "Alert",
                              "First Select State then choose district",
                              colorText: Colors.white,
                              backgroundColor: Colors.red,
                              icon: const Icon(
                                Icons.warning,
                                color: Colors.yellow,
                              ),
                            );
                    },
                    controller: district,
                    cursorColor: Colors.black87,
                    readOnly: true,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[300],
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)),
                        border: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red)),
                        hintText: "District",
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: deviceWidth * 3.9 / 100,
                            color: Colors.black87),
                        suffixIcon: const Icon(
                          Icons.arrow_drop_down_sharp,
                          size: 30,
                        )),
                    validator: (value) {
                      if (value.toString().isEmpty) {
                        return 'Select District';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              SizedBox(
                height: deviceHeight * .02,
              ),
              FadeInUp(
                duration: const Duration(milliseconds: 2000),
                child: MyTextField(
                  textInputType: TextInputType.text,
                  controller: cityController,
                  hintText: "City / Locality",
                  prefixIcon: const Icon(Icons.location_city),
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return "Enter city or locality name";
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(
                height: deviceHeight * .02,
              ),
              FadeInUp(
                duration: const Duration(milliseconds: 2000),
                child: MyTextField(
                  textInputType: TextInputType.number,
                  controller: pinCode,
                  hintText: "Pin Code",
                  prefixIcon: const Icon(Icons.pin),
                  validator: (String? value) {
                    if (value!.isEmpty) return "Enter a valid pin";
                    if (value.length < 6) return "Enter a valid pin";
                    return null;
                  },
                ),
              ),
              SizedBox(
                height: deviceHeight * .05,
              ),
              FadeInUp(
                duration: const Duration(milliseconds: 2000),
                child: SizedBox(
                  width: deviceWidth - 50,
                  height: deviceHeight * .06,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        registrationPercentage = 0.45;
                        storeData();
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => const CircularProgress(),
                        );

                        Future.delayed(
                          const Duration(milliseconds: 2000),
                          () {
                            Get.to(() => const UserRegistration2(),
                                    duration: const Duration(milliseconds: 400),
                                    transition: Transition.leftToRight)
                                ?.then((value) {
                              Navigator.pop(context);
                            });
                          },
                        );
                      }
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(buttonColor),
                        shape: MaterialStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        )),
                    child: const Text("Save & Continue",
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
