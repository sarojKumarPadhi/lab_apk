import 'package:animate_do/animate_do.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jonk_lab/global/globalData.dart';
import 'package:jonk_lab/page/homePage.dart';
import 'package:jonk_lab/page/introSliderScreen.dart';
import 'package:jonk_lab/page/userRegistration.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {



  getDeviceToken() async {
    FirebaseMessaging messaging=FirebaseMessaging.instance;
    String? deviceToken=await messaging.getToken();
    print(deviceToken);
  }

  @override
  void initState() {
    super.initState();
    getDeviceToken();
    Future.delayed(
      const Duration(seconds: 3),
      () => navigateToScreen(),
    );
  }

  navigateToScreen() async {
    String? auth = FirebaseAuth.instance.currentUser?.uid;
    if (auth != null) {
      if (await checkUserInRegistrationProcess()) {
        Get.offAll(() => const UserRegistration(),
            duration: const Duration(milliseconds: 300),
            transition: Transition.leftToRight);
      } else {
        // bool status = await checkLatestRide();
        // if (status) {
        //   LabBasicDetailsController labBasicDetailsController = Get.put(LabBasicDetailsController());
        //   print(labBasicDetailsController.labBasicDetailsData.value.userId.toString());
        //
        //   Future.delayed(const Duration(seconds: 3),() {
        //     Get.offAll(() => const SearchRiderPage(),
        //         duration: const Duration(milliseconds: 300),
        //         transition: Transition.leftToRight);
        //   },);
        //
        //
        //
        // } else {
        Get.offAll(() => const HomePage(),
            duration: const Duration(milliseconds: 300),
            transition: Transition.leftToRight);
        // }
      }
    } else {
      Get.offAll(() => const IntroSliderScreen(),
          duration: const Duration(milliseconds: 300),
          transition: Transition.leftToRight);
    }
  }

  Future<bool> checkUserInRegistrationProcess() async {
    // String? auth = FirebaseAuth.instance.currentUser?.uid;
    GetStorage authData = GetStorage();
    var status = await authData.read("auth");
    if (status != null) {
      return true;
    }
    return false;
    // return false;
  }

  @override
  Widget build(BuildContext context) {
    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.white,
        body: ColorfulSafeArea(
          color: Colors.white,
          child: Center(
              child: FadeInDown(
            child: const Image(
                image: AssetImage("assets/images/jonk.png"), width: 200),
          )),
        ));
  }
}
