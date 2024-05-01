import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jonk_lab/global/color.dart';
import '../global/globalData.dart';
import '../global/progressIndicator.dart';
import '../global/reviewAlert.dart';



class UserRegistration5 extends StatefulWidget {
  const UserRegistration5({super.key});
  @override
  State<UserRegistration5> createState() => _UserRegistration5State();
}
class _UserRegistration5State extends State<UserRegistration5> {
  GetStorage getStorage = GetStorage();
  final ImagePicker imagePicker = ImagePicker();
  imagePickerMethod(ImageSource source, String documentType) async {
    final pickedImage =
        await imagePicker.pickImage(source: source, imageQuality: 20);
    if (pickedImage != null) {
      switch (documentType) {
        case "Picture 1":
          {
            getStorage.write("picture1", File(pickedImage.path).path);
            setState(() {});
          }
          break;
        case "Picture 2":
          {
            getStorage.write("picture2", File(pickedImage.path).path);
            setState(() {});
          }
          break;
        case "Picture 3":
          {
            getStorage.write("picture3", File(pickedImage.path).path);
            setState(() {});
          }
          break;
        case "Picture 4":
          {
            getStorage.write("picture4", File(pickedImage.path).path);
            setState(() {});
          }
          break;
      }
    }
  }
  bool areAllImageSelected() {
    return getStorage.read("picture1") != null &&
        getStorage.read("picture2") != null &&
        getStorage.read("picture3") != null &&
        getStorage.read("picture4") != null;
  }
  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("Lab Picture Upload",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: appBarColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            linearProgress(),
            SizedBox(
              height: deviceHeight * .03,
            ),
            FadeInUp(
              duration: const Duration(milliseconds: 2000),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                   Text("Picture 1* \n (inner)",
                      style: TextStyle(
                          fontSize: deviceWidth*.045,
                          color: Colors.black,
                          fontWeight: FontWeight.bold)),
                  InkWell(
                    onTap: () {
                      imagePickerMethod(ImageSource.gallery, "Picture 1");
                    },
                    child: CustomPaint(
                      painter: DashedBorderPainter(),
                      child: Container(
                          height: deviceHeight * 14 / 100,
                          width: deviceWidth * 30 / 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: const Color(0xFFE7E3E3),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 0),
                            child: getStorage.read("picture1") != null
                                ? Image.file(File(getStorage.read("picture1")),
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
              height: deviceHeight * .02,
            ),
            FadeInUp(
              duration: const Duration(milliseconds: 2000),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                   Text("Picture 2* \n(inner)",
                      style: TextStyle(
                          fontSize: deviceWidth*.045,
                          color: Colors.black,
                          fontWeight: FontWeight.bold)),
                  InkWell(
                    onTap: () {
                      imagePickerMethod(ImageSource.gallery, "Picture 2");
                    },
                    child: CustomPaint(
                      painter: DashedBorderPainter(),
                      child: Container(
                          height: deviceHeight * 14 / 100,
                          width: deviceWidth * 30 / 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: const Color(0xFFE7E3E3),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 0),
                            child: getStorage.read("picture2") != null
                                ? Image.file(File(getStorage.read("picture2")),
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
              height: deviceHeight * .02,
            ),
            FadeInUp(
              duration: const Duration(milliseconds: 2000),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                   Text("Picture 3* \n(outer)",
                      style: TextStyle(
                          fontSize: deviceWidth*.045,
                          color: Colors.black,
                          fontWeight: FontWeight.bold)),
                  InkWell(
                    onTap: () {
                      imagePickerMethod(ImageSource.gallery, "Picture 3");
                    },
                    child: CustomPaint(
                      painter: DashedBorderPainter(),
                      child: Container(
                          height: deviceHeight * 15 / 100,
                          width: deviceWidth * 30 / 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: const Color(0xFFE7E3E3),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 0),
                            child: getStorage.read("picture3") != null
                                ? Image.file(File(getStorage.read("picture3")),
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
              height: deviceHeight * .02,
            ),
            FadeInUp(
              duration: const Duration(milliseconds: 2000),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                   Text("Picture 4* \n(outer)",
                      style: TextStyle(
                          fontSize: deviceWidth*.045,
                          color: Colors.black,
                          fontWeight: FontWeight.bold)),
                  InkWell(
                    onTap: () {
                      imagePickerMethod(ImageSource.gallery, "Picture 4");
                    },
                    child: CustomPaint(
                      painter: DashedBorderPainter(),
                      child: Container(
                          height: deviceHeight * 15 / 100,
                          width: deviceWidth * 30 / 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: const Color(0xFFE7E3E3),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 0),
                            child: getStorage.read("picture4") != null
                                ? Image.file(File(getStorage.read("picture4")),
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
              height: deviceHeight * .05,
            ),
            FadeInUp(
              duration: const Duration(milliseconds: 2000),
              child: SizedBox(
                height: deviceHeight * .06,
                width: deviceWidth - 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (areAllImageSelected()) {
                      reviewAlert(context);
                    } else {
                      Get.snackbar("Alert", "All images Required",
                          colorText: Colors.white,
                          backgroundColor: Colors.red,
                          icon: const Icon(
                            Icons.error,
                            color: Colors.white,
                          ));
                    }
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(appBarColor),
                      shape: MaterialStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      )),
                  child: const Text("Final Submit for Review",
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
