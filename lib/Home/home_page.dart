import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jonk_lab/New%20Sample%20Path/New_Patient.dart';
import 'package:jonk_lab/Splash%20screen/Splash_Screen.dart';
import 'package:jonk_lab/Track%20Sample%20Path/Track_Sample.dart';
import 'package:jonk_lab/drawer_item/profile/lab_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../drawer_item/payment/Earnings_Screen.dart';
import '../drawer_item/Support.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

LogOut() async{
  final sharepf=await SharedPreferences.getInstance();
  sharepf.setString("status", "false");
  FirebaseAuth.instance.signOut();
  Fluttertoast.showToast(msg: "LogOut");
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SplashScreen(),));
}
  @override
  Widget build(BuildContext context) {
    var height=MediaQuery.of(context).size.height;  //834
    var width=MediaQuery.of(context).size.width;    //392
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/home_page_bg.png'),
              fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(backgroundColor: Colors.grey),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.grey,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      backgroundImage:
                          AssetImage('assets/images/apollo-hospitals-logo.png'),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Lab Name',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                      ),
                    ),
                    Text(
                      'Owner Name(education)',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.person,
                  color: Colors.black,
                ),
                title: Text('Profile'),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) =>  LabProfilePage(),));

                },
              ),
              Divider(),
              ListTile(
                leading: Icon(
                  Icons.payment,
                  color: Colors.black,
                ),
                title: Text('Payments'),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => EarningsScreen(),));
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(
                  Icons.track_changes,
                  color: Colors.black,
                ),
                title: Text('Track Sample'),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => TrackSample(),));
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(
                  Icons.support_agent_outlined,
                  color: Colors.black,
                ),
                title: Text('Support'),
                onTap: () {
                 Navigator.push(context, MaterialPageRoute(builder: (context) => ChatWithSupport(),));
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.logout),
                // You can use a different icon here
                title: Text('Logout'),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Row(
                          children: [
                            Icon(Icons.logout_outlined,color: Colors.red,),
                            Text('Logout',style: TextStyle(color: Colors.red),),
                          ],
                        ),
                        content: Text('Are you sure you want to log out?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('No'),
                          ),
                          TextButton(
                            onPressed: () {
                              LogOut();
                            },
                            child: Text('Yes'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
        body: Stack(
          children: [
            Opacity(
              opacity: 1,
              child: Image.asset(
                'assets/images/img_5.png',
                fit: BoxFit.cover, // Adjust the fit as needed
                width: double.infinity,
                height: double.infinity,
              ),
            ),
               Column(
                 children: [
                   Container(
                       child: Column(
                           mainAxisAlignment: MainAxisAlignment.start,
                           children: [
                             Row(
                               children: [
                                 Padding(
                                   padding: const EdgeInsets.only(left: 20,right: 20,top: 20),
                                   child: Text(
                                     "Hello, Mr. Lab",
                                     style: TextStyle(
                                         color: Colors.black,
                                         fontSize: width*6.3/100,
                                         fontWeight: FontWeight.w600),
                                   ),
                                 ),
                               ],
                             ),
                             Padding(
                               padding: const EdgeInsets.only(left: 20,right: 20,top: 5),
                               child: Row(
                                 children: [
                                   Icon(Icons.location_on),
                                   Text(
                                     " Hisar, Haryana",
                                     style: TextStyle(
                                         color: Colors.black,
                                         fontSize: width*4/100,
                                         fontWeight: FontWeight.w400),
                                   ),
                                 ],
                               ),
                             ),
                           ]),
                     ),

                   Padding(
                  padding: const EdgeInsets.only(top: 50,left: 25),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                       Navigator.push(context, MaterialPageRoute(builder: (context) => NewPatient(),));
                        },
                        child: Container(
                          width: width<450?120:150,
                          height: width<450?120:150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Color(0xFF111111),
                          ),
                          child: Column(
                            children: [
                           Row(mainAxisAlignment: MainAxisAlignment.end,
                             children: [
                               Padding(
                                 padding: const EdgeInsets.only(top: 9,right: 15),
                                 child: Image(image: AssetImage("assets/images/img_3.png")),
                               )

                             ],
                           ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Row(
                                  children: [
                                    Text(
                                      "New \nSample \nPath",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: width<450?18:20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                   Padding(
                     padding: const EdgeInsets.only(top: 20,left: 25),
                     child: Row(
                       children: [
                         InkWell(
                           onTap: () {
                             Navigator.push(context, MaterialPageRoute(builder: (context) => TrackSample(),));
                           },
                           child: Container(

                             width: width<450?120:150,
                             height: width<450?120:150,
                             decoration: BoxDecoration(
                               borderRadius: BorderRadius.circular(15),
                               color: Color(0xFF111111),
                             ),
                             child: Column(
                               children: [
                                 Row(mainAxisAlignment: MainAxisAlignment.end,
                                   children: [
                                     Padding(
                                       padding: const EdgeInsets.only(top: 9,right: 15),
                                       child: Image(image: AssetImage("assets/images/img_4.png")),
                                     )
                                   ],
                                 ),
                                 Padding(
                                   padding: const EdgeInsets.only(left: 8),
                                   child: Row(
                                     children: [
                                       Text(
                                         "Track \nSample \nPath",
                                         style: TextStyle(
                                             color: Colors.white,
                                             fontSize: width<450?18:20,
                                             fontWeight: FontWeight.bold),
                                       ),
                                     ],
                                   ),
                                 )
                               ],
                             ),
                           ),
                         ),
                       ],
                     ),
                   ),
              ],
               )
              ],
            ),

      ),
    );
  }
}
