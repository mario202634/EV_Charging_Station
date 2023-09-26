// import 'dart:async';
// import 'dart:math' as math;
// import 'package:ev_charging_station_finder_1_0/route_screen.dart';
// import 'package:ev_charging_station_finder_1_0/side_bar.dart';
// import 'package:ev_charging_station_finder_1_0/station_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
//
// class RouteScreen extends StatefulWidget {
//   final double latsrc;
//   final double lngsrc;
//   final double latdst;
//   final double lngdst;
//
//   const RouteScreen(this.latsrc, this.lngsrc, this.latdst, this.lngdst);
//
//   @override
//   _RouteScreenState createState() => _RouteScreenState(latsrc, lngsrc, latdst, lngdst);
// }
//
// class _RouteScreenState extends State<RouteScreen> {
//   final double latsrc;
//   final double lngsrc;
//   final double latdst;
//   final double lngdst;
//
//   late LatLng source;
//   late LatLng destination;
//
//   _RouteScreenState(this.latsrc, this.lngsrc, this.latdst, this.lngdst) {
//     source = LatLng(latsrc, lngsrc);
//     destination = LatLng(latdst, lngdst);
//   }
//
//   final Completer<GoogleMapController> _controller = Completer();
//
//   String googleApiKey = "AIzaSyCgR4LxabaW-1SzzyTOPJsaawgj41irC7Q";
//
//   List<LatLng> polyCoordinates = [];
//   // LocationData? currentLocation;
//
//   void getPolyPoints() async{
//     PolylinePoints polylinePoints = PolylinePoints();
//     PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
//       googleApiKey,
//       PointLatLng(source.latitude, source.longitude),
//       PointLatLng(destination.latitude, destination.longitude),
//     );
//
//     if(result.points.isNotEmpty)
//       {
//         result.points.forEach(
//               (PointLatLng point) => polyCoordinates.add(
//                   LatLng(point.latitude, point.longitude),
//               ),
//         );
//         setState(() {
//
//         });
//       }
//   }
//
//   // void getCurrentLocation(){
//   //   Location location = Location();
//   //    location.getLocation().then(
//   //        (location){
//   //          currentLocation = location;
//   //        }
//   //    );
//   // }
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     //getCurrentLocation();
//     getPolyPoints();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Route"),
//         centerTitle: true,
//       ),
//       body: GoogleMap(
//         initialCameraPosition: CameraPosition(
//           target: source,
//           zoom: 14.8,
//         ),
//         polylines: {
//           Polyline(
//             polylineId: PolylineId("route"),
//             points: polyCoordinates,
//             width: 6,
//           ),
//         },
//         markers: {
//           Marker(
//             markerId: MarkerId("destination"),
//             position: destination,
//           ),
//           Marker(
//             markerId: MarkerId("source"),
//             position: source,
//           ),
//         },
//       ),
//     );
//   }
// }
//
//
//
