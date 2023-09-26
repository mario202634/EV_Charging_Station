// ignore_for_file: avoid_print
import 'dart:math' as math;
import 'package:ev_charging_station_finder_1_0/route_screen.dart';
import 'package:ev_charging_station_finder_1_0/route_test_screen.dart';
import 'package:ev_charging_station_finder_1_0/side_bar.dart';
import 'package:ev_charging_station_finder_1_0/station_screen.dart';
import 'package:ev_charging_station_finder_1_0/suggest_station_map_screen.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hexcolor/hexcolor.dart';
import 'signup_screen.dart';

class TestingScreen extends StatefulWidget {
  const TestingScreen({Key? key}) : super(key: key);

  @override
  _TestingScreenState createState() => _TestingScreenState();
}

class _TestingScreenState extends State<TestingScreen> {
  Map<String, Marker> dbmarkers = <String, Marker>{};

  late GoogleMapController googleMapController;
  // static const CameraPosition initialCameraPosition = CameraPosition(target: LatLng(37.42796133580664, -122.085749655962), zoom: 14);
  static const CameraPosition initialCameraPosition = CameraPosition(target: LatLng(30.0444, 31.2357), zoom: 14.8);
  late BitmapDescriptor markerIcon;
  Set<Marker> markers = {};
  final user = FirebaseAuth.instance.currentUser!;
  Set<String> allMarkerId = {};
  CollectionReference notesRef = FirebaseFirestore.instance.collection("chargers");

  final lat1 = 37.7749;
  final lon1 = -122.4194;
  final lat2 = 40.7128;
  final lon2 = -74.0060;
  final speed = 30.0; // km/h




  void initMarker(data, dataid) async {
    var markerIdVal = dataid;
    final MarkerId markerId = MarkerId(markerIdVal);
    print("Documents init");
    final Marker marker = await Marker(
        markerId: markerId,
        // position: LatLng(db.data()['location'].latitude, db.data()['location'].latitude),
        position: LatLng(data['location'].latitude, data['location'].longitude),
        consumeTapEvents: true, // prevent re-centering when tapped
        // icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        icon: cmarker,
        onTap: () async {
          Position position = await _determinePosition();
          final distance = calculateDistance(position.latitude, position.longitude, data['location'].latitude, data['location'].longitude);
          final time = calculateTime(distance, 40 * 1000.0 / 3600.0);
          _tripEditModalBottomSheet(context, data, distance, time, position.latitude, position.longitude, data['location'].latitude, data['location'].longitude);
          getAvailChargers(data);
          getChargersTypes(data);
          print("Marker clicked");
        }
    );
    setState(() {
      dbmarkers[dataid] = marker;
    });

    allMarkerId.add(dataid);
    print("Start printing Keys");
    print(dbmarkers.keys.toString());
    print("Stop printing Keys");
    print("Start values Keys");
    print(dbmarkers.values.toString());
    print("Stop values Keys");
    print("Start values Ids");
    print(allMarkerId.toString());
    print("Stop values Ids");
    if(dbmarkers.keys.toString().contains("station1"))
    {
      print("Station1 found!");
    }

  }

