import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jonk_lab/drawer_item/profile/lab_profile.dart';
import 'package:jonk_lab/global/color.dart';
import 'package:jonk_lab/global/globalData.dart';
import 'package:jonk_lab/global/logout.dart';
import 'package:jonk_lab/page/revenue.dart';
import 'package:jonk_lab/page/track_sample.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import '../controller/get_profile_controller.dart';
import '../controller/lab_basic_details.dart';
import '../controller/test_menu_controller.dart';
import '../controller/update_profile_controller.dart';
import '../drawer_item/Support.dart';
import '../drawer_item/master_list.dart';
import '../service/push_notification_service.dart';
import '../services/email_service.dart';
import 'new_patient.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  LabBasicDetailsController labBasicDetailsController =
      Get.put(LabBasicDetailsController());
  UpdateProfileController updateProfileController =
      Get.put(UpdateProfileController());

  GetProfileImageController getProfileImageController =
      Get.put(GetProfileImageController());

  TestMenuController testMenuController = Get.put(TestMenuController());
  // static const platform = MethodChannel("methodChannel");
  Future<void> newDeviceToken() async {
    String? deviceToken = await firebaseMessaging.getToken();
    print("this is device token : $deviceToken");
    updateDeviceToken(deviceToken!);
  }
  @override
  void initState() {
    print(getProfileImageController.profileUrl.value);
    super.initState();
    requestSmsPermission();
    newDeviceToken();
    PushNotificationService().initializeCloudMessaging(context);
    PushNotificationService().requestNotificationPermissions();

    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);
  }

  Future<bool> checkConnectivity() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }




  Future<void> requestSmsPermission() async {
    if (await Permission.sms.request().isGranted) {
      // Permission is already granted, proceed with sending SMS
      // sendSms("8210109466", "2345678");
    } else {
      // Permission has not been granted yet. Request it.
      if (await Permission.sms.request().isGranted) {
        // sendSms();
      } else {
        // Permission denied. Show an error message or handle it gracefully.
        print('SMS permission denied');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height; //834
    var width = MediaQuery.of(context).size.width; //392
    print(testMenuController.testMenuList.length.toString());
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/bg_image.jpg'), fit: BoxFit.cover)),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.white),
            backgroundColor: appBarColor,
            // actions: [
            //   InkWell(
            //     onTap: () {
            //       Get.to(() => const NotificationPage());
            //     },
            //     child: Padding(
            //       padding: EdgeInsets.symmetric(horizontal: deviceWidth! * .06),
            //       child: badges.Badge(
            //         badgeContent:
            //             Text('0', style: GoogleFonts.acme(color: Colors.white)),
            //         child: Icon(
            //           Icons.notification_important_rounded,
            //           size: deviceWidth! * .1,
            //         ),
            //       ),
            //     ),
            //   )
            // ],
          ),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                Obx(
                  () => DrawerHeader(
                    decoration: BoxDecoration(
                      color: getProfileImageController.profileUrl.value != ""
                          ? Colors.transparent
                          : primaryColor,
                      image: getProfileImageController.profileUrl.value != ""
                          ? DecorationImage(
                              fit: BoxFit.cover,
                              image: CachedNetworkImageProvider(
                                getProfileImageController.profileUrl.value,
                              ),
                            )
                          : null,
                    ),
                    child: Stack(
                      children: [
                        Container(
                          padding: EdgeInsets.all(deviceWidth! * .05),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            borderRadius:
                                BorderRadius.circular(deviceWidth! * .02),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                labBasicDetailsController.labBasicDetailsData
                                        .value.basicDetails?.labName ??
                                    "Pratham Lab",
                                style: TextStyle(
                                  fontSize: deviceWidth! * .04,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Icon(
                                    labBasicDetailsController
                                            .labBasicDetailsData
                                            .value
                                            .accountStatus
                                        ? Icons.verified
                                        : Icons.cancel,
                                    color: labBasicDetailsController
                                            .labBasicDetailsData
                                            .value
                                            .accountStatus
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    labBasicDetailsController
                                            .labBasicDetailsData
                                            .value
                                            .accountStatus
                                        ? "Verified"
                                        : "Not Verified",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: labBasicDetailsController
                                              .labBasicDetailsData
                                              .value
                                              .accountStatus
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: GestureDetector(
                            onTap: () {
                              updateProfileController.updateProfile();
                            },
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.edit,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.person,
                    color: Colors.black,
                  ),
                  title: const Text('Profile'),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LabProfilePage(),
                        ));
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(
                    Icons.payment,
                    color: Colors.black,
                  ),
                  title: const Text('Master List'),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MasterList(),
                        ));
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(
                    Icons.payment,
                    color: Colors.black,
                  ),
                  title: const Text('History'),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyRideScreen(userUid: FirebaseAuth.instance.currentUser!.uid,),
                        ));
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(
                    Icons.payment,
                    color: Colors.black,
                  ),
                  title: const Text('Payments'),
                  onTap: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) => MyRideScreen(userUid: FirebaseAuth.instance.currentUser!.uid,),
                    //     ));
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(
                    Icons.track_changes,
                    color: Colors.black,
                  ),
                  title: const Text('Track Sample'),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TrackSample(),
                        ));
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(
                    Icons.support_agent_outlined,
                    color: Colors.black,
                  ),
                  title: const Text('Support'),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ChatWithSupport(),
                        ));
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.logout),
                  // You can use a different icon here
                  title: const Text('Logout'),
                  onTap: () {
                    logoutAlert(context);
                  },
                ),
              ],
            ),
          ),
          body: FutureBuilder(
            future: checkConnectivity(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data == true) {
                  return Obx(
                    () => Column(
                      children: [
                        Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, top: 20),
                                    child: Text(
                                      labBasicDetailsController
                                              .labBasicDetailsData
                                              .value
                                              .basicDetails
                                              ?.labName ??
                                          "",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: deviceWidth! * .055,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, top: 5),
                                child: Row(
                                  children: [
                                    const Icon(Icons.location_on),
                                    Text(
                                      labBasicDetailsController
                                              .labBasicDetailsData
                                              .value
                                              .address
                                              ?.city ??
                                          "Hisar",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: width * 4 / 100,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                        Padding(
                          padding: EdgeInsets.only(
                            top: height * .04,
                            left: width * .1,
                          ),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  if (labBasicDetailsController
                                      .labBasicDetailsData
                                      .value
                                      .accountStatus) {
                                    Get.to(() => const NewPatient(),
                                        transition: Transition.leftToRight,
                                        duration:
                                            const Duration(milliseconds: 400));
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            backgroundColor: Colors.red,
                                            content: Text(
                                                "Your account is not verified")));
                                  }
                                },
                                child: Container(
                                  width: width * .4,
                                  height: height * .2,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: const Color(0xFF111111),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 9, right: 15),
                                            child: SvgPicture.asset(
                                                "assets/icon/addNewSample.svg",
                                                width: deviceWidth! * .1),
                                          )
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8),
                                        child: Row(
                                          children: [
                                            Text(
                                              "Home \nCollection \nBooking",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: height / 40,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: height * .05, left: width * .1),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  if (labBasicDetailsController
                                      .labBasicDetailsData
                                      .value
                                      .accountStatus) {
                                    Get.to(() => const TrackSample(),
                                        transition: Transition.leftToRight,
                                        duration:
                                            const Duration(milliseconds: 400));
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          backgroundColor: Colors.red,
                                            content: Text(
                                                "Your account is not verified")));
                                  }
                                },
                                child: Container(
                                  width: width * .4,
                                  height: height * .20,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: const Color(0xFF111111),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 9, right: 15),
                                            child: SvgPicture.asset(
                                                "assets/icon/newSamplePath.svg",
                                                width: deviceWidth! * .1),
                                          )
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Track",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: deviceWidth!*.05,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              "PHLEBOTOMISTS",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: deviceWidth!*.04,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Center(
                    child: Column(
                      children: [
                        Lottie.asset('assets/lotifiles/no-internet.json'),
                        Expanded(
                          child: Container(
                            width: deviceWidth,
                            height: deviceHeight! * .4,
                            color: Colors.white,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Check Your Internet",
                                    style: GoogleFonts.acme(
                                        fontWeight: FontWeight.bold,
                                        fontSize: deviceWidth! * .05)),
                                Text("Restart your Application",
                                    style: GoogleFonts.acme(
                                        fontWeight: FontWeight.bold,
                                        fontSize: deviceWidth! * .05)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              }
              return Center(
                child: Column(
                  children: [
                    Lottie.asset('assets/lotifiles/no-internet.json'),
                    Expanded(
                      child: Container(
                        width: deviceWidth,
                        height: deviceHeight! * .4,
                        color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Check Your Internet",
                                style: GoogleFonts.acme(
                                    fontWeight: FontWeight.bold,
                                    fontSize: deviceWidth! * .05)),
                            Text("Restart your Application",
                                style: GoogleFonts.acme(
                                    fontWeight: FontWeight.bold,
                                    fontSize: deviceWidth! * .05)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          )),
    );
  }


  Future updateDeviceToken(String value) async {
    try {
      String uId = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance.collection("lab").doc(uId).update({
        "deviceToken": value,
      });
      // Get.snackbar("FCM token", "fcm token  updated",
      //     backgroundColor: primaryColor, colorText: Colors.white);
    } catch (e) {
      Get.snackbar("FCM token", "fcm token not updated",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

}
