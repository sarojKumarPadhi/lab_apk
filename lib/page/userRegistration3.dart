import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jonk_lab/component/myTextField.dart';
import 'package:jonk_lab/global/color.dart';
import 'package:jonk_lab/page/userRegistration4.dart';

import '../global/globalData.dart';
import '../global/progressIndicator.dart';

final _formKey = GlobalKey<FormState>();

class UserRegistration3 extends StatefulWidget {
  const UserRegistration3({super.key});

  @override
  State<UserRegistration3> createState() => _UserRegistration3State();
}

class _UserRegistration3State extends State<UserRegistration3> {
  final bankName = TextEditingController();
  final branchName = TextEditingController();
  final accountNumber = TextEditingController();
  final confirmAccountNumber = TextEditingController();
  final ifscCode = TextEditingController();

  GetStorage getStorage = GetStorage();

  @override
  initState() {
    super.initState();
    if (getStorage.read("bankDetails") != null) {
      Map<String, dynamic> bankDetails = getStorage.read("bankDetails");
      bankName.text = bankDetails["bankName"];
      branchName.text = bankDetails["branchName"];
      accountNumber.text = bankDetails["accountNumber"];
      confirmAccountNumber.text = bankDetails["accountNumber"];
      ifscCode.text = bankDetails["ifscCode"];
    }
  }

  storeData() {
    Map<String, dynamic> bankDetails = {
      "bankName": bankName.text,
      "branchName": branchName.text,
      "accountNumber": accountNumber.text,
      "ifscCode": ifscCode.text
    };
    getStorage.write("bankDetails", bankDetails);
  }

  ///----------bank alert dialog-----------

  Future<void> bankNameAlert(
    BuildContext context,
  ) async {
    return showGeneralDialog<void>(
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) {
        return Builder(
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(deviceWidth!*.01)
              ),
              title: const Text('Select Bank',
                  style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: bankNameList.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        ListTile(
                          title: Text(bankNameList[index]),
                          onTap: () {
                            setState(() {
                              bankName.text = bankNameList[index];
                            });
                            Navigator.of(context).pop();
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

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("Bank Account Details",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              linearProgress(),
              SizedBox(
                height: deviceHeight * .03,
              ),
              FadeInUp(
                duration: const Duration(milliseconds: 2000),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: TextFormField(
                    onTap: () {
                      bankNameAlert(context);
                    },
                    controller: bankName,
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
                        hintText: "Bank Name",
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: deviceWidth * 3.9 / 100,
                            color: Colors.black),
                        suffixIcon: const Icon(
                          Icons.arrow_drop_down_sharp,
                          size: 30,
                        ),
                        prefixIcon: const Icon(
                          Icons.account_balance,
                          color: Colors.grey,
                        )),
                    validator: (value) {
                      if (value.toString().isEmpty) {
                        return 'Select Bank';
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
                  hintText: "Enter Branch Name",
                  prefixIcon: const Icon(Icons.account_balance_outlined),
                  controller: branchName,
                  validator: (String? value) {
                    if (value!.isEmpty) return "Enter Branch Name";
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
                  hintText: "Enter Account Number",
                  prefixIcon: const Icon(Icons.numbers),
                  controller: accountNumber,
                  validator: (String? value) {
                    if (value!.isEmpty) return "Enter Account Number";
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
                  hintText: "Enter Confirm Account Number",
                  prefixIcon: const Icon(Icons.confirmation_num),
                  controller: confirmAccountNumber,
                  validator: (String? value) {
                    if (value!.isEmpty) return "Enter Account Number";
                    if (value != accountNumber.text) {
                      return "Account Number not matching";
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
                  textInputType: TextInputType.text,
                  hintText: "Enter ifsc code",
                  prefixIcon: const Icon(Icons.confirmation_number_outlined),
                  controller: ifscCode,
                  validator: (String? value) {
                    if (value!.isEmpty) return "Enter ifsc code";
                    return null;
                  },
                ),
              ),
              SizedBox(
                height: deviceHeight * .1,
              ),
              FadeInUp(
                duration: const Duration(milliseconds: 2000),
                child: SizedBox(
                  width: deviceWidth - 50,
                  height: deviceHeight * .06,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => const CircularProgress(),
                        );
                        registrationPercentage = 0.75;
                        storeData();
                        Future.delayed(
                          const Duration(milliseconds: 1000),
                          () {
                            Get.to(() => const UserRegistration4())
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
