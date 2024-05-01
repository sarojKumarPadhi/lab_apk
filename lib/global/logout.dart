import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:quickalert/quickalert.dart';
import '../page/splash_screen.dart';

logoutAlert(context) {
  QuickAlert.show(
    context: context,
    type: QuickAlertType.confirm,
    onConfirmBtnTap: () async {
      await FirebaseAuth.instance.signOut();
      GetStorage data = GetStorage();
      data.remove("auth");
      Get.offAll(() => const SplashScreen());
    },
    confirmBtnText: "Yes",
  );
}
