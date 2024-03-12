import 'package:get/get.dart';

import '../page/newPatient.dart';

class TestSamplesController extends GetxController {
  RxList<String> testSamples = <String>[].obs;

  addSample(String sampleName) {
    if (testSamples.contains(sampleName)) {
      testSamples.remove(sampleName);
      NewPatient.tests=testSamples;
    } else {
      testSamples.add(sampleName);
      NewPatient.tests=testSamples;

    }
  }
}
