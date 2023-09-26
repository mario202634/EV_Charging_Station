import 'dart:async';
import 'dart:math' as math;
import 'package:ev_charging_station_finder_1_0/route_screen.dart';
import 'package:ev_charging_station_finder_1_0/side_bar.dart';
import 'package:ev_charging_station_finder_1_0/station_screen.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:location/location.dart';
import 'package:hexcolor/hexcolor.dart';

class RouteScreen extends StatefulWidget {
  final double latsrc;
  final double lngsrc;
  final double latdst;
  final double lngdst;

  const RouteScreen(this.latsrc, this.lngsrc, this.latdst, this.lngdst);

  @override
  _RouteScreenState createState() => _RouteScreenState(latsrc, lngsrc, latdst, lngdst);
}

class _RouteScreenState extends State<RouteScreen> {
  final double latsrc;
  final double lngsrc;
  final double latdst;
  final double lngdst;

  late LatLng source;
  late LatLng destination;

  _RouteScreenState(this.latsrc, this.lngsrc, this.latdst, this.lngdst) {
    source = LatLng(latsrc, lngsrc);
    destination = LatLng(latdst, lngdst);
  }

  final Completer<GoogleMapController> _controller = Completer();

  String googleApiKey = "AIzaSyCgR4LxabaW-1SzzyTOPJsaawgj41irC7Q";

  List<LatLng> polyCoordinates = [];
  LocationData? currentLocation;
  late GoogleMapController googleMapController;
  void getPolyPoints() async{
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey,
      PointLatLng(source.latitude, source.longitude),
      PointLatLng(destination.latitude, destination.longitude),
    );

    if(result.points.isNotEmpty)
    {
      result.points.forEach(
            (PointLatLng point) => polyCoordinates.add(
          LatLng(point.latitude, point.longitude),
        ),
      );
      setState(() {

      });
    }
  }

  // crash
  void getCurrentLocation(){
    Location location = Location();
    location.getLocation().then(
            (location){
          currentLocation = location;
        }
    );
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

  //not working
  // void _determinePosition() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;
  //
  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //
  //   if (!serviceEnabled) {
  //     return Future.error('Location services are disabled');
  //   }
  //
  //   permission = await Geolocator.checkPermission();
  //
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //
  //     if (permission == LocationPermission.denied) {
  //       return Future.error("Location permission denied");
  //     }
  //   }
  //
  //   if (permission == LocationPermission.deniedForever) {
  //     return Future.error('Location permissions are permanently denied');
  //   }
  //
  //   Position position = await Geolocator.getCurrentPosition();
  //
  //   currentLocation = position as LocationData?;
  // }


  //crash
  // Future _getLocation() async {
  //       Location location = new Location();
  //   LocationData _currentPosition = await location.getLocation();
  //   currentLocation = _currentPosition;
  // }

  @override
  void initState() {
    // TODO: implement initState
    //getCurrentLocation();
    // _getLocation();
    // _determinePosition();
    getPolyPoints();
    customMarkers();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Route"),
        centerTitle: true,
      ),
      body: //currentLocation == null ? Center(child: Text("Loading")) :
      GoogleMap(
        initialCameraPosition: CameraPosition(
          target: source,
          zoom: 14.8,
        ),
        polylines: {
          Polyline(
            polylineId: PolylineId("route"),
            points: polyCoordinates,
            width: 6,
          ),
        },
        markers: {
          Marker(
            markerId: MarkerId("destination"),
            position: destination,
            //icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
            icon: cmarker,
          ),
          Marker(
            markerId: MarkerId("source"),
            position: source,
            icon: smarker,
            onTap: (){

            },
          ),

          // Marker(
          //   markerId: MarkerId("source"),
          //   position: LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
          // ),
        },
        onMapCreated: (GoogleMapController controller) {
          googleMapController = controller;
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          googleMapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(target: source, zoom: 16),
            ),
          );

          setState(() {});
        },
        child: const Icon(Icons.location_searching),
        backgroundColor: HexColor("#3f1651"),
      ),
    );
  }
}





