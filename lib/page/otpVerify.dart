import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gif_view/gif_view.dart';
import 'package:jonk_lab/global/globalData.dart';
import 'package:jonk_lab/page/mobileNumber.dart';
import 'package:pinput/pinput.dart';

import '../auth/sendOtp.dart';
import '../auth/verifyOtp.dart';
import '../global/color.dart';
import '../global/progressIndicator.dart';

class OtpVerify extends StatefulWidget {
  const OtpVerify({Key? key}) : super(key: key);

  @override
  State<OtpVerify> createState() => OtpVerifyState();
}

class OtpVerifyState extends State<OtpVerify> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController pinController = TextEditingController();

  @override
  initState() {
    super.initState();
    Future.delayed(
      const Duration(
        seconds: 2,
      ),
      () {
        snackBar();
      },
    );
  }

  snackBar() {
    Get.snackbar(
      "OTP sent on ",
      colorText: Colors.white,
      "$phoneNumber",
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green,
    );
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height; //834
    var width = MediaQuery.of(context).size.width; //392

    return Scaffold(
        body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: Column(
            children: [
              GifView.asset(
                'assets/gif/verifyOtp4.gif',
                height: 200,
                width: 200,
                frameRate: 30, // default is 15 FPS
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  "Enter verification code",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: width * 6 / 100,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: height * 2 / 100),
                child: Text(
                  "We have send you a 6 digit code on",
                  style: TextStyle(
                    color: const Color(0xFF757575),
                    fontSize: width * 3.5 / 100,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: height * 1 / 100),
                    child: Text(
                      "+91 $phoneNumber",
                      style: TextStyle(
                          color: const Color(0xFF505050),
                          fontSize: width * 3.5 / 100,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  InkWell(
                      onTap: () {
                        Get.offAll(() => const MobileNumber(),
                            duration: const Duration(milliseconds: 400),
                            transition: Transition.leftToRight);
                      },
                      child: Image.asset(
                        "assets/icon/edit.png",
                        width: 25,
                      ))
                ],
              ),
              SizedBox(
                height: height * 4.8 / 100,
              ),
              Form(
                key: _formKey,
                child: Pinput(
                  controller: pinController,
                  keyboardType: TextInputType.phone,
                  length: 6,
                  toolbarEnabled: false,
                  showCursor: true,
                  pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                  textInputAction: TextInputAction.next,
                  defaultPinTheme: PinTheme(
                      height: width * 13 / 100,
                      width: width * 13 / 100,
                      textStyle: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.black,
                          width: 1, // Adjust the border width as needed
                        ),
                      )),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter OTP";
                    }
                    if (value.length < 6) {
                      return "Enter a Valid OTP";
                    }
                    return null;
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () {
                        sendOtp(context);
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                                backgroundColor: Colors.black,
                                content: Text(
                                  "sending",
                                  style: TextStyle(color: Colors.white),
                                )));
                      },
                      child: const Text(
                        "Resend otp",
                        style: TextStyle(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ))
                ],
              ),
              SizedBox(
                height: height * 18 / 100,
              ),
              SizedBox(
                height: height * 6.1 / 100,
                width: width * 88 / 100,
                child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => const CircularProgress(),
                        );
                        Future.delayed(
                          const Duration(milliseconds: 2000),
                          () {
                            otp = pinController.text;
                            verifyOtp(context);
                          },
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: primaryColor,
                        elevation: 1,
                        shadowColor: Colors.black),
                    child: Text(
                      "Verify OTP",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: width < 450 ? 16 : 18,
                          fontWeight: FontWeight.bold),
                    )),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
