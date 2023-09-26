import 'package:ev_charging_station_finder_1_0/suggest_station_map_screen.dart';
import 'package:ev_charging_station_finder_1_0/testing_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hexcolor/hexcolor.dart';

class SuggestStationScreen extends StatefulWidget {
  dynamic? latlng;

  SuggestStationScreen({this.latlng});

  @override
  _SuggestStationScreenState createState() => _SuggestStationScreenState();
}

class _SuggestStationScreenState extends State<SuggestStationScreen> {
  dynamic latlng;

  var nameController = TextEditingController();
  late TextEditingController latlngController;
  // var cpasswordController = TextEditingController();
  bool _obscureText = true;



  @override
  void initState() {
    super.initState();
    latlngController = TextEditingController(text: widget.latlng.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Suggest Stations'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Handle back button pressed
            Navigator.pop(context);
            // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => TestingScreen()));
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  controller: nameController,
                  keyboardType: TextInputType.text,
                  enabled: true,
                  onFieldSubmitted: (value) {
                    print(value);
                  },
                  decoration: InputDecoration(
                      labelText: 'Name:',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(
                        Icons.drive_file_rename_outline,
                      )),
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  controller: latlngController,
                  keyboardType: TextInputType.text,
                  enabled: false,
                  onFieldSubmitted: (value) {
                    print(value);
                  },
                  decoration: InputDecoration(
                      labelText: 'Location:',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(
                        Icons.location_on,
                      )),
                ),

                SizedBox(height: 20,),
                Container(
                  color: HexColor("#3f1651"),
                  width: double.infinity,
                  child: Container(
                      child: TextButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Thank You!'),
                                content: Text('Suggestion filed, thanks for the help!'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      addUserData();
                                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => TestingScreen()));

                                    },
                                    child: Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Text(
                          'SEND',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      )                  ),
                ),
                Image(
                  image: AssetImage('assets/images/CarCharger.png'),
                  width: 350, // Set the desired width
                  height: 350, // Set the desired height
                ),
              ],
            ),
          ),

        ],
      ),

    );
  }




  Future addUserData() async {
    await FirebaseFirestore.instance.collection('suggestedStations').doc().set({
      'name': nameController.text.trim(),
      'location': GeoPoint(widget.latlng.latitude, widget.latlng.longitude),
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

}
