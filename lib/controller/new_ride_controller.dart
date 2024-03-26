import 'dart:math';
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
import '../model/patient_data_model.dart';
import 'master_list_controller.dart';

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

  startRecording(){

  }
  stopRecording(){

  }
  listenRecording(){

  }
}
