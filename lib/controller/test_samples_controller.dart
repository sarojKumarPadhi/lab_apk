import 'package:get/get.dart';


class TestSamplesController extends GetxController {
  RxList<String> testSamples = <String>[].obs;


  addSample(String sampleName) {
    if (testSamples.contains(sampleName)) {
      testSamples.remove(sampleName);
    } else {
      testSamples.add(sampleName);

    }

  }

}
