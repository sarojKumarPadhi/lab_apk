import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:jonk_lab/New%20Sample%20Path/address_autofill.dart';
import 'package:jonk_lab/New%20Sample%20Path/all_rider_view.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart' as audio;
import '../Services/Push_notifsctio_apicalling.dart';


class NewPatient extends StatefulWidget {
  const NewPatient({Key? key}) : super(key: key);
  static String location = "";

  @override
  State<NewPatient> createState() => _NewPatientState();
}

class _NewPatientState extends State<NewPatient> {
  String audioPath="";
  late Record audioRecord;
  late AudioPlayer audioPlayer;
  bool isRecording=false;
  @override
  void initState(){
    audioPlayer=AudioPlayer();
    audioRecord=Record();
    super.initState();
  }

  @override
  void dispose() {
    audioRecord.dispose();
    audioPlayer.dispose();
    super.dispose();
  }
  Future<void>startRecording() async{
    try{
      if(await audioRecord.hasPermission()){
        await audioRecord.start();
        setState(() {
          isRecording=true;
        });
      }
    }
    catch(e){
      print(e);
    }
  }


  Future<void>stopRecording() async{
    try{
      String? path=await audioRecord.stop();
      setState(() {
        isRecording=false;
        audioPath=path!;
      });
     // await uploadAudioToFirebaseStorage();
    }
    catch(e){
      print(e);
    }
  }

  Future<void>playRecording()async{
    try{
      audio.Source urlSource=UrlSource(audioPath);
      await audioPlayer.play(urlSource);
    }
    catch(e){
      print("playing $e");
    }
  }




