import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:jonk_lab/global/color.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import 'globalData.dart';


/// -------------------progress dialog ----------------//





class CircularProgress extends StatelessWidget {
  const CircularProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return  SpinKitDualRing(
      color: primaryColor, // Choose your desired color
      size: 50.0,
    );
  }
}





///-------------------------linear progress indicator-------------------


Widget linearProgress(){
  return  FadeInUp(
    duration: const Duration(milliseconds: 2000),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
      child: LinearPercentIndicator(
        width: deviceWidth! - 10,
        animation: true,
        lineHeight: 30.0,
        animationDuration: 2500,
        percent: registrationPercentage,
        center: Text("${registrationPercentage * 100}% Completed",
            style: const TextStyle(
                color: Colors.black87, fontWeight: FontWeight.bold)),
        barRadius: const Radius.circular(20),
        progressColor: Colors.green,
      ),
    ),
  );
}