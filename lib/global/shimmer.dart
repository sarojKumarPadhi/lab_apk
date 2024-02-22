import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'globalData.dart';

Widget shimmer(){
  return SizedBox(
    height:deviceHeight!*.4 ,
    width: deviceWidth!*.6,
    child: Shimmer.fromColors(
      baseColor: Colors.grey[100]!,
      highlightColor: Colors.grey[300]!,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.grey,
        ),

        child: const Text(
          'Shimmer',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 40.0,
            fontWeight:
            FontWeight.bold,
          ),
        ),
      ),
    ),
  );
}