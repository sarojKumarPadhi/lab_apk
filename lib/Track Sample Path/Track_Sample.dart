import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';

class TrackSample extends StatefulWidget {
  const TrackSample({Key? key}) : super(key: key);

  @override
  State<TrackSample> createState() => _TrackSampleState();
}

class _TrackSampleState extends State<TrackSample> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height; //834
    var width = MediaQuery.of(context).size.width; //392
    return ColorfulSafeArea(
      color: Colors.white,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          centerTitle: true,
          leading:  IconButton(

            icon: const Icon(Icons.arrow_back,color: Colors.black,),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
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
                  decoration: BoxDecoration(
                      color: Color(0xFFE9E9E9),
                      borderRadius: BorderRadius.all(Radius.circular(12))
                  ),

                  child: Column(
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Search Sample',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 650,

                child: ListView.builder(
                  itemCount: 1,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(7),
                      child: Container(
                        height: 130,
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(
                                    0, 3), // Offset (horizontal, vertical)
                              ),
                            ],
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(10))
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, top: 10),
                          child: Column(
                            children: [

                              Row(
                                children: [
                                  Icon(Icons.person, size: 25,
                                    color: Colors.grey,),
                                  Text("Patient Name",
                                    style: TextStyle(fontSize: 19),),

                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(2),
                                child: Row(
                                  children: [
                                    Icon(Icons.location_on, size: 20,
                                      color: Colors.grey,),
                                    Text(" Panchkula,Sector22",
                                      style: TextStyle(fontSize: 15),)
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(2),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    Container(
                                      child: Row(children: [
                                        Icon(Icons.directions_bike_rounded, size: 20,
                                          color: Colors.grey,),
                                        Text(" Abhishek kumar",
                                          style: TextStyle(fontSize: 15),)
                                      ]),
                                    ),
                                    Container(
                                      child: Row(children: [

                                        Text("Balance", style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold),)
                                      ]),
                                    ),

                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    right: 5, top: 0, left: 3),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    Container(
                                      child: Row(children: [
                                        Icon(Icons.access_alarm, size: 20,
                                          color: Colors.grey,),
                                        Text(" 01:30",
                                          style: TextStyle(fontSize: 15,color: Colors.red),)
                                      ]),
                                    ),
                                    Container(
                                      child: Row(children: [
                                        Icon(
                                          Icons.currency_rupee_sharp, size: 17,
                                          color: Colors.black,),
                                        Text("2390", style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold),)
                                      ]),
                                    ),

                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }


}
