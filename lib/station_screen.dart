import 'package:ev_charging_station_finder_1_0/booking_test_screen.dart';
import 'package:ev_charging_station_finder_1_0/charger_screen.dart';
import 'package:ev_charging_station_finder_1_0/side_bar.dart';
import 'package:ev_charging_station_finder_1_0/station_screen.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StationScreen extends StatefulWidget {
  final dynamic data;
  const StationScreen({this.data});

  @override
  _StationScreenState createState() => _StationScreenState(data: data);
}

class _StationScreenState extends State<StationScreen> {
  final dynamic data;
  _StationScreenState({this.data});


  @override
  void initState() {
    // TODO: implement initState
    getChargers();
    super.initState();
  }

  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('chargers')
      // .where('stationId', isEqualTo: data['stationId'])
      .snapshots();

  CollectionReference notesRef = FirebaseFirestore.instance.collection("chargers");
  //CollectionReference notesRef = FirebaseFirestore.instance.collection("chargers").where("status", isEqualTo: "active");


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
        Text("Chargers"),
        centerTitle: true,
      ),

      body: StreamBuilder(
        //          stream: notesRef.snapshots(),
        //          stream: notesRef.where('stationId', isEqualTo: data['stationId']).snapshots(),
          stream: notesRef
              .where('stationId', isEqualTo: data['stationId'])
              // .where('active', isEqualTo: false)
              .snapshots(),
          builder: (context, snapshot) {
            if(snapshot.data?.docs.length == 0)
            {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    image: AssetImage('assets/images/NoCharger.png'),
                    width: 250, // Set the desired width
                    height: 250, // Set the desired height
                  ),
                  SizedBox(height: 20,),
                  Center(
                    child: Text(
                      'No Chargers found for this Station :(',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ],
              );
            }
            if (snapshot.hasError) {
              return Text("Error");
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              // return Text("loding ....");
              return CircularProgressIndicator();
            }
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  //return Text("${snapshot.data?.docs[index]['stationId']}");
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                        //Text("${snapshot.data?.docs[index]['type']}")

                        child: Text("Charger Type: " + "${snapshot.data?.docs[index]['type']}",
                                style: TextStyle(
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            Container(
                              width: double.infinity,
                              child: Row(
                                children: [
                                  Padding(
                                    //padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(Icons.power),
                                                Text("Power Output: " + "${snapshot.data?.docs[index]['power']}" + "kW"),
                                              ],
                                            ),
                                            SizedBox(height: 15.0),
                                            Row(
                                              children: [
                                                Icon(Icons.monetization_on_rounded),
                                                SizedBox(width: 3.0),
                                                Text("Price: " + "${snapshot.data?.docs[index]['price']}EGP" +" kW/h"),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 80.0,
                                  ),

                                ],
                              ),
                            ),


                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    if (snapshot.data?.docs[index] != null) {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('Select Charge Duration'),
                                            content: StatefulBuilder(
                                              builder: (BuildContext context, StateSetter setState) {
                                                return Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    DropdownButton<int>(
                                                      value: selectedDuration,
                                                      onChanged: (int? newValue) {
                                                        setState(() {
                                                          selectedDuration = newValue!;
                                                        });
                                                      },
                                                      items: [
                                                        DropdownMenuItem<int>(
                                                          value: 30,
                                                          child: Text('30 minutes'),
                                                        ),
                                                        DropdownMenuItem<int>(
                                                          value: 60,
                                                          child: Text('60 minutes'),
                                                        ),
                                                        DropdownMenuItem<int>(
                                                          value: 90,
                                                          child: Text('90 minutes'),
                                                        ),
                                                        DropdownMenuItem<int>(
                                                          value: 120,
                                                          child: Text('120 minutes'),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                );
                                              },
                                            ),
                                            actions: [
                                              ElevatedButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop(); // Close the dialog
                                                  goBook(data, snapshot.data!.docs[index].data(), snapshot.data!.docs[index].reference.id, selectedDuration);
                                                },
                                                child: Text('Next'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    }
                                    print("Available");
                                  },
                                  child: Text('Book Now'),
                                ),
                                // SizedBox(width: 8.0),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
            return Text("loding");
          }),
    );
  }

  int selectedDuration = 30; // Default duration value

  void getChargers() {
    print("StationId");
    print(data['stationId']);
    FirebaseFirestore.instance.collection('chargers')
        .where('stationId', isEqualTo: data['stationId'])
        // .where('active', isEqualTo: false)
        .get().then((value) {

      if (value.docs.isNotEmpty) {
        print("Chargers: \n");
        for (int i = 0; i < value.docs.length; i++) {
          print("Charger: " + (i + 1).toString());
          initMarker(value.docs[i].data());

        }
      }
      //String fname = value.docs.first.get('type');
      //bool lname = value.docs.first.get('active');
      //fullName = '$fname $lname';
    });
  }

  void initMarker(data) async {
    //buildTextField(data['type']);
    print("Charger Type: " + data['type'].toString());
    print("Active Status: " + data['active'].toString());

  }

  // Widget buildTextField(String type) {
  //   return TextField(
  //     decoration: InputDecoration(
  //       labelText: type,
  //     ),
  //   );

void goBook(station, charger, cdocid, int time)
{
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => BookingScreen(station, charger, cdocid, time),
    ),
  );
}

}
