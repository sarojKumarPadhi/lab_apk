import 'package:animate_do/animate_do.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jonk_lab/global/color.dart';
import 'package:jonk_lab/global/globalData.dart';
import 'package:jonk_lab/page/mobileNumber.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class IntroSliderScreen extends StatefulWidget {
  const IntroSliderScreen({Key? key}) : super(key: key);

  @override
  State<IntroSliderScreen> createState() => _IntroSliderScreenState();
}

class _IntroSliderScreenState extends State<IntroSliderScreen> {
  final PageController _controller = PageController();
  bool onLastPage = false;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height; //834
    var width = MediaQuery.of(context).size.width; //392
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            PageView(
              controller: _controller,
              onPageChanged: (index) {
                setState(() {
                  onLastPage = (index == 2);
                });
              },
              children: [
                Container(
                  color: firstIntroBackgroundColor,
                  child: AnimatedSwitcher(
                    duration: const Duration(microseconds: 400),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          SizedBox(
                            height: height * .1,
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(deviceWidth!*.01),
                            child: Image.asset(
                            
                              "assets/images/introFirst.jpg",
                              width: deviceWidth! * .8,
                            ),
                          ),
                          SizedBox(
                            height: height * .15,
                          ),
                          Container(
                            alignment: Alignment.center, // Center alignment
                            child: Center(
                              child: Text(
                                "Providing \nHome Sample \nCollections",
                                textAlign: TextAlign.center,
                                // Center align the text horizontally
                                style: TextStyle(
                                    fontSize: width*.07,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white70,
                          secondIntroBackgroundColor
                        ])
                  ),
                  child: AnimatedSwitcher( duration: const Duration(microseconds: 400),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          SizedBox(
                            height: height * .1,
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(deviceWidth!*.01),
                            child: Image.asset(
                              fit:  BoxFit.fill,
                              "assets/images/introSecond.jpg",
                              width: deviceWidth! * .8,
                              height: deviceHeight!*.3,
                            ),
                          ),
                          SizedBox(
                            height: height * .15,
                          ),
                          Container(
                            alignment: Alignment.center, // Center alignment
                            child: Center(
                              child: Text(
                                "Easy Booking &\n Economical",
                                textAlign: TextAlign.center,
                                // Center align the text horizontally
                                style: TextStyle(
                                    fontSize: width * 5.7 / 100,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                FadeInDown(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        SizedBox(
                          height: height * .1,
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(deviceWidth!*.01),
                          child: Image.asset(
                            "assets/images/introThird.jpg",
                            width: deviceWidth! * .8,
                          ),
                        ),
                        SizedBox(
                          height: height * .15,
                        ),
                        Container(
                          alignment: Alignment.center, // Center alignment
                          child: Center(
                            child: Text(
                              "Home Sample Collections  \n Verified & Trained \n PHLEBOTOMISTS",
                              textAlign: TextAlign.center,
                              // Center align the text horizontally
                              style: TextStyle(
                                  fontSize: width * 5.7 / 100,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            FadeInDown(
              child: Container(
                  alignment: const Alignment(0, 0.75),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SmoothPageIndicator(
                        controller: _controller,
                        count: 3,
                      ),
                      SizedBox(
                        height: height * 3.6 / 100,
                      ),
                      GestureDetector(
                          onTap: () {
                            _controller.nextPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeIn);
                          },
                          child: onLastPage
                              ? SizedBox(
                                  height: height * 6 / 100,
                                  width: width * 38.3 / 100,
                                  child: ElevatedButton(
                                      onPressed: () {
                                        Get.to(() => const MobileNumber(),
                                            duration: const Duration(
                                                milliseconds: 400),
                                            transition: Transition.leftToRight);
                                      },
                                      style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          backgroundColor:
                                          primaryColor,
                                          elevation: 1,
                                          shadowColor: Colors.black),
                                      child: const Text(
                                        "Get Started",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      )),
                                )
                              : SizedBox(
                                  height: height * 6 / 100,
                                  width: width * 38.3 / 100,
                                  child: ElevatedButton(
                                      onPressed: () {
                                        _controller.nextPage(
                                            duration: const Duration(
                                                milliseconds: 500),
                                            curve: Curves.easeIn);
                                      },
                                      style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          backgroundColor:
                                              primaryColor,
                                          elevation: 1,
                                          shadowColor: Colors.black),
                                      child: const Text(
                                        "Next",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      )),
                                )),
                      SizedBox(
                        height: height * 9.6 / 100,
                      )
                    ],
                  )),
            )
          ],
        ));
  }
}
