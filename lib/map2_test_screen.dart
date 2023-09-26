import 'package:ev_charging_station_finder_1_0/side_bar.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Map2TestScreen extends StatefulWidget {
  const Map2TestScreen({Key? key}) : super(key: key);

  @override
  _Map2TestScreenState createState() => _Map2TestScreenState();
}

class _Map2TestScreenState extends State<Map2TestScreen> {
  late GoogleMapController _controller;

  late Position position;

  late Widget _child;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  late BitmapDescriptor pinLocationIcon;

  @override
  void initState() {

    getCurrentLocation();
    populateClients();
    setCustomMapPin();
    super.initState();
  }

  void getCurrentLocation() async {
    Position res = await getCurrentPosition();
    setState(() {
      position = res;
      _child = mapWidget();
    });
  }

  populateClients() {
    FirebaseFirestore.instance.collection("stations").get().then((docs) {
      if (docs.docs.isNotEmpty) {
        for (int i = 0; i < docs.docs.length; ++i) {
          initMarker(docs.docs[i].data(), docs.docs[i].id);
        }
      }
    });
  }

  void initMarker(tomb, tombId) {
    var markerIdVal = tombId;
    final MarkerId markerId = MarkerId(markerIdVal);

    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(
          tomb.data()['location'].latitude, tomb.data()['location'].latitude),
      icon: pinLocationIcon,
    );
    setState(() {
      markers[markerId] = marker;
    });
  }

  void setCustomMapPin() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), 'assets/icon/pin.png');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Color(0xffffb838)),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: _child,
    );
  }

  Widget mapWidget() {
    return Stack(
      children: <Widget>[
        GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 10,
            ),
            onMapCreated: (GoogleMapController controller) {
              _controller = controller;
            },
            compassEnabled: true,
            myLocationEnabled: true,
            markers: Set<Marker>.of(markers.values)),
        SizedBox(
          height: 26,
        ),
      ],
    );
  }

  Future<Position> getCurrentPosition() async {
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

    return position;
  }

}

