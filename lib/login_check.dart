//import 'package:ev_charging_station_finder_1_0/model/users_model.dart';
import 'package:ev_charging_station_finder_1_0/login_screen.dart';
import 'package:ev_charging_station_finder_1_0/map_screen.dart';
import 'package:ev_charging_station_finder_1_0/profile_screen.dart';
import 'package:ev_charging_station_finder_1_0/testing_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ev_charging_station_finder_1_0/booking_test_screen.dart';

import 'map2_test_screen.dart';
import 'map_test_screen.dart';

class LoginCheck extends StatelessWidget {
  const LoginCheck({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot)
        {
          if(snapshot.hasData)
          {
            //return MapTestScreen();
            //return MapTestScreen();
            return TestingScreen();
            //return BookingScreen();
          }
          else
          {
            return LoginScreen();
          }
        },
      ),
    );
  }
}

