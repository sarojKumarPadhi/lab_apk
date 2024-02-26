import 'package:flutter/material.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jonk_lab/global/color.dart';
import 'package:jonk_lab/global/globalData.dart';

import '../controller/ride_price_controller.dart';

class SetRidePrice extends StatelessWidget {
  SetRidePrice({super.key});

  RidePriceController ridePriceController = Get.put(RidePriceController());

  final minimumPriceController = TextEditingController();
  final perKmPriceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    minimumPriceController.text = ridePriceController.minimumRidePrice.value;
    perKmPriceController.text = ridePriceController.perKmPrice.value;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: Text("Set Ride Price", style: GoogleFonts.acme()),
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: deviceWidth! * .05),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Set Minimum Price -:",
                        style:
                        GoogleFonts.acme(fontSize: deviceWidth! * .06)),
                    Container(
                      width: deviceWidth! * .3,
                      child: TextFormField(
                        controller: minimumPriceController,
                        style: TextStyle(fontWeight: FontWeight.bold),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          fillColor: Colors.black12,
                          filled: true,
                          hintText: "100",
                          hintStyle: TextStyle(color: Colors.black12),
                          prefixIcon: Icon(Icons.currency_rupee_outlined),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  10)), // Removing the border
                          // You can keep either border or enabledBorder as null, not necessarily both
                          // enabledBorder: InputBorder.none, // Optionally, remove the enabled border as well
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: deviceHeight! * .04,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("per km Price -:",
                        style:
                        GoogleFonts.acme(fontSize: deviceWidth! * .06)),
                    Container(
                      width: deviceWidth! * .3,
                      child: TextFormField(
                        controller: perKmPriceController,
                        style: TextStyle(fontWeight: FontWeight.bold),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          fillColor: Colors.black12,
                          filled: true,
                          hintText: "25",
                          hintStyle: TextStyle(color: Colors.black12),
                          prefixIcon: Icon(Icons.currency_rupee_outlined),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  10)), // Removing the border
                          // You can keep either border or enabledBorder as null, not necessarily both
                          // enabledBorder: InputBorder.none, // Optionally, remove the enabled border as well
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: deviceHeight! * .04,
                ),
                Container(
                  width: deviceWidth! * .6,
                  height: deviceHeight! * .06,
                  child: AnimatedButton(
                    text: 'SUBMIT',
                    isReverse: true,
                    selectedBackgroundColor: primaryColor,
                    selectedTextColor: Colors.black,
                    selectedText: "Updated",
                    transitionType: TransitionType.LEFT_TO_RIGHT,
                    textStyle: GoogleFonts.acme(fontSize: deviceWidth! * .05),
                    backgroundColor: Colors.white,
                    borderColor: Colors.black,
                    borderRadius: 0,
                    borderWidth: 1, onPress: () {
                    ridePriceController.updateRate(
                        minimumPriceController.text,
                        perKmPriceController.text);
                  },
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
