import 'dart:io';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart' as audio;
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jonk_lab/controller/ride_price_controller.dart';
import 'package:jonk_lab/controller/rider_price_controller.dart';
import 'package:jonk_lab/controller/test_samples_controller.dart';
import 'package:record/record.dart';
import 'package:uuid/uuid.dart';
import '../model/patient_data_model.dart';
import '../page/new_patient.dart';
import 'master_list_controller.dart';

class NewRideController extends GetxController {
  int customerIndex=0;
  LatLng? patientLatLng;
  RxString audioPath = "".obs;
  RxBool isRecording = false.obs;
  RxString patientLocation = "Enter Patient Location".obs;
  RxString patientActualLocation = "".obs;
  RxString gender = "male".obs;
  RxString patientName = "".obs;
  RxString patientAge = "".obs;
  RxString labPrice = "".obs;
  RxString patientPhoneNumber = "".obs;
  bool isEditable = false;
  bool isAdd = false;
  RxBool isNewAddButtonShow = false.obs;
  RxList<PatientDataModel> patientList = <PatientDataModel>[].obs;
  RxList<PatientDataModel> patientListAfterSelection = <PatientDataModel>[].obs;
  TestSamplesController testSamplesController =
      Get.put(TestSamplesController());
  MasterListController masterListController = Get.put(MasterListController());
  RxList<String> selectedPatientsId = <String>[].obs;
  RxList<String> checkedPatientsId = <String>[].obs;

  RidePriceController ridePriceController = Get.put(RidePriceController());
  PriceController priceController = Get.put(PriceController());
  RxBool isViewAll = false.obs;

  Future<void> viewAllViewLess() async {
    isViewAll.value = !isViewAll.value;
  }

  Future<void> checkUncheck(String customerId) async {
    if (checkedPatientsId.contains(customerId)) {
      checkedPatientsId.remove(customerId);
    } else {
      checkedPatientsId.add(customerId);
    }
  }

  addNewPatient(BuildContext context) {
    Random random = Random();
    int uniqueCode = random.nextInt(10000);
    patientList.add(PatientDataModel(
        id: uniqueCode.toString(),
        name: patientName.value,
        age: patientAge.value,
        gender: gender.value,
        phone: patientPhoneNumber.value,
        sampleList: List.from(testSamplesController.testSamples)));
    checkedPatientsId.add(uniqueCode.toString());
    priceController.price.value +=
        (patientList.length - 1) * ridePriceController.minimumRidePrice.value;

  }

  addNewPatientFromMasterList(String customerId) {

    int index = masterListController.masterList
        .indexWhere((element) => element.id == customerId);

    patientList.add(PatientDataModel(
      id: masterListController.masterList[index].id!,
      name: masterListController.masterList[index].name!,
      age: masterListController.masterList[index].age!,
      gender: masterListController.masterList[index].gender!,
      phone: masterListController.masterList[index].phone!,
      sampleList: masterListController.masterList[index].samples!,
    ));

    checkedPatientsId.add(customerId);
  }

  deleteFromPatientList(int index, BuildContext context) {
    if (patientList.length > 1) {
      priceController.price.value -= ridePriceController.minimumRidePrice.value;
    }
    patientList.removeAt(index);
    Navigator.pop(context);
  }

  editPatientDetailsUsingIndex(BuildContext context, int index) {
    patientList[index].sampleList = List<String>.from(testSamplesController.testSamples);
    patientList[index].age = patientAge.value;
    patientList[index].phone = patientPhoneNumber.value;
    patientList[index].name = patientName.value;
    patientList.refresh();
  }

  ///      update details in firebase firestore
  updateDetails(String customerId, BuildContext context) async {
    TestSamplesController testSamplesController = Get.find();
    String auth = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection("lab")
        .doc(auth)
        .get()
        .then((DocumentSnapshot snapshot) async {
      if (snapshot.exists) {
        List<dynamic> list = snapshot.get("masterData") ?? [];

        // Check if the index is within the bounds of the list
        int indexNumber = list.indexWhere((e) => e["customerId"] == customerId);
        if (indexNumber >= 0 && indexNumber < list.length) {
          // Update the specific index
          list[indexNumber] = {
            "name": patientName.value,
            "age": patientAge.value,
            "phoneNumber": patientPhoneNumber.value,
            "samples": List.from(testSamplesController.testSamples),
            "gender": gender.value,
            "customerId": customerId
          };

          // Update the Firestore document
          await FirebaseFirestore.instance
              .collection("lab")
              .doc(auth)
              .update({"masterData": list});
        } else {
          print("Index out of bounds");
        }
      }
    });
  }

  startRecording() async {
    try {
      if (await Record().hasPermission()) {
        await Record().start();
        isRecording.value = true;
      }
    } catch (e) {
      print(e);
    }
  }

  stopRecording() async {
    try {
      String? path = await Record().stop();
      isRecording.value = false;
      audioPath.value = path!;
      uploadAudioToFirebase();
    } catch (e) {
      print(e);
    }
  }

  listenRecording() async {
    try {
      audio.Source urlSource = UrlSource(audioPath.value);
      await AudioPlayer().play(urlSource);
    } catch (e) {
      print("playing $e");
    }
  }

  Future uploadAudioToFirebase() async {
    if (audioPath.value != null) {
      var ref = FirebaseStorage.instance
          .ref()
          .child('labAudio')
          .child(const Uuid().v4());
      UploadTask uploadTask = ref.putFile(File(audioPath.value));
      TaskSnapshot snapshot = await uploadTask;
      NewPatient.audioUrl = await snapshot.ref.getDownloadURL();
      print(NewPatient.audioUrl);
      print(NewPatient.audioUrl);
      print(NewPatient.audioUrl);
    }
  }
}
