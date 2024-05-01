import 'package:get/get.dart';

class RefreshTransitionController extends GetxController {
  RxBool rotateTransition = false.obs;

  rotateIcon() {
    rotateTransition.value = true;
  }
}
