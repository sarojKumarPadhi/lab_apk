import 'dart:async';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:jonk_lab/Home/home_page.dart';
import 'package:jonk_lab/Splash%20screen/intro_slider_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  String? status = "";

  @override
  void initState() {
    super.initState();
    getdata();
    Timer(
        Duration(seconds: 3),
            () => {
          if (status == "true")
            {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => HomePage()))
            }
          else
            {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => IntroSliderScreen())),
            }
        });
  }

  Future getdata() async {
    var shareprf = await SharedPreferences.getInstance();
    setState(() {
      status = shareprf.getString('status');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:ColorfulSafeArea(
          color: Colors.white,
          child:  Center(
            child: Image(image: AssetImage("assets/images/jonk.png"),width: 200),
          ),
      )
    );
  }
}

