import 'package:audioplayers/audioplayers.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:jonk_lab/New%20Sample%20Path/address_autofill.dart';
import 'package:jonk_lab/New%20Sample%20Path/all_rider_view.dart';
import 'package:record/record.dart';


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


  Future<void>stopRecording()async{
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
      Source urlSource=UrlSource(audioPath);
      await audioPlayer.play(urlSource);
    }
    catch(e){
      print("playing $e");
    }
  }



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
                        child: TextField(
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
                                  color: Color(0xFFC0C0C0))),
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
                                onPressed:playRecording ,
                                child: Icon(Icons.speaker_phone)
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
                            shadowColor: Colors.black),
                        onPressed:(){
                         Navigator.push(context, MaterialPageRoute(builder: (context) => MapView(),));
                        },
                        child: Text(
                          "ʙᴏᴏᴋ ʀɪᴅᴇʀ",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        )),
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

