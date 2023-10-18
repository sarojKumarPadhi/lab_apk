import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jonk_lab/Phone_auth/otp_varificatiion.dart';

class MobileNumber extends StatefulWidget {
  const MobileNumber({Key? key}) : super(key: key);
  static String verify = "";

  @override
  State<MobileNumber> createState() => _MobileNumberState();
}

class _MobileNumberState extends State<MobileNumber> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController numberController = TextEditingController();

  sendOtp() async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+91${numberController.text}',
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {},
        codeSent: (String verificationId, int? resendToken) {
          MobileNumber.verify=verificationId;
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OtpVarification(number:numberController.text),));
          Fluttertoast.showToast(msg: "Sent OTP");
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    }
    catch(e){
      Fluttertoast.showToast(msg:"OTP Failed");
    }
  }


  @override
  Widget build(BuildContext context) {
    var height=MediaQuery.of(context).size.height;  //834
    var width=MediaQuery.of(context).size.width;    //392
    return Scaffold(
      backgroundColor: Colors.white,
      body: ColorfulSafeArea(color: Colors.white,
          child:Padding(
            padding: const EdgeInsets.only(top: 20,left: 20,right: 20,bottom: 10),
            child: ListView(
              children: [
                Container(
                  width: width*71.5/100,
                  height: width*71.5/100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                      color: Color(0xFFDCDEE8)
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  Image.asset("assets/images/jonk.png",height: height*11.5/100,width: width*59/100,),
                      Text("Lab Services",style: TextStyle(color: Colors.black,fontSize: width*9/100,fontWeight: FontWeight.bold),)
                    ],
                  ),
                ),
                SizedBox(height: height*8/100,),
                Form(
                  key: _formKey,
                  child: TextFormField(
                    maxLength: 10,
                    controller: numberController,
                      keyboardType: TextInputType.number,
                    cursorColor: Colors.black,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.phone_android_outlined,color: Colors.black,),

                        border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                          ),
                          hintText:"Mobile Number",
                        focusedBorder: OutlineInputBorder(
                           borderSide: BorderSide(color: Colors.black,width: 1), // Set the border color when focused
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter Number';
                      }
                      else if(value.length<=9){
                        return 'Invalid Number';
                      }
                      return null;
                    },
                    ),
                ),
                SizedBox(height: height*2.5/100,),
                Row(
                  children: [
                    Text("An OTP will be sent on given phone number for verificatio .\nStandard message and data rates apply.",style: TextStyle(fontSize: width*3.4/100),)
                  ],
                ),
                SizedBox(height: height*6/100,),
                SizedBox(
                  height: height*6.1/100,width: width*88/100,
                  child: ElevatedButton(onPressed: () {
                    if (_formKey.currentState!.validate()) {
                              sendOtp();
                    }
                  },

                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: Color(0xFF505050),
                          elevation: 1,
                          shadowColor: Colors.black),
                      child: Text("Login/Sign up",style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),)),
                ),


              ],
            ),
          )
      ),
    );
  }
}
