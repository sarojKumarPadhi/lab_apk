import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Home/home_page.dart';
import 'New Sample Path/New_Patient.dart';
import 'New Sample Path/address_autofill.dart';
import 'New Sample Path/all_rider_view.dart';
import 'Phone_auth/mobile_number.dart';
import 'Phone_auth/otp_varificatiion.dart';
import 'Register_page/register_page.dart';
import 'Splash screen/Splash_Screen.dart';
import 'Splash screen/intro_slider_screen.dart';
import 'Track Sample Path/Track_Sample.dart';
import 'drawer_item/payment/Earnings_Screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3:false,
        ),
        home:  HomePage(),
      ))
  );
}

class MyApp extends StatefulWidget {
  final Widget? child;

  MyApp({this.child});

  static void restartApp(BuildContext context) {
  context.findAncestorStateOfType<_MyAppState>()!.restartApp();
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Key key = UniqueKey();
  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      child: widget.child!,
      key: key,
    );
  }
}