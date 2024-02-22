import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jonk_lab/global/globalData.dart';
import 'package:jonk_lab/page/homePage.dart';
import 'package:jonk_lab/page/introSliderScreen.dart';
import 'package:jonk_lab/page/searchRiderPage.dart';
import 'package:jonk_lab/page/userRegistration.dart';

import '../component/checkLatestRide.dart';
import '../controller/lab_basic_details.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(seconds: 3),
      () => navigateToScreen(),
    );
  }

  navigateToScreen() async {
    String? auth = FirebaseAuth.instance.currentUser?.uid;
    if (auth != null) {
      if (await checkUserExistInDatabase()) {
        Get.offAll(() => const UserRegistration(),
            duration: const Duration(milliseconds: 300),
            transition: Transition.leftToRight);
      } else {
        bool status = await checkLatestRide();
        if (status) {
          LabBasicDetailsController labBasicDetailsController = Get.put(LabBasicDetailsController());
          print(labBasicDetailsController.labBasicDetailsData.value.userId.toString());

          Future.delayed(const Duration(seconds: 3),() {
            Get.offAll(() => const SearchRiderPage(),
                duration: const Duration(milliseconds: 300),
                transition: Transition.leftToRight);
          },);



        } else {
          Get.offAll(() => const HomePage(),
              duration: const Duration(milliseconds: 300),
              transition: Transition.leftToRight);
        }
      }
    } else {
      Get.offAll(() => const IntroSliderScreen(),
          duration: const Duration(milliseconds: 300),
          transition: Transition.leftToRight);
    }
  }

  Future<bool> checkUserExistInDatabase() async {
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
    return const Scaffold(
        backgroundColor: Colors.white,
        body: ColorfulSafeArea(
          color: Colors.white,
          child: Center(
            child:
                Image(image: AssetImage("assets/images/jonk.png"), width: 200),
          ),
        ));
  }
}
