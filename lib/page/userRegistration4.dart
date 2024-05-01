import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jonk_lab/global/color.dart';
import 'package:jonk_lab/page/userRegistration5.dart';

import '../global/globalData.dart';
import '../global/progressIndicator.dart';

class UserRegistration4 extends StatefulWidget {
  const UserRegistration4({super.key});

  @override
  State<UserRegistration4> createState() => _UserRegistration4State();
}

class _UserRegistration4State extends State<UserRegistration4> {
  final ImagePicker picker = ImagePicker();
  GetStorage getStorage = GetStorage();

  ///---------------------image picker--------------------

  Future takeImage(ImageSource source, String documentType) async {
    final pickedImage =
        await picker.pickImage(source: source, imageQuality: 20);
    if (pickedImage != null) {
      switch (documentType) {
        case "Aadhar Card":
          {
            // aadharImageFile = File(pickedImage.path);
            getStorage.write("aadharImageFile", File(pickedImage.path).path);
            setState(() {});
          }
          break;
        case "Pan Card":
          {
            // panImageFile = File(pickedImage.path);
            getStorage.write("panImageFile", File(pickedImage.path).path);

            setState(() {});
          }
          break;
        case "Bank Passbook":
          {
            // bankPassBookFile = File(pickedImage.path);
            getStorage.write("bankPassBookFile", File(pickedImage.path).path);

            setState(() {});
          }
          break;
        case "Lab Certificate":
          {
            // labCertificateFile = File(pickedImage.path);
            getStorage.write("labCertificateFile", File(pickedImage.path).path);

            setState(() {});
          }
          break;
      }
    }
  }

  bool areAllImagesSelected() {
    return getStorage.read("aadharImageFile") != null &&
        getStorage.read("panImageFile") != null &&
        getStorage.read("bankPassBookFile") != null &&
        getStorage.read("labCertificateFile") != null;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("Document Upload",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: appBarColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            linearProgress(),
            SizedBox(
              height: deviceHeight! * .03,
            ),
            FadeInUp(
              duration: const Duration(milliseconds: 2000),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                   Text("Clinic Establishment\n Certificate *",
                      style: TextStyle(
                          fontSize: deviceWidth!*.04,
                          color: Colors.black,
                          fontWeight: FontWeight.bold)),
                  InkWell(
                    onTap: () {
                      takeImage(ImageSource.gallery, "Aadhar Card");
                    },
                    child: CustomPaint(
                      painter: DashedBorderPainter(),
                      child: Container(
                          height: deviceHeight! * 14 / 100,
                          width: deviceWidth! * 30 / 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: const Color(0xFFE7E3E3),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 0),
                            child: getStorage.read("aadharImageFile") != null
                                ? Image.file(
                                    File(getStorage.read("aadharImageFile")),
                                    fit: BoxFit
                                        .cover) // Display the image if it's not null
                                : const Center(
                                    child: Image(
                                      image: AssetImage(
                                          "assets/images/Document.png"),
                                      width: 20,
                                    ), // Display a message if imageFile is null
                                  ),
                          )),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: deviceHeight! * .02,
            ),
            FadeInUp(
              duration: const Duration(milliseconds: 2000),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                   Text("Pan Card / GST *",
                      style: TextStyle(
                          fontSize: deviceWidth!*.04,
                          color: Colors.black,
                          fontWeight: FontWeight.bold)),
                  InkWell(
                    onTap: () {
                      takeImage(ImageSource.gallery, "Pan Card");
                    },
                    child: CustomPaint(
                      painter: DashedBorderPainter(),
                      child: Container(
                          height: deviceHeight! * 14 / 100,
                          width: deviceWidth! * 30 / 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: const Color(0xFFE7E3E3),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 0),
                            child: getStorage.read("panImageFile") != null
                                ? Image.file(
                                    File(getStorage.read("panImageFile")),
                                    fit: BoxFit
                                        .cover) // Display the image if it's not null
                                : const Center(
                                    child: Image(
                                      image: AssetImage(
                                          "assets/images/Document.png"),
                                      width: 20,
                                    ), // Display a message if imageFile is null
                                  ),
                          )),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: deviceHeight! * .02,
            ),
            FadeInUp(
              duration: const Duration(milliseconds: 2000),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                   Text("Bank Passbook \n Cancel Cheque",
                      style: TextStyle(
                          fontSize: deviceWidth!*.04,
                          color: Colors.black,
                          fontWeight: FontWeight.bold)),
                  InkWell(
                    onTap: () {
                      takeImage(ImageSource.gallery, "Bank Passbook");
                    },
                    child: CustomPaint(
                      painter: DashedBorderPainter(),
                      child: Container(
                          height: deviceHeight! * 15 / 100,
                          width: deviceWidth! * 30 / 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: const Color(0xFFE7E3E3),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 0),
                            child: getStorage.read("bankPassBookFile") != null
                                ? Image.file(
                                    File(getStorage.read("bankPassBookFile")),
                                    fit: BoxFit
                                        .cover) // Display the image if it's not null
                                : const Center(
                                    child: Image(
                                      image: AssetImage(
                                          "assets/images/Document.png"),
                                      width: 20,
                                    ), // Display a message if imageFile is null
                                  ),
                          )),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: deviceHeight! * .02,
            ),
            FadeInUp(
              duration: const Duration(milliseconds: 2000),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text("Lab Registration \n Certificate *",
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.bold)),
                  InkWell(
                    onTap: () {
                      takeImage(ImageSource.gallery, "Lab Certificate");
                    },
                    child: CustomPaint(
                      painter: DashedBorderPainter(),
                      child: Container(
                          height: deviceHeight! * 15 / 100,
                          width: deviceWidth! * 30 / 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: const Color(0xFFE7E3E3),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 0),
                            child: getStorage.read("labCertificateFile") != null
                                ? Image.file(
                                    File(getStorage.read("labCertificateFile")),
                                    fit: BoxFit
                                        .cover) // Display the image if it's not null
                                : const Center(
                                    child: Image(
                                      image: AssetImage(
                                          "assets/images/Document.png"),
                                      width: 20,
                                    ), // Display a message if imageFile is null
                                  ),
                          )),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: deviceHeight! * .05,
            ),
            FadeInUp(
              duration: const Duration(milliseconds: 2000),
              child: SizedBox(
                width: deviceWidth! - 50,
                height: deviceHeight! * .06,
                child: ElevatedButton(
                  onPressed: () {
                    if (areAllImagesSelected()) {
                      showDialog(context: context,
                        barrierDismissible: false,
                        builder: (context) => const CircularProgress(),);
                      Future.delayed(
                        const Duration(milliseconds: 2000),
                        () {
                          registrationPercentage = 0.90;
                          Get.to(() => const UserRegistration5(),)?.then((value){
                            Navigator.pop(context);
                          }
                          );
                        },
                      );
                    } else {
                      Get.snackbar(
                          'Alert', 'Please select all required images.',
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                          icon: const Icon(
                            Icons.error,
                            color: Colors.white,
                          ));
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
    );
  }
}
