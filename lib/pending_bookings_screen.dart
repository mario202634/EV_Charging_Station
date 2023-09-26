import 'package:ev_charging_station_finder_1_0/activate_screen.dart';
import 'package:ev_charging_station_finder_1_0/station_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class PendingBookingScreen extends StatefulWidget {
  const PendingBookingScreen({Key? key}) : super(key: key);

  @override
  State<PendingBookingScreen> createState() => _PendingBookingScreenState();
}

class _PendingBookingScreenState extends State<PendingBookingScreen> {
  CollectionReference notesRef = FirebaseFirestore.instance.collection("reservations");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        //          stream: notesRef.snapshots(),
        //          stream: notesRef.where('stationId', isEqualTo: data['stationId']).snapshots(),
          stream: notesRef
              .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
              //.where('status', whereIn: ["Reserved"])
              .where('status', isEqualTo: "Reserved")
          //.where('status', isEqualTo: "Active")
              .snapshots(),
          builder: (context, snapshot) {
            if(snapshot.data?.docs.length == 0)
            {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    image: AssetImage('assets/images/Search2.png'),
                    width: 250, // Set the desired width
                    height: 250, // Set the desired height
                  ),
                  SizedBox(height: 20,),
                  Center(
                    child: Text(
                      'No Pending Reservations found',
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
                  //return Text("${snapshot.data?.docs[index]['stationId']}");
                  getChargerData(snapshot.data?.docs[index]['chargerId'].toString());
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
                                "${snapshot.data?.docs[index]['status'] == "Active" ? 'Active' : 'Pending'}",
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
                                                Icon(Icons.bolt),
                                                Text('Charger ID: ' + "${snapshot.data?.docs[index]['chargerId']}"),
                                              ],
                                            ),
                                            SizedBox(height: 15.0),
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


                      Column(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              goToStation(snapshot.data?.docs[index]['stationId']);
                            },
                            child: Text('View Station'),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  bool isPaid = snapshot.data?.docs[index]['paid'] ?? false;
                                  if (isPaid) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ActivateScreen(data: sname!, id: chargrid),
                                      ),
                                    );
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Cannot Activate Charger'),
                                          content: Text('Remaining Funds'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('OK'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                },
                                child: Text('Activate Charge'),
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                                ),
                              ),
                              SizedBox(width: 8.0),
                              ElevatedButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text('Delete Booking'),
                                      content: Text('Are you sure you want to delete this Booking?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: Text('Cancel'),
                                        ),
                                        TextButton(
                                          child: Text('Delete'),
                                          onPressed: () {
                                            Navigator.pop(context);
                                            deleteBooking(snapshot.data!.docs[index].id);
                                            deleteReservation(snapshot.data!.docs[index].id);
                                            setState(() {});
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                child: Text('Cancel Charge'),
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                                ),
                              ),

                            ],
                          ),
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
            if(snapshot.data?.docs.length == 0)
            {
              return Text("Hello World");
            }
            return Text("Loading");
          }),

    );
  }

  getCharger(cid) async {
    CollectionReference cref = FirebaseFirestore.instance.collection("chargers");
    dynamic snapshot = await cref.doc(cid).get();
    return snapshot;
  }

  dynamic sname;
  dynamic chargrid;
  getChargerData(cid) {
    print("CID IS HERE");
    print(cid);
    FirebaseFirestore.instance.collection("chargers")
        .doc(cid)
        .get()
        .then((docs) {
      if (docs.data() != null) {
        print("Document exists");
        print(docs.data().toString());
        print(docs.data()!['stationId']);
        sname = docs.data();
        chargrid = docs.id;
        print("CID: " + chargrid);
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

  dynamic stationName;

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

  deleteReservation(String docid) async {
    try {
      await FirebaseFirestore.instance
          .collection('reservations')
          .doc(docid)
          .delete();
      print('Document deleted successfully');
    } catch (error) {
      print('Error deleting document: $error');
    }
  }


  deleteBooking(String docid) async {
    try {
      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(docid)
          .delete();
      print('Document deleted successfully');
    } catch (error) {
      print('Error deleting document: $error');
    }
  }

}
