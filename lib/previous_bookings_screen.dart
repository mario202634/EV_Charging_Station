import 'package:ev_charging_station_finder_1_0/booking_test_screen.dart';
import 'package:ev_charging_station_finder_1_0/charger_screen.dart';
import 'package:ev_charging_station_finder_1_0/model/stations_model.dart';
import 'package:ev_charging_station_finder_1_0/side_bar.dart';
import 'package:ev_charging_station_finder_1_0/station_screen.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class PreviousBookingsScreen extends StatefulWidget {
  const PreviousBookingsScreen({Key? key}) : super(key: key);

  @override
  State<PreviousBookingsScreen> createState() => _PreviousBookingsScreenState();
}

class _PreviousBookingsScreenState extends State<PreviousBookingsScreen> {

  CollectionReference notesRef = FirebaseFirestore.instance.collection("reservations");

  @override
  void initState() {
    // TODO: implement initState
    getStationName(getChargerId());
    setState(() {

    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        //          stream: notesRef.snapshots(),
        //          stream: notesRef.where('stationId', isEqualTo: data['stationId']).snapshots(),
          stream: notesRef
              .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
              .where('status', isEqualTo: "Done")
              .snapshots(),
          builder: (context, snapshot) {
            if(snapshot.data?.docs.length == 0)
            {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    image: AssetImage('assets/images/NotFound.png'),
                    width: 250, // Set the desired width
                    height: 250, // Set the desired height
                  ),
                  SizedBox(height: 20,),
                  Center(
                    child: Text(
                      'No Past Reservations found',
                      style: TextStyle(
                        fontSize: 14,
                        //fontWeight: FontWeight.bold
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
                  // //return Text("${snapshot.data?.docs[index]['stationId']}");
                  // getChargerFromFirebase(snapshot.data?.docs[index]['chargerId']);
                  //getChargerFromFirebase(snapshot.data?.docs[index].id as String);
                  //getStationName(snapshot.data?.docs[index]['chargerId']);
                  print(snapshot.data?.docs[index]['chargerId']);
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
                              child: Text(
                                'Completed',
                                style: TextStyle(
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.location_on),
                                  //Text("Location " + getStationName(snapshot.data?.docs[index]['chargerId']).toString()),
                                  //Text("Location: " + stationName.toString()),
                                  FutureBuilder<String>(
                                    future: getStationName(snapshot.data?.docs[index]['chargerId']),
                                    builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return Text('Loading...');
                                      }
                                        print('Location: ${snapshot.data}');
                                        return Text('Location: ${snapshot.data}');
                                      return Text('Location: N/A');
                                    },
                                  ),
                                ],
                              ),
                            ),

                            Container(
                              width: double.infinity,
                              child: Column(
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
                                                Icon(Icons.timelapse_rounded),
                                                Text('Duration: ' + "${snapshot.data?.docs[index]['serviceDuration']}" + " minutes"),
                                              ],
                                            ),
                                            SizedBox(height: 15.0),
                                            Row(
                                              children: [
                                                Icon(Icons.monetization_on_rounded),
                                                SizedBox(width: 3.0),
                                                Text('Cost: ' + (snapshot.data?.docs[index]['servicePrice'] * (snapshot.data?.docs[index]['serviceDuration'] / 60)).toString() + " EGP"),
                                              ],
                                            ),
                                            // SizedBox(height: 15.0),
                                            //
                                            // Row(
                                            //   children: [
                                            //     Icon(Icons.power),
                                            //     Text('Power Used: '),
                                            //   ],
                                            // ),
                                            SizedBox(height: 15.0),
                                            Row(
                                              children: [
                                                Icon(Icons.calendar_today_rounded),
                                                SizedBox(width: 3.0),
                                                Text('Start Date: ' + "${snapshot.data?.docs[index]['bookingStart']}".substring(0, 10)),
                                              ],
                                            ),
                                            SizedBox(height: 15.0),
                                            Row(
                                              children: [
                                                Icon(Icons.calendar_today_rounded),
                                                SizedBox(width: 3.0),
                                                Text('End Date: ' + "${snapshot.data?.docs[index]['bookingEnd']}".substring(0, 10)),
                                              ],
                                            ),
                                            SizedBox(height: 15.0),
                                            Row(
                                              children: [
                                                Icon(Icons.access_time_rounded),
                                                SizedBox(width: 3.0),
                                                Text('Start Time: ' + "${snapshot.data?.docs[index]['bookingStart']}".substring(11, 16)),
                                              ],
                                            ),
                                            SizedBox(height: 15.0),
                                            Row(
                                              children: [
                                                Icon(Icons.access_time_rounded),
                                                SizedBox(width: 3.0),
                                                Text('End Time: ' + "${snapshot.data?.docs[index]['bookingEnd']}".substring(11, 16)),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),


                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // TextButton(
                                //   onPressed: () {},
                                //   child: Text('Button 1'),
                                // ),
                                ElevatedButton(
                                  onPressed: () {
                                    goToStation(snapshot.data?.docs[index]['stationId']);
                                  },
                                  child: Text('View Station'),
                                ),
                                SizedBox(width: 8.0),
                                SizedBox(width: 8.0),
                                // ElevatedButton(
                                //   onPressed: () {
                                //     //getStationName(snapshot.data?.docs[index]['chargerId']);
                                //     goToBookAgain(snapshot.data?.docs[index]['stationId'], snapshot.data?.docs[index]['chargerId']);
                                //   },
                                //   child: Text('Book Again'),
                                //   style: ButtonStyle(
                                //     backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                                //   ),
                                // ),
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

  Future<DocumentSnapshot<Map<String, dynamic>>> getChargerFromFirebase(String documentId) async {
    final collectionRef = FirebaseFirestore.instance.collection('chargers');
    final documentRef = collectionRef.doc(documentId);
    print("aloo");
    return documentRef.get().then((snapshot) {
      if (snapshot.exists) {
        print("Document Id bellow");
        print(documentId);
        print(snapshot.toString());
        return snapshot;
      } else {
        throw Exception('Document does not exist!');
      }
    });
  }

  fetchChargerData(documentId) async {
      final doc = await FirebaseFirestore.instance.collection('chargers')
      .doc(documentId)
      .get();
      return doc;
  }

  fetchStationData(dynamic charger) async {
    final doc = await FirebaseFirestore.instance.collection('stations')
        .where('field', isEqualTo: "ai7aga")
        .get();
    return doc;
  }

  dynamic stationName;
  dynamic chargerName;

  // getChargerName(chargerId) {
  //   FirebaseFirestore.instance
  //       .collection('chargers')
  //       .doc(chargerId)
  //       .get()
  //       .then((doc) {
  //     setState(() {
  //       chargerName = doc.data()['name'];
  //     });
  //   });
  //   return chargerName;
  // }

  getCharger(cid) async {
    CollectionReference cref = FirebaseFirestore.instance.collection("chargers");
    dynamic snapshot = await cref.doc(cid).get();
    return snapshot;
  }

  getChargerId() async {
    dynamic snapshot = await notesRef.doc().get();
    final String chargerId = snapshot.data()!['chargerId'];
    return chargerId;
  }

  dynamic sname;
  getStationData(cid) {
    print("CID IS HERE");
    print(cid);
    String x = cid;
    print(x);
    FirebaseFirestore.instance.collection("chargers")
        .doc(cid)
        .get()
        .then((docs) {
      if (docs.data() != null) {
        print("Document exists");
        print(docs.data().toString());
        print(docs.data()!['stationId']);
        sname = docs.data();
        print("Sname: " + sname.toString());
        return docs.data();
      }
      if (docs.data() == null) {
        print("Document does not exists");
        print(docs.data().toString());
        return docs;
      }

    });
  }

  Future<String> getStationName(chargerId) async {

    final CollectionReference collectionRef = await FirebaseFirestore.instance.collection('chargers');
    dynamic snapshot = await collectionRef.doc(chargerId).get();
    final String stationId = snapshot.data()!['stationId'];
    await FirebaseFirestore.instance.collection('stations')
        .where('stationId', isEqualTo: stationId)
        .get()
        .then((docs) {
          print("Documents");
          print(docs.toString());
          if(docs.docs.isNotEmpty)
            {
              // setState(() {
                 stationName = docs.docs[0].data()['name'];
              //   print("Station: ");
              //   print(stationName.toString());
              // });

            }
          //stationName = docs.docs[0].data()['name'];
      }
    );
    print("Dih el station: " + stationName);
    return stationName;

    // return station;
  }

  goToStation(String sid) {
    FirebaseFirestore.instance.collection('stations')
        .where('stationId', isEqualTo: sid)
        .get()
        .then((docs) {
      if (docs.docs.isNotEmpty) {
        print("Documents exist");
        for (int i = 0; i < docs.docs.length; i++) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StationScreen(data: docs.docs[i].data()),
            ),
          );
        }
      }
    });
  }

  getStation(String sid) {
    FirebaseFirestore.instance.collection('stations')
        .where('stationId', isEqualTo: sid)
        .get();
  }

  getChargerData(String cid) {
    FirebaseFirestore.instance.collection('chargers')
        .doc(cid)
        .get();
  }

  goToBookAgain(String sid, String cid) {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => BookingScreen(getStation(sid), getChargerData(cid), cid),),
    // );
  }

  List<StationModel> appointments = [];

  void getAllStations() {
    appointments = [];
    FirebaseFirestore.instance
        .collection('stations')
        .get()
        .then((value) {
        value.docs.forEach((element) {
        appointments.add(StationModel.fromJson(element.data()));
      });
    });
  }

}
