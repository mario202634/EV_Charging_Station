import 'package:ev_charging_station_finder_1_0/home_screen.dart';
import 'package:ev_charging_station_finder_1_0/login_screen.dart';
import 'package:ev_charging_station_finder_1_0/signup_screen.dart';
import 'package:ev_charging_station_finder_1_0/profile_screen.dart';
import 'package:ev_charging_station_finder_1_0/map_screen.dart';
import 'package:ev_charging_station_finder_1_0/login_check.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter/material.dart';


Future main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  initializeDateFormatting().then((value) => runApp(MyApp()));
  //runApp(MyApp());
}

class MyApp extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginCheck(),
      //home: ProfileScreen(),
      theme: ThemeData(
        primarySwatch: Colors.purple,
        // scaffoldBackgroundColor: Color(0xffD6E2EA), //<-- SEE HERE
        scaffoldBackgroundColor: HexColor("#f2f0f2"),
    ),
    );
  }
}
