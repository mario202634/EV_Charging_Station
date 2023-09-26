import 'package:ev_charging_station_finder_1_0/pending_bookings_screen.dart';
import 'package:ev_charging_station_finder_1_0/previous_bookings_screen.dart';
import 'package:ev_charging_station_finder_1_0/side_bar.dart';
import 'package:flutter/material.dart';
import 'package:ev_charging_station_finder_1_0/ongoing_booking_card.dart';
import 'package:hexcolor/hexcolor.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({Key? key}) : super(key: key);

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  int _selectedButtonIndex = 0;

  void _onButtonPressed(int buttonIndex) {
    setState(() {
      _selectedButtonIndex = buttonIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBar(
            title: Text("My Bookings"),
            centerTitle: true,
          ),
          drawer: SideBar(),
          body: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                Container(
                  height: 45,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(25.0)
                  ),
                  child:  TabBar(
                    indicator: BoxDecoration(
                        //color: Colors.green[300],
                        //color: Colors.purple,
                        color: HexColor("#3f1651"),
                      borderRadius:  BorderRadius.circular(25.0)
                    ) ,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.black,
                    tabs: const  [
                      Tab(text: 'Ongoing',),
                      Tab(text: 'Pending',),
                      Tab(text: 'Previous',),
                    ],
                  ),
                ),
                const Expanded(
                    child: TabBarView(
                      children:  [
                        Center(child:
                        //Text("Ongoing"),
                        Ongoing_Booking_Card(),
                        ),
                        Center(child:
                        //Text("Ongoing"),
                        PendingBookingScreen(),
                        ),
                        Center(child:
                        //Text("Previous"),
                        PreviousBookingsScreen(),
                        ),
                      ],
                    )
                )
              ],
            ),
          )
      ),
    );
  }
}
