import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jonk_lab/controller/lab_basic_details.dart';

import 'get_profile_controller.dart';

class UpdateProfileController extends GetxController {
  LabBasicDetailsController labBasicDetailsController = Get.find();
  GetProfileImageController getProfileImageController =
      Get.put(GetProfileImageController());
  final picker = ImagePicker();
  XFile? pickedFile;
  String? imageUrl;

  Future<void> updateProfile() async {
    pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imageUrl = pickedFile!.path;
    }
    if (imageUrl != null) {
      Fluttertoast.showToast(msg: "Image picked: ${imageUrl!}");
      uploadImages();
    }
  }

  uploadImages() async {
    String? labName = labBasicDetailsController
        .labBasicDetailsData.value.basicDetails?.labName;
    String dateTimeNow = DateTime.now().toString();
    final storageRef = FirebaseStorage.instance
        .ref()
        .child("lab/$labName/profileImages$dateTimeNow");
    UploadTask uploadTask =
        storageRef.putFile(File(imageUrl!)); // Changed putString to putFile

    await uploadTask.whenComplete(() async {
      String url = await storageRef.getDownloadURL();
      uploadInFirestore(url);
    });
  }

  Future<void> uploadInFirestore(String url) async {
    String auth = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection("lab")
        .doc(auth)
        .update({"profileImage": url}).then((value) {
      getProfileImageController.getProfileImage();
    });
  }
}
