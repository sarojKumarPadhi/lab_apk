import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:jonk_lab/Phone_auth/mobile_number.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../Register_page/register_page.dart';

class IntroSliderScreen  extends StatefulWidget {
  const IntroSliderScreen({Key? key}) : super(key: key);

  @override
  State<IntroSliderScreen> createState() => _IntroSliderScreenState();
}

class _IntroSliderScreenState extends State<IntroSliderScreen> {
  PageController _controller=PageController();
  bool onLastPage=false;
  @override
  Widget build(BuildContext context) {
    var height=MediaQuery.of(context).size.height;  //834
    var width=MediaQuery.of(context).size.width;    //392
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          actions: [

          ],
        ),
        body: ColorfulSafeArea(
          child: Stack(
            children: [
              PageView(
                controller: _controller,
                onPageChanged: (index) {
                  setState(() {
                    onLastPage= (index==2);
                  });
                },
                children: [
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Card(
                            elevation: 5,
                            shape: CircleBorder(
                              side: BorderSide(
                                  color: Color(0xFFF2F4FF), width: 25),

                            ),
                            child: CircleAvatar(
                              radius: 150,
                              backgroundImage: AssetImage("assets/images/image2358.png",),
                            ),
                          ),
                          SizedBox(height: height*7.2/100,),
                          Container(
                            alignment: Alignment.center, // Center alignment
                            child: Center(
                              child: Text("We Provide Professional \nHome services at a very \nfriendly price",
                                textAlign: TextAlign.center, // Center align the text horizontally
                                style: TextStyle(fontSize: width*6.7/100,fontWeight: FontWeight.bold),),
                            ),
                          )

                        ],
                      ),
                    ),
                  ),

                  Container(

                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Card(
                            elevation: 5,
                            shape: CircleBorder(
                              side: BorderSide(
                                  color: Color(0xFFF2F4FF), width: 25),

                            ),
                            child: CircleAvatar(
                              radius: 150,
                              backgroundImage: AssetImage("assets/images/img.png",),
                            ),
                          ),
                          SizedBox(height: height*7.2/100,),
                          Container(
                            alignment: Alignment.center, // Center alignment
                            child: Center(
                              child: Text("Easy Service booking &\nScheduling",
                                textAlign: TextAlign.center, // Center align the text horizontally
                                style: TextStyle(fontSize: width*6.7/100,fontWeight: FontWeight.bold),),
                            ),
                          )

                        ],
                      ),
                    ),
                  ),

                  Container(

                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Card(
                            elevation: 5,
                            shape: CircleBorder(
                              side: BorderSide(
                                  color: Color(0xFFF2F4FF), width: 25),

                            ),
                            child: CircleAvatar(
                              radius: 150,
                              backgroundImage: AssetImage("assets/images/img_1.png",),
                            ),
                          ),
                          SizedBox(height: height*7.2/100,),

                          Container(
                            alignment: Alignment.center, // Center alignment
                            child: Center(
                              child: Text("We will collect semple \n from your home",
                                textAlign: TextAlign.center, // Center align the text horizontally
                                style: TextStyle(fontSize: width*6.7/100,fontWeight: FontWeight.bold),),
                            ),
                          )

                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                  alignment: Alignment(0, 0.75),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // GestureDetector(
                      //   onTap: () {
                      //    _controller.jumpToPage(2);
                      //   },
                      //   child:Text("Skip"),
                      // ),
                      SmoothPageIndicator(controller: _controller, count: 3,),
                      SizedBox(height: height*3.6/100,),
                      GestureDetector(
                          onTap: () {
                            _controller.nextPage(
                                duration: Duration(milliseconds: 500),
                                curve: Curves.easeIn);
                          },
                          child:  onLastPage?SizedBox(
                            height: height*6/100,width: width*38.3/100,
                            child: ElevatedButton(onPressed: (){
                              Navigator.push(context,MaterialPageRoute(builder: (context) => MobileNumber()));
                            },
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    backgroundColor: Color(0xFF505050),
                                    elevation: 1,
                                    shadowColor: Colors.black),
                                child: Text("Get Started",style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),)
                            ),
                          ):SizedBox(
                            height: height*6/100,width: width*38.3/100,
                            child: ElevatedButton(onPressed: (){
                              _controller.nextPage(
                                  duration:Duration(milliseconds: 500),
                                  curve: Curves.easeIn);
                            },
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    backgroundColor: Color(0xFF505050),
                                    elevation: 1,
                                    shadowColor: Colors.black),
                                child: Text("Next",style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold),)
                            ),
                          )
                      ),
                      SizedBox(height: height*9.6/100,)
                    ],
                  )
              )
            ],
          ),
        )
    );
  }
}