import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jonk_lab/Home/home_page.dart';
import 'package:jonk_lab/Phone_auth/mobile_number.dart';
import 'package:jonk_lab/Register_page/register_page.dart';
import 'package:pinput/pinput.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpVarification extends StatefulWidget {
  var number;

   OtpVarification( {Key? key, required this.number}) : super(key: key);

  @override
  State<OtpVarification> createState() => _OtpVarificationState();
}

class _OtpVarificationState extends State<OtpVarification> {
  TextEditingController pinController = TextEditingController();

  var auth=FirebaseAuth.instance.currentUser?.uid;
  Future<void> UserStatus() async {
    print("abcdshgjhsh");
    print("abcdshgjhsh");
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('laboratory')
        .where('Number', isEqualTo: widget.number)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      print("object");
      print("object");
      user();
        Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) =>  HomePage(),
          ));
    }
    else {
      print("object222");
      print("object222");
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => RegisterPage(number:widget.number)));
     }
   }

  late ProgressDialog progressDialog;

  VarificationOtp() async {
    progressDialog = ProgressDialog(context);
    progressDialog.style(
      message: 'Verifying OTP...',
      progressWidget: CircularProgressIndicator(),
    );
    progressDialog.show();

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: MobileNumber.verify,
          smsCode: pinController.text);

      await FirebaseAuth.instance.signInWithCredential(credential);

      progressDialog.hide(); // Hide the progress dialog when verification is complete
      UserStatus();
      Fluttertoast.showToast(msg: "Login successfully");
    } catch (e) {
      progressDialog.hide(); // Hide the progress dialog on error
      Fluttertoast.showToast(msg: "Invalid OTP", textColor: Colors.red);
    }
  }
  user()async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('status', 'true');
    prefs.setString('country', auth!);
  }
  @override
  Widget build(BuildContext context) {
    var height=MediaQuery.of(context).size.height;  //834
    var width=MediaQuery.of(context).size.width;    //392

    return Scaffold(
            body: ColorfulSafeArea(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Center(
                  child: Column(
                    children: [

                    Padding(
                      padding:  EdgeInsets.only(top: height*18/100),
                      child: Text("Enter verification code",style: TextStyle(color: Colors.black,fontSize: width*6/100,fontWeight: FontWeight.bold),),
                    ),
                      Padding(
                        padding:  EdgeInsets.only(top: height*2/100),
                        child: Text("We have send you a 6 digite code on",style: TextStyle(color: Color(0xFF757575),fontSize: width*3.5/100,),),
                      ),
                      Padding(
                        padding:  EdgeInsets.only(top: height*1/100),
                        child: Text("+91${widget.number}",style: TextStyle(color:Color(0xFF505050) ,fontSize: width*3.5/100,fontWeight: FontWeight.bold),),
                      ),
                      SizedBox(
                        height: height*4.8/100,
                      ),
                      Container(
                          child: Pinput(
                            controller: pinController,
                            keyboardType: TextInputType.phone,
                            length: 6,
                            toolbarEnabled: false,
                            showCursor: true,
                            pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                            textInputAction: TextInputAction.next,
                            //  inputFormatters: [Formatter()],
                            defaultPinTheme: PinTheme(
                              height: width*13/100,width: width*13/100,
                                textStyle: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 1, // Adjust the border width as needed
                                  ),)
                              ),
                      ),
                      ),
                      SizedBox(height: height*18/100,),
                      SizedBox(
                        height: height*6.1/100,width: width*88/100,
                        child: ElevatedButton(onPressed: () {
                          VarificationOtp();
                        },
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                backgroundColor: Color(0xFF505050),
                                elevation: 1,
                                shadowColor: Colors.black),
                            child: Text("Login/Sign up",style: TextStyle(color: Colors.white,fontSize: width<450?16:18,fontWeight: FontWeight.bold),)),
                      ),
                    ],
                  ),
                ),
              ),
            )
    );
  }
}
