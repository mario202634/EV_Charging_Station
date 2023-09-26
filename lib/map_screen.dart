import 'package:ev_charging_station_finder_1_0/side_bar.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

  late GoogleMapController googleMapController;
  // static const CameraPosition initialCameraPosition = CameraPosition(target: LatLng(37.42796133580664, -122.085749655962), zoom: 14);
  static const CameraPosition initialCameraPosition = CameraPosition(target: LatLng(30.0444, 31.2357), zoom: 15);
  late BitmapDescriptor markerIcon;
  Set<Marker> markers = {};
  final user = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    // TODO: implement initState
    addCustomMarker();
    loadMarker();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Charging Stations"),
        centerTitle: true,
      ),

      drawer: SideBar(),

      body: GoogleMap(
        initialCameraPosition: initialCameraPosition,
        markers: markers,
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
            onTap: () {
              _tripEditModalBottomSheet(context);
              if(MarkerId == MarkerId('currentLocation')) {
                print('Home');
              }
            },
            consumeTapEvents: false,
          );


          markers.add(markerHome);
          // loadMarker();
          // addCustomMarker();
          setState(() {});
        },
        child: const Icon(Icons.location_searching),
        backgroundColor: Colors.blue, // set background color
      ),
    );
  }

  //Gets current position after permission
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

    return position;
  }

  void loadMarker(){
    markers.add(Marker  (
      markerId: const MarkerId('charger1'), //markerId = stationId
      position: LatLng(30.117770768277637, 31.338407121654043),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      onTap: () {
        _tripEditModalBottomSheet(context);
        if(MarkerId == 'charger1') {
          print('Charger 1');
        }
      },
      consumeTapEvents: false,
    )
    );

    setState(() {});
  }

  // void loadMarker2(){
  //   markers.add(Marker  (
  //       markerId: const MarkerId('currentLocation3'),
  //       position: LatLng(30.115218026801752, 31.340009071677837),
  //       icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
  //       onTap: () {
  //         _tripEditModalBottomSheet(context);
  //         if(MarkerId != 'currentLocation3')
  //         {
  //           print('Z Beauty Academy');
  //         }
  //       }));
  //
  //   setState(() {});
  // }


  void _tripEditModalBottomSheet(context) {
    showModalBottomSheet(context: context, builder: (BuildContext bc) {
      return Container(
          height: MediaQuery.of(context).size.height * .60,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text("Edit Trip"),
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.cancel, color: Colors.blue, size: 25,),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )

                  ],
                ),
              ],
            ),
          )
      );
    });
  }

  void addCustomMarker(){
    BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), "assets\images\StationMarker.png").then((icon) {
        setState(() {
          markerIcon = icon;
        });
    },);
  }


}