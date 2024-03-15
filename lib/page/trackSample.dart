import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jonk_lab/global/color.dart';
import 'package:jonk_lab/global/globalData.dart';
import 'package:jonk_lab/page/after_ride_accept_by_rider.dart';

import '../controller/track_sample_controller.dart';

class TrackSample extends StatefulWidget {
  const TrackSample({Key? key}) : super(key: key);

  @override
  State<TrackSample> createState() => _TrackSampleState();
}

class _TrackSampleState extends State<TrackSample> {

  trackSample trackSampleData=Get.put(trackSample());
  @override
  Widget build(BuildContext context) {

    var height = MediaQuery.of(context).size.height; //834
    var width = MediaQuery.of(context).size.width; //392
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0.0,
        centerTitle: true,
        leading:  IconButton(

          icon: const Icon(Icons.arrow_back,color: Colors.black,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "𝗧𝗿𝗮𝗰𝗸 𝘀𝗮𝗺𝗽𝗹𝗲", style: TextStyle(color: Colors.black),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 5, right: 5, top: 5, bottom: 10),
              child: Container(
                decoration: const BoxDecoration(
                    color: Color(0xFFE9E9E9),
                    borderRadius: BorderRadius.all(Radius.circular(12))
                ),

                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Search Sample',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
           Obx(() =>  SizedBox(
             height: 650,
             child: ListView.builder(
               itemCount: trackSampleData.listOfSample.length,
               itemBuilder: (BuildContext context, int index) {
                 Map<dynamic,dynamic> data=  trackSampleData.listOfSample[index] as Map<dynamic,dynamic>;

                 return Padding(
                   padding: const EdgeInsets.all(7),
                   child: InkWell(
                     onTap: () {
                       Get.to(AfterAcceptanceRidePage(requestId: data["requestId"], labUid: auth.toString()));
                     },
                     child: Container(
                       decoration: BoxDecoration(
                           boxShadow: [
                             BoxShadow(
                               color: Colors.black.withOpacity(0.1),
                               spreadRadius: 5,
                               blurRadius: 7,
                               offset: const Offset(
                                   0, 3), // Offset (horizontal, vertical)
                             ),
                           ],
                           color: Colors.white,
                           borderRadius: const BorderRadius.all(Radius.circular(10))
                       ),
                       child:  Padding(
                         padding: EdgeInsets.only(
                             left: 10, right: 10, top: 10),
                         child: Column(
                           children: [

                             Row(
                               children: [
                                 Icon(Icons.person, size: 25,
                                   color: Colors.grey,),
                                 Text(data["patientDetails"]["name"],
                                   style: TextStyle(fontSize: 19),),

                               ],
                             ),
                             Padding(
                               padding: EdgeInsets.all(2),
                               child: Row(
                                 children: [
                                   Icon(Icons.location_on, size: 20,
                                     color: Colors.grey,),
                                   Expanded(
                                     child: Text(data["patientDetails"]["location"],
                                       style: TextStyle(fontSize: 15),),
                                   )
                                 ],
                               ),
                             ),
                             Padding(
                               padding: EdgeInsets.all(2),
                               child: Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 children: [
                                   Row(children: [
                                     Icon(Icons.directions_bike_rounded, size: 20,
                                       color: Colors.grey,),
                                     Text(data["riderDetails"]["riderName"],
                                       style: TextStyle(fontSize: 15),)
                                   ]),
                                   Row(children: [

                                     Text("Balance", style: TextStyle(
                                         fontSize: 17,
                                         fontWeight: FontWeight.bold),)
                                   ]),

                                 ],
                               ),
                             ),
                             Padding(
                               padding: EdgeInsets.only(
                                   right: 5, top: 0, left: 3),
                               child: Row(
                                 mainAxisAlignment: MainAxisAlignment
                                     .spaceBetween,
                                 children: [
                                   Row(children: [
                                     Icon(Icons.access_alarm, size: 20,
                                       color: Colors.grey,),
                                     Text(" 01:30",
                                       style: TextStyle(fontSize: 15,color: Colors.red),)
                                   ]),
                                   Row(children: [
                                     Icon(
                                       Icons.currency_rupee_sharp, size: 17,
                                       color: Colors.black,),
                                     Text(data["patientDetails"]["labPrice"], style: TextStyle(
                                         fontSize: 17,
                                         fontWeight: FontWeight.bold),)
                                   ]),

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

             ),
           )
           )
          ],
        ),
      ),
    );
  }


}
