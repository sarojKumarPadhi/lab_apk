import 'dart:math';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/state_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jonk_lab/controller/ride_price_controller.dart';
import 'package:jonk_lab/controller/rider_price_controller.dart';
import 'package:jonk_lab/controller/test_samples_controller.dart';
import 'package:jonk_lab/model/master_list.dart';
import 'package:jonk_lab/page/newPatient.dart';
import 'package:uuid/uuid.dart';
import '../model/patient_data_model.dart';
import 'master_list_controller.dart';
import 'package:record/record.dart';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart' as audio;
import 'package:audioplayers/audioplayers.dart';

class NewRideController extends GetxController {

  LatLng? patientLatLng;
  RxString audioPath="".obs;
  RxBool isRecording = false.obs;
  RxString patientLocation = "Enter Patient Location".obs;
  RxString patientActualLocation = "".obs;
  RxString gender = "".obs;
  RxString patientName = "".obs;
  RxString patientAge = "".obs;
  RxString labPrice="".obs;
  RxString patientPhoneNumber = "".obs;
  bool isEditable = false;
  bool isAdd = false;
  RxBool isNewAddButtonShow = false.obs;
  RxList<PatientDataModel> patientList = <PatientDataModel>[].obs;
  TestSamplesController testSamplesController =
      Get.put(TestSamplesController());
  MasterListController masterListController = Get.put(MasterListController());
  RxList<String> selectedPatientsId = <String>[].obs;
  RidePriceController ridePriceController = Get.put(RidePriceController());
  PriceController priceController = Get.put(PriceController());

  addNewPatient(BuildContext context) {
    Random random = Random();
    int uniqueCode = random.nextInt(10000);
    patientList.add(PatientDataModel(
        id: uniqueCode.toString(),
        name: patientName.value,
        age: patientAge.value,
        gender: gender.value,
        phone: patientPhoneNumber.value,
        samples: testSamplesController.testSamples.value));
    priceController.price.value +=
        (patientList.length - 1) * ridePriceController.minimumRidePrice.value;
    Navigator.pop(context);
    Navigator.pop(context);
  }

  addNewPatientFromMasterList(String customerId) {
    List<MasterListModel> masterListModel = masterListController
        .masterListController
        .where((MasterListModel masterListModel) =>
            masterListModel.id == customerId)
        .toList();

    patientList.add(PatientDataModel(
        id: masterListModel[0].id!,
        name: masterListModel[0].name!,
        age: masterListModel[0].age,
        gender: masterListModel[0].gender!,
        phone: masterListModel[0].phone!,
        samples: masterListModel[0].samples!));
  }

  deleteFromPatientList(int index) {
    if (patientList.length > 1) {
      priceController.price.value -= ridePriceController.minimumRidePrice.value;
    }
    patientList.removeAt(index);
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
      var ref = FirebaseStorage.instance.ref().child('labAudio').child('${Uuid().v4()}');
      UploadTask uploadTask = ref.putFile(File(audioPath.value));
      TaskSnapshot snapshot = await uploadTask;
     NewPatient.audioUrl = await snapshot.ref.getDownloadURL();
     print(NewPatient.audioUrl);
     print(NewPatient.audioUrl);
     print(NewPatient.audioUrl);
    }
  }
}
