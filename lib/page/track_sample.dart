import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jonk_lab/global/color.dart';
import 'package:jonk_lab/global/globalData.dart';
import 'package:jonk_lab/page/after_ride_accept_by_rider.dart';

import '../controller/track_sample_controller.dart';
import '../global/progressIndicator.dart';

class TrackSample extends StatefulWidget {
  const TrackSample({Key? key}) : super(key: key);

  @override
  State<TrackSample> createState() => _TrackSampleState();
}

class _TrackSampleState extends State<TrackSample> {
  TrackSampleController trackSampleData = Get.put(TrackSampleController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0.0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "𝗧𝗿𝗮𝗰𝗸 𝘀𝗮𝗺𝗽𝗹𝗲",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: [

            Obx(() => trackSampleData.isLoading.value
                ? Expanded(
                    child: trackSampleData.listOfSampleData.isNotEmpty
                        ? ListView.builder(
                            itemCount: trackSampleData.listOfSampleData.length,
                            itemBuilder: (BuildContext context, int index) {
                              Map<dynamic, dynamic> data =
                                  trackSampleData.listOfSampleData[index]
                                      as Map<dynamic, dynamic>;
                              String otp = data["labOtp"] ?? "****";
                              return Padding(
                                padding: const EdgeInsets.all(7),
                                child: InkWell(
                                  onTap: () {
                                    Get.to(() => AfterAcceptanceRidePage(
                                        requestId: data["requestId"],
                                        labUid: auth.toString()));
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          spreadRadius: 2,
                                          blurRadius: 10,
                                          offset: const Offset(0,
                                              3), // Offset (horizontal, vertical)
                                        ),
                                      ],
                                      color: Colors.black,
                                      // Background color changed to black
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.person,
                                                    size: 25,
                                                    color: Colors
                                                        .white, // Icon color changed to white
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Text(
                                                    (data["patientDetails"]["patientList"]
                                                                            [0]
                                                                        ["name"]
                                                                    as String)
                                                                .length >
                                                            10
                                                        ? (data["patientDetails"]
                                                                        ["patientList"]
                                                                    [0]["name"]
                                                                as String)
                                                            .substring(0, 10)
                                                        : (data["patientDetails"]
                                                                ["patientList"][0]
                                                            ["name"] as String),
                                                    style: const TextStyle(
                                                        fontSize: 19,
                                                        color: Colors
                                                            .white), // Text color changed to white
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  // Replace "digit" with the actual value of each digit of the OTP
                                                  for (int i = 0;
                                                      i < otp.length;
                                                      i++)
                                                    Container(
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal:
                                                                  deviceWidth! *
                                                                      .005),
                                                      width: deviceWidth! * .07,
                                                      // Adjust width and height as needed
                                                      height:
                                                          deviceHeight! * .05,
                                                      // Adjust height and
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colors.blue),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                      ),
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        otp[i],
                                                        // Display each digit of the OTP
                                                        style: TextStyle(
                                                          color: Colors.blue,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize:
                                                              deviceWidth! *
                                                                  .05,
                                                        ),
                                                      ),
                                                    ),
                                                  const SizedBox(
                                                    width: 5,
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.location_on,
                                                size: 20,
                                                color: Colors
                                                    .white, // Icon color changed to white
                                              ),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: Text(
                                                  data["patientDetails"]
                                                      ["location"],
                                                  style: TextStyle(
                                                      fontSize:
                                                          deviceWidth! * .045,
                                                      color: Colors
                                                          .white), // Text color changed to white
                                                ),
                                              )
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons
                                                        .directions_bike_rounded,
                                                    size: deviceWidth! * .06,
                                                    color: Colors
                                                        .white, // Icon color changed to white
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Text(
                                                    data["riderDetails"]
                                                        ["riderName"],
                                                    style: TextStyle(
                                                        fontSize:
                                                            deviceWidth! * .045,
                                                        color: Colors
                                                            .white), // Text color changed to white
                                                  )
                                                ],
                                              ),
                                              Text(
                                                "Price",
                                                style: TextStyle(
                                                    fontSize:
                                                        deviceWidth! * .05,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors
                                                        .white), // Text color changed to white
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                    color: data["rideStatus"] ==
                                                        "accepted"?Colors.green: data["rideStatus"] ==
                                                        "cancelled"?Colors.red:Colors.blue,
                                                  borderRadius: BorderRadius.circular(deviceWidth!*.01)
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        deviceWidth! * .03),

                                                child: Text(
                                                  data["rideStatus"] ==
                                                          "accepted"
                                                      ? "Accepted"
                                                      : data["rideStatus"] ==
                                                              "arrived"
                                                          ? "Arrived"
                                                          : data["rideStatus"] ==
                                                                  "cancelled"
                                                              ? "Cancelled"
                                                              : data["rideStatus"] ==
                                                                      "completed"
                                                                  ? "Completed"
                                                                  : "On Trip",
                                                  style:  TextStyle(
                                                      fontSize: deviceWidth!*.055,
                                                      color: Colors
                                                          .white), // Text color changed to white
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.currency_rupee_sharp,
                                                    size: deviceWidth! * .05,
                                                    color: Colors
                                                        .white, // Icon color changed to white
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Text(
                                                    data["patientDetails"]
                                                        ["labPrice"],
                                                    style: TextStyle(
                                                        fontSize:
                                                            deviceWidth! * .05,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors
                                                            .white), // Text color changed to white
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                        : const Center(
                            child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [Text("No Sample running")],
                          )),
                  )
                : const Center(
                    child: CircularProgress(),
                  ))
          ],
        ),
      ),
    );
  }
}
