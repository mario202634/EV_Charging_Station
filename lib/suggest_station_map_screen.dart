import 'dart:async';
import 'package:ev_charging_station_finder_1_0/suggest_station_screen.dart';
import 'package:ev_charging_station_finder_1_0/testing_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hexcolor/hexcolor.dart';

class SuggestStationMapScreen extends StatefulWidget {


  SuggestStationMapScreen();

  @override
  _SuggestStationMapScreenState createState() => _SuggestStationMapScreenState();
}

class _SuggestStationMapScreenState extends State<SuggestStationMapScreen> {

  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  late GoogleMapController googleMapController;


  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(30.05057361352647, 31.2371783382212),
    zoom: 14.4746,
  );

  List<Marker> myMarker = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _determinePosition();
    customMarkers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Suggest Station"),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => TestingScreen()));
          },
        ),
      ),
      body: GestureDetector(
        onTap: () {
          // Handle the onTap gesture here if needed
        },
        child: Stack(
          children: [
            GoogleMap(
              mapType: MapType.normal,
              onMapCreated: (GoogleMapController controller) {
                googleMapController = controller;
              },
              initialCameraPosition: _kGooglePlex,
              markers: Set.from(myMarker),

              onTap: (LatLng loc) {
                print("Anoo : $loc");
                addMarker(loc);
                setState(() {
                  latlng = loc;
                });
              },
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.only(bottom: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 45,
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle button press here
                          if(latlng == null)
                            {
                              print("Empty LatLng");
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Pick Location'),
                                    content: Text('No Location has been choose, please pick a location.'),
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
                          if(latlng != null)
                          {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SuggestStationScreen(latlng: latlng,)),);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          //primary: Colors.blue,
                          primary: HexColor("#3f1651"),


                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Next',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: 15), // add spacing between the buttons
                    FloatingActionButton(
                      onPressed: () async {
                        Position position = await _determinePosition();
                        googleMapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(position.latitude, position.longitude), zoom: 16)));
                        setState(() {});
                      },
                      child: const Icon(Icons.location_searching),
                      //backgroundColor: Colors.blue, // set background color
                      backgroundColor: HexColor("#3f1651"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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
    setState(() {});

    return position;
  }

  BitmapDescriptor cmarker = BitmapDescriptor.defaultMarker;

  void customMarkers() {
    BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.0),
        'assets/images/FinalStationMarker.png'
    ).then((icon) {
      cmarker = icon;
    });
  }

  dynamic latlng;
  addMarker(LatLng location){
    print(location);
    setState(() {
      myMarker = [];
      myMarker.add(
        Marker(
            markerId: MarkerId(location.toString()),
            position: location,
            icon: cmarker,
            draggable: true,
            onDragEnd: (dragEndPostion){
              print(dragEndPostion);
              setState(() {
                // latlng = location;
              });
            }
        ),
      );
    });
    print("ana location: " + location.toString());
    return location;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}