  getMarkerData() {
    FirebaseFirestore.instance.collection("stations").get().then((docs) {
      if (docs.docs.isNotEmpty) {
        print("Documents exist");
        for (int i = 0; i < docs.docs.length; i++) {
          //initMarker(docs.docs[i].data(), docs.docs[i].id);
          initMarker(docs.docs[i].data(), docs.docs[i].data()['stationId']);

          print(docs.docs[i].data().toString());
          // print(dbmarkers['charger1']);
          // print(dbmarkers.values.toString());

          // if(dbmarkers.keys.toString().contains("Vx2UrfgHntvLujaaR9Tm"))
          //   {
          //     print("Charger1 found!");
          //   }
        }
        // print("Start printing Keys");
        // print(dbmarkers.keys.toString());
        // print("Stop printing Keys");
        // print("Start values Keys");
        // print(dbmarkers.values.toString());
        // print("Stop values Keys");
        // if(dbmarkers.keys.toString().contains("charger1"))
        //   {
        //     print("Charger1 found!");
        //   }

      }
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    //_determinePosition();
    customMarkers();
    getMarkerData();
    final distance = calculateDistance(lat1, lon1, lat2, lon2);
    final time = calculateTime(distance, speed * 1000.0 / 3600.0);
    print('Distance: ${distance.toStringAsFixed(2)} meters');
    print('Time: ${time.toStringAsFixed(2)} minutes');
    super.initState();
  }

  BitmapDescriptor cmarker = BitmapDescriptor.defaultMarker;
  BitmapDescriptor smarker = BitmapDescriptor.defaultMarker;

  void customMarkers() {
    BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.0),
        'assets/images/FinalStationMarker.png'
    ).then((icon) {
      cmarker = icon;
    });

    BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.0),
        'assets/images/FinalHome.png'
    ).then((icon) {
      smarker = icon;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Map"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              // Add your onPressed action here
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => SuggestStationMapScreen()));
            },
            icon: Transform.scale(
              scale: 1.3, // Adjust the scale factor as needed
              child: Icon(Icons.add_location_alt_outlined),
            ),
          ),
        ],
      ),

      drawer: SideBar(),

      body: GoogleMap(
        initialCameraPosition: initialCameraPosition,
        //markers: markers,
        markers: Set<Marker>.of(dbmarkers.values),
        zoomControlsEnabled: false,
        mapType: MapType.normal,
        onMapCreated: (GoogleMapController controller) {
          googleMapController = controller;
        },
      ),



      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Position position = await _determinePosition();
          googleMapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(position.latitude, position.longitude), zoom: 16)));
          //markers.clear();
          Marker markerHome = Marker  (
              markerId: const MarkerId('currentLocation'),
              position: LatLng(position.latitude, position.longitude),
              icon: smarker,
              infoWindow: InfoWindow(
                  title: 'Current location'
                //snippet: 'Current location',
              ),
              onTap: ()
              {
                //_tripEditModalBottomSheet(context);
                // if(MarkerId == MarkerId('myMarkerId'))
                // {
                //   print('Home');
                // }
              }
          );

          markers.add(markerHome);
          dbmarkers["home"] = markerHome;
          // loadMarker();
          // addCustomMarker();
          setState(() {});
        },
        child: const Icon(Icons.location_searching),
        //backgroundColor: Colors.blue, // set background color
        backgroundColor: HexColor("#3f1651"),
      ),
    );

  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error("Location permission denied");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }

    Position position = await Geolocator.getCurrentPosition();
    //googleMapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(position.latitude, position.longitude), zoom: 16)));

    Marker markerHome = Marker  (
        markerId: const MarkerId('currentLocation'),
        position: LatLng(position.latitude, position.longitude),
        icon: smarker,
        infoWindow: InfoWindow(
            title: 'Current location'
          //snippet: 'Current location',
        ),
        onTap: ()
        {
          //_tripEditModalBottomSheet(context);
          // if(MarkerId == MarkerId('myMarkerId'))
          // {
          //   print('Home');
          // }
        }
    );

    markers.add(markerHome);
    dbmarkers["home"] = markerHome;
    // loadMarker();
    // addCustomMarker();
    setState(() {});

    return position;
  }

  void _tripEditModalBottomSheet(context, param1, distance, time, latsrc, lngsrc, latdst, lngdst) {
    showModalBottomSheet(context: context, builder: (BuildContext bc) {
      return Container(
          height: MediaQuery.of(context).size.height * .60,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                //Name + Cancel
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(child:
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        param1["name"],
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    )),
                    // Spacer(),
                    // IconButton(
                    //   icon: Icon(Icons.cancel, color: Colors.red, size: 25,),
                    //   onPressed: () {
                    //     Navigator.of(context).pop();
                    //   },
                    // )
                  ],
                ),

                Divider(
                  indent: 15,
                  endIndent: 15,
                  height: 20,
                  thickness: 2,
                ),

                //Trip Info
                Column(
                  children: [
                    SizedBox(height: 5.0),

                    Text("Trip Information"),

                    SizedBox(height: 15.0),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.all(11),
                          child: Text(
                            'Distance: ${distance.toStringAsFixed(2)} kilometers',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                        SizedBox(width: 15),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.all(10),
                          child: Text(
                            'ETA: ${time.toStringAsFixed(0)} minutes',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: 15),

                Divider(
                  indent: 15,
                  endIndent: 15,
                  height: 20,
                  thickness: 2,
                ),

                //Chargers Information
                Column(
                  children: [
                    SizedBox(height: 5.0),

                    Text("Chargers Information"),

                    SizedBox(height: 15.0),

                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: EdgeInsets.all(11),
                            child: FutureBuilder<String>(
                              future: getAvailChargers(param1),
                              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return Text('Loading...');
                                }
                                print('Avaiable Chargers: ${snapshot.data}');
                                return Text('Avaiable Chargers: ${snapshot.data}');
                                return Text('Location: N/A');
                              },
                            ),
                          ),
                        ),
                        //Text(getAvailChargers(param1).toString()),
                        SizedBox(height: 15),
                        Center(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: EdgeInsets.all(10),
                            child: FutureBuilder<String>(
                              future: getChargersTypes(param1),
                              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return Text('Loading...');
                                }
                                print('Chargers Type: ${snapshot.data}');
                                return Text('Chargers Type: ${snapshot.data}');
                                return Text('Location: N/A');
                              },
                            ),
                          ),
                        ),
                      ],
                    ),


                    // Column(
                    //   // mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     StreamBuilder(
                    //         stream: notesRef
                    //             .where('stationId', isEqualTo: param1['stationId'])
                    //             .snapshots(),
                    //         builder: (context, snapshot) {
                    //           if (snapshot.hasError)
                    //           {
                    //             return Text("Error");
                    //           }
                    //           if (snapshot.connectionState == ConnectionState.waiting)
                    //           {
                    //             return Text("loding ....");
                    //           }
                    //           if (snapshot.hasData)
                    //           {
                    //             return ListView.builder(
                    //               itemCount: snapshot.data!.docs.length,
                    //               itemBuilder: (BuildContext context, int index) {
                    //                 return Text("${snapshot.data?.docs[index]['type']}");
                    //                 //return Text("Hi");
                    //               },
                    //             );
                    //           }
                    //           return Text("loding");
                    //         }),
                    //   ],
                    // ),
                  ],
                ),

                SizedBox(height: 15),

                Divider(
                  indent: 15,
                  endIndent: 15,
                  height: 20,
                  thickness: 2,
                ),

                //View Station Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StationScreen(data: param1),
                          ),
                        );
                      },
                      child: Text('View Station'),
                    ),
                    SizedBox(width: 20,),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RouteScreen(latsrc, lngsrc, latdst, lngdst),
                          ),
                        );
                      },
                      child: Text('Get Route'),
                    ),
                  ],
                )
              ],
            ),
          )
      );
    });
  }