  @override
  Widget build(BuildContext context){
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
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            "𝐍𝐞𝐰 𝐒𝐚𝐦𝐩𝐥𝐞",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
          child: ListView(
            children: [
              Container(
                height: height * 11 / 100,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10, bottom: 5),
                          child: Text(
                            "Patient Name",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: width * 3.9 / 100),
                          ),
                        )
                      ],
                    ),
                    Container(
                      height: height * 6 / 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Color(0xFFE7E3E3),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: TextField(
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Name",
                              hintStyle: TextStyle(
                                  fontSize: width * 3.9 / 100,
                                  color: Color(0xFFC0C0C0))),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: height * 10 / 100,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10, bottom: 5),
                          child: Text(
                            "Mobile Number*",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: width * 3.9 / 100),
                          ),
                        )
                      ],
                    ),
                    Container(
                      height: height * 6 / 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Color(0xFFE7E3E3),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: TextField (

                          cursorColor: Colors.black,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "+91",
                              hintStyle: TextStyle(
                                  fontSize: width * 3.9 / 100,
                                  color: Color(0xFFC0C0C0))),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: height * 10 / 100,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10, bottom: 5),
                          child: Text(
                            "Age*",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: width * 3.9 / 100),
                          ),
                        )
                      ],
                    ),
                    Container(
                      height: height * 6 / 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Color(0xFFE7E3E3),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: TextField(
                          cursorColor: Colors.black,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Patient age",
                              hintStyle: TextStyle(
                              fontSize: width * 3.9 / 100,
                              color: Color(0xFFC0C0C0))
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              // ... Repeat similar container structures for the other form fields

              Container(
                height: height * 11 / 100,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10, bottom: 5),
                          child: Text(
                            "Test*",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: width * 3.9 / 100),
                          ),
                        )
                      ],
                    ),

                    Container(
                      height: height * 7 / 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Color(0xFFE7E3E3),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: TextField(
                          cursorColor: Colors.black,
                          maxLines: 2,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "EX-CBC,lipid profile,",
                              hintStyle: TextStyle(
                                  fontSize: width * 3.9 / 100,
                                  color: Color(0xFFC0C0C0))),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: height * 11 / 100,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10, bottom: 5),
                          child: Text(
                            "Sample*",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: width * 3.9 / 100),
                          ),
                        )
                      ],
                    ),
                    Container(
                      height: height * 7 / 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Color(0xFFE7E3E3),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: TextField(
                          cursorColor: Colors.black,
                          maxLines: 2,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Blood-5ml,urine-10ml,",
                              hintStyle: TextStyle(
                                  fontSize: width * 3.9 / 100,
                                  color: Color(0xFFC0C0C0))),
                        ),
                      ),
                    )
                  ],

                ),
              ),
              Container(
                height: height * 11 / 100,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10, bottom: 5),
                          child: Text(
                            "patient location*",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: width * 3.9 / 100),
                          ),
                        )
                      ],
                    ),
                    Container(
                      height: height * 7 / 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Color(0xFFE7E3E3),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: TextField(
                          onTap:() {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => AddressAutofill(),));
                          },
                          readOnly: true,
                          cursorColor: Colors.black,
                          maxLines: 3,
                          decoration:  NewPatient.location.isEmpty?
                          InputDecoration(
                              border: InputBorder.none,
                              hintText: "Address",
                              hintStyle: TextStyle(
                                  fontSize: width * 3.9 / 100,
                                  color: Color(0xFFC0C0C0))):
                          InputDecoration(
                              border: InputBorder.none,
                              hintText: NewPatient.location,
                              hintStyle: TextStyle(
                                  fontSize: width * 3.9 / 100,
                                  color: Colors.black))
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: height * 11 / 100,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10, bottom: 5),
                          child: Text(
                            "Voice Description",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: width * 3.9 / 100),
                          ),
                        )
                      ],
                    ),

                    Container(
                      height: height * 7 / 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Color(0xFFE7E3E3),
                      ),
                      child:Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          if(isRecording)
                            Text("Recording..."),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.grey, // Set the background color
                              ),
                              onPressed:
                          isRecording? stopRecording:startRecording,
                              child: isRecording?Icon(Icons.stop):Icon(Icons.mic)
                          ),
                          SizedBox(width: 5,),
                          if(!isRecording && audioPath!=null)
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.grey, // Set the background color
                                ),
                                onPressed:playRecording,
                                child:Icon(Icons.speaker_phone)
                            )
                        ],
                      ),
                    )
                  ],
                ),
              ),

              SizedBox(
                height: 30,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Container(
                    height: 50,
                    width: 200,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: Color(0xFF111111),
                            elevation: 10,
                            shadowColor: Colors.black
                        ),
                        onPressed:() async {
                         List<String> dataList = ["dACjQ0PhQmigI91FrhU5aI:APA91bEh57mIgrnr6mDTylBimvBvRnD-6YPVBRu38YCAph51b4N8HsuS94QK3KFnx2Od0vcKLV_j0_35pVFEPlu5aIW51ls87qPULtG7qm1SP8JHSEYIQBYvhus00Glal1tBgc2g1UbX"];
                         //  var user = await FirebaseFirestore.instance.collection("users").get();
                         // var fcmTokens = user.docs.map((docValue) => UserModel.fromJson(docValue.data())).toList();
                         //  for (var element in fcmTokens) {
                         //    dataList.add(element.fcmToken);
                         //  }

                          PushNotification().sendNotification(
                              "New patient ", "hey Amit where are you", "", dataList);
                         Navigator.push(context, MaterialPageRoute(builder: (context) => MapView(patientLocation:NewPatient.location),));
                        },
                        child: Text(
                          "ʙᴏᴏᴋ ʀɪᴅᴇʀ",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        )
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

//AAAAa7EVXgo:APA91bHqWt8YtjjEdktLMKf33oI0jWRebAERJIeuDeIUtmwzpZLEjs_TFTDglQF0x2_YV8ja-bDQpN0NcH1RTrf-LKSCUX0Zmxbf3Ufnkrw6FyHo_segLClJsQ0sU98Kf3cElnegg4B1