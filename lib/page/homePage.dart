import 'package:badges/badges.dart' as badges;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jonk_lab/drawer_item/profile/lab_profile.dart';
import 'package:jonk_lab/global/color.dart';
import 'package:jonk_lab/global/globalData.dart';
import 'package:jonk_lab/global/logout.dart';
import 'package:jonk_lab/page/newPatient.dart';
import 'package:jonk_lab/page/trackSample.dart';
import 'package:lottie/lottie.dart';

import '../controller/lab_basic_details.dart';
import '../controller/test_menu_controller.dart';
import '../drawer_item/Support.dart';
import '../drawer_item/payment/Earnings_Screen.dart';
import 'notificationPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  LabBasicDetailsController labBasicDetailsController =
      Get.put(LabBasicDetailsController());
  TestMenuController testMenuController = Get.put(TestMenuController());

  @override
  void initState() {
    super.initState();
  }

  Future<bool> checkConnectivity() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height; //834
    var width = MediaQuery.of(context).size.width; //392
    print(testMenuController.testMenuList.length.toString());
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/img_5.png'), fit: BoxFit.cover)),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.white),
            backgroundColor: appBarColor,
            actions: [
              InkWell(
                onTap: () {
                  Get.to(() => const NotificationPage());
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: deviceWidth! * .06),
                  child: badges.Badge(
                    badgeContent:
                        Text('0', style: GoogleFonts.acme(color: Colors.white)),
                    child: Icon(
                      Icons.notification_important_rounded,
                      size: deviceWidth! * .1,
                    ),
                  ),
                ),
              )
            ],
          ),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                    decoration: BoxDecoration(
                      color: primaryColor,
                    ),
                    child: Obx(
                      () => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    labBasicDetailsController
                                            .labBasicDetailsData
                                            .value
                                            .basicDetails
                                            ?.labName ??
                                        "pratham lab..",
                                    style: GoogleFonts.acme(
                                        fontSize: deviceWidth! * .09),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        labBasicDetailsController
                                                    .labBasicDetailsData
                                                    .value
                                                    .accountStatus ==
                                                true
                                            ? "Verified"
                                            : "Not Verified ",
                                        style: GoogleFonts.acme(
                                            fontSize: deviceWidth! * .05),
                                      ),
                                      labBasicDetailsController
                                                  .labBasicDetailsData
                                                  .value
                                                  .accountStatus ==
                                              true
                                          ? const Icon(
                                              Icons.verified,
                                              color: Colors.green,
                                            )
                                          : const Icon(
                                              Icons.cancel,
                                              color: Colors.red,
                                            )
                                    ],
                                  ),
                                ],
                              ),
                              Image.asset("assets/icon/labIcon.png",
                                  width: deviceWidth! * .25),
                            ],
                          ),
                        ],
                      ),
                    )),
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
                  title: const Text('Payments'),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EarningsScreen(),
                        ));
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
                                      "Hello, ${labBasicDetailsController.labBasicDetailsData.value.basicDetails?.labName ?? ""}",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: width * 6.3 / 100,
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
                                  Get.to(() => NewPatient(),
                                      transition: Transition.leftToRight,
                                      duration:
                                          const Duration(milliseconds: 400));
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
                                              "New \nSample \nPath",
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
                                  Get.to(() => const TrackSample(),
                                      transition: Transition.leftToRight,
                                      duration:
                                          const Duration(milliseconds: 400));
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
                                        child: Row(
                                          children: [
                                            Text(
                                              "Track \nSample \nPath",
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
}