// Calculates the distance (in meters) between two coordinates
  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371000.0; // Earth's radius in meters
    final phi1 = lat1 * math.pi / 180.0;
    final phi2 = lat2 * math.pi / 180.0;
    final deltaPhi = (lat2 - lat1) * math.pi / 180.0;
    final deltaLambda = (lon2 - lon1) * math.pi / 180.0;

    final a = math.sin(deltaPhi / 2.0) * math.sin(deltaPhi / 2.0) +
        math.cos(phi1) * math.cos(phi2) *
            math.sin(deltaLambda / 2.0) * math.sin(deltaLambda / 2.0);

    final c = 2.0 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    final distance = R * c;

    return distance / 1000;
  }

// Calculates the time (in minutes) to travel a certain distance (in meters)
  int calculateTime(double distance, double speed) {
    final timeInSeconds = (distance * 1000) / speed;
    final timeInMinutes = timeInSeconds / 60.0;

    if(timeInMinutes < 1)
    {
      return 1;
    }
    int minutes = timeInMinutes.ceil();
    return minutes;
  }


  // void drawPolyline(LatLng position1, LatLng position2) {
  //   Set<Polyline> _polylines = {};
  //   PolylineId _polylineId = PolylineId('polyline');
  //
  //   Polyline _polyline = Polyline(
  //     polylineId: _polylineId,
  //     color: Colors.blue,
  //     width: 5,
  //     points: [position1, position2],
  //   );
  //
  //   _polylines.add(_polyline);
  //
  //   // Add the _polylines set to the map's PolylineSet
  //   // This assumes that you have a GoogleMap widget with a controller.
  //   // Replace _mapController with the GoogleMapController used in your app.
  //   GoogleMapController.addPolylines(_polylines);
  // }

  dynamic ai7aga;
  Future<String> getAvailChargers(data) async {
    await FirebaseFirestore.instance.collection('chargers')
        .where('stationId', isEqualTo: data['stationId'])
        .where('active', isEqualTo: false)
        .get()
        .then((docs) {
      setState(() {
        ai7aga = docs.docs.length.toString();
        print(ai7aga);
        print("Ai7aga awel");
        return;
      });

      if (docs.docs.isNotEmpty) {
        print("Free found: \n");
        for (int i = 0; i < docs.docs.length; i++) {
          print("Charger: " + (i + 1).toString());
          ai7aga = (i + 1).toString();
          print(ai7aga);
          print("Fo2i ai 7aga");
          setState(() {
            ai7aga = docs.docs.length.toString();
            print(ai7aga);
            print("Ai7aga for");
            return;
          });
        }
        setState(() {
          ai7aga = docs.docs.length.toString();
          print(ai7aga);
          print("Ai7aga if");
          return;
        });
      }
      if (docs.docs.isEmpty) {
        // return "0"; //shady
        print("No Free found: \n");
        for (int i = 0; i < docs.docs.length; i++) {
          print("Charger: " + (i + 1).toString());
        }
        setState(() {
          ai7aga = docs.docs.length.toString();
          print(ai7aga);
          print("Ai7aga if 2");
          return;
        });
      }
      setState(() {
        ai7aga = docs.docs.length.toString();
        print(ai7aga);
        print("Ai7aga tani");
        return;
      });
    }
    );
    return ai7aga;
  }

  List<String> ai7aga2 = [];
  dynamic result;
  Future<String> getChargersTypes(data) async {
    await FirebaseFirestore.instance.collection('chargers')
        .where('stationId', isEqualTo: data['stationId'])
    // .distinct()
        .get()
        .then((docs) {
      ai7aga2 = [];
      for (int i = 0; i < docs.docs.length; i++) {
        // print("Charger: " + (i + 1).toString());
        // ai7aga = (i + 1).toString();
        if(ai7aga2.contains(docs.docs[i].data()['type'].toString()))
        {
          return;
        }
        if(!ai7aga2.contains(docs.docs[i].data()['type'].toString()))
        {
          ai7aga2.add(docs.docs[i].data()['type'].toString());
        }
        print(ai7aga2.toString());
        print("Fo2i ai7aga2");
        // String result = ai7aga2.join(', ');
        // print(result); // prints "1, 2, 3"
        setState(() {
          print("Charger Types downwoards");
          // ai7aga2.add(docs.docs[i].data()['type'].toString());
          result = ai7aga2.join(', ');
          print(result);
          print("Charger Types above");
          return;
        });
      }
      setState(() {
        print("2 Charger Types downwoards");
        // ai7aga2.add(docs.docs[i].data()['type'].toString());
        result = ai7aga2.join(', ');
        print(result);
        print("2 Charger Types above");
        return;
      });
    }
    );
    print("Result: " + result.toString());
    return result;
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

  }
}
