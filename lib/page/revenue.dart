import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controller/dateController.dart';
import '../controller/historyController.dart';
import '../global/color.dart';



class MyRideScreen extends StatelessWidget {
  final String userUid;
  final toDayRideS toDayController = Get.put(toDayRideS());

  MyRideScreen({Key? key, required this.userUid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: appBarColor,
        titleTextStyle: GoogleFonts.acme(color: Colors.white, fontSize: 18),
        title: const Text("Lab's Rides"),
        actions: [],
      ),
      body: ColorfulSafeArea(
        color: Colors.black,
        child: DefaultTabController(
          length: 2, // Number of tabs
          child: Column(
            children: [
              Container(
                margin:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                child: TabBar(
                  tabs: const [
                    Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Tab(text: 'Today'),
                    ),
                    // Tab for today's earnings
                    Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Tab(text: 'History'),
                    ),
                    // Tab for earnings history
                  ],
                  unselectedLabelColor: Colors.blue,
                  labelColor: Colors.white,
                  indicator: BoxDecoration(
                      color: appBarColor,
                      borderRadius: BorderRadius.circular(
                          15) // Set the background color of the tab bar
                  ),
                  labelStyle: const TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.9),
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    ToDayRide(
                      userUid: userUid,
                    ),
                    HistoryRide(
                      userUid: userUid,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class ToDayRide extends StatelessWidget {
  final String userUid;
  final toDayRideS myRide = Get.put(toDayRideS());
  int sum = 0;

  ToDayRide({Key? key, required this.userUid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<List<dynamic>>(
          future: myRide.getMYRideData(uid: userUid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No Home Collection Today'));
            } else {
              return ColorfulSafeArea(
                color: Colors.black,
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height - 180,
                      child: ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> data = snapshot.data![index];
                          sum = sum + int.parse(data['earning']);
                          return InkWell(
                            onTap: () {},
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                margin: const EdgeInsets.only(
                                    top: 10, left: 20, right: 20),
                                decoration: BoxDecoration(
                                  border: Border.all(),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Text(
                                              "Patient Name : ",
                                              style: const TextStyle(fontSize: 14),
                                            ),
                                            Text(
                                              "${data['patientDetails'][0]['name']}",
                                              style: const TextStyle(fontSize: 14),
                                            ),
                                            const Spacer(),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Text(
                                              "Date : ",
                                              style: const TextStyle(fontSize: 14),
                                            ),
                                            Text(
                                              "${data['date']}",
                                              style: const TextStyle(fontSize: 14),
                                            ),
                                            const Spacer(),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Text(
                                              "${'Earning : '}",
                                              style: const TextStyle(fontSize: 14),
                                            ),
                                            Text(
                                              "${data['earning']}",
                                              style: const TextStyle(fontSize: 14),
                                            ),
                                            const Spacer(),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            const Text(
                                              "Time : ",
                                              style: TextStyle(fontSize: 14),
                                            ),
                                            Text(
                                              "${data['time']}",
                                              style: const TextStyle(fontSize: 14),
                                            ),
                                            const Spacer(),
                                            Text(
                                              "${data['rideStatus'] ?? ' '}",
                                              style: const TextStyle(fontSize: 14,fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ));
  }
}

class HistoryRide extends StatefulWidget {
  final String userUid;

  const HistoryRide({Key? key, required this.userUid}) : super(key: key);

  @override
  State<HistoryRide> createState() => _HistoryRideState();
}

class _HistoryRideState extends State<HistoryRide> {
  final myAllRideS myRide = Get.put(myAllRideS());
  final DateController controller = Get.find<DateController>();

  @override
  void initState() {
    super.initState();
    controller.pickedDate.listen((p0) {
      myRide.filterDataByDate();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.all(15.0),
                child: Text(
                  'Search By Date  --------',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: () {
                  controller.selectDate(context);
                },
                child: const Padding(
                  padding: EdgeInsets.only(right: 15.0),
                  child: Icon(
                    Icons.date_range_sharp,
                    size: 32.0,
                    color: Colors.yellow,
                  ),
                ),
              )
            ],
          ),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: myRide.getMYRideHistoryData(userUid: widget.userUid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No Home Collection'));
                } else {
                  return Obx(() => ColorfulSafeArea(
                      color: Colors.black,
                      child: myRide.rideList.isNotEmpty
                          ? ListView.builder(
                        itemCount: myRide.rideList.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> data =
                          myRide.rideList[index];
                          return InkWell(
                            onTap: () {},
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                margin: const EdgeInsets.only(
                                    top: 10, left: 20, right: 20),
                                decoration: BoxDecoration(
                                  border: Border.all(),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding:
                                        const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Text(
                                              "Patient Name : ",
                                              style: const TextStyle(
                                                  fontSize: 14),
                                            ),
                                            Text(
                                              "${data['patientDetails'][0]['name']}",
                                              style: const TextStyle(
                                                  fontSize: 14),
                                            ),
                                            const Spacer(),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                        const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Text(
                                              "Date : ",
                                              style: const TextStyle(
                                                  fontSize: 14),
                                            ),
                                            Text(
                                              "${data['date']}",
                                              style: const TextStyle(
                                                  fontSize: 14),
                                            ),
                                            const Spacer(),
                                          ],
                                        ),
                                      ),

                                      Padding(
                                        padding:
                                        const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Text(
                                              "Earning : ",
                                              style: const TextStyle(
                                                  fontSize: 14),
                                            ),
                                            Text(
                                              "${data['earning']}",
                                              style: const TextStyle(
                                                  fontSize: 14),
                                            ),
                                            const Spacer(),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                        const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Text(
                                              "Time : ",
                                              style: const TextStyle(
                                                  fontSize: 14),
                                            ),
                                            Text(
                                              "${data['time']}",
                                              style: const TextStyle(
                                                  fontSize: 14),
                                            ),
                                            const Spacer(),
                                            Text(
                                              "${data['rideStatus'] ?? ' '}",
                                              style: const TextStyle(fontSize: 14,fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : const Center(child: Text("No Home Collenction"))));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
