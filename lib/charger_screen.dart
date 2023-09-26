import 'package:ev_charging_station_finder_1_0/side_bar.dart';
import 'package:ev_charging_station_finder_1_0/station_screen.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChargerScreen extends StatefulWidget {
  final dynamic data;
  const ChargerScreen({this.data});

  @override
  _ChargerScreenState createState() => _ChargerScreenState(data: data);
}

class _ChargerScreenState extends State<ChargerScreen> {
  final dynamic data;
  _ChargerScreenState({this.data});
  String? ai7aga;

  late TextEditingController dateController = TextEditingController(text: choosenDate.toString().substring(0, 10));

  @override
  void initState() {
    // TODO: implement initState
    getChargers();
    super.initState();
    getStationName();
    // List<int> numbers = [1, 2, 3];
    // String result = numbers.join(', ');
    // print(result); // prints "1, 2, 3"
  }
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('chargers')
  // .where('stationId', isEqualTo: data['stationId'])
      .snapshots();

  CollectionReference notesRef = FirebaseFirestore.instance.collection("chargers");
  DateTime choosenDate = DateTime.now();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
        Text("Charger Type: " + data['type']),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(getStationName().toString()),
            SizedBox(
              height: 10.0,
            ),
            Text("Charger Type: " + data['type']),
            SizedBox(
              height: 20.0,
            ),
            Text(choosenDate.toString().substring(0, 10)),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    datePicker(choosenDate);
                  },
                  icon: Icon(Icons.calendar_today_rounded),
                ),
                Expanded(
                  child: TextFormField(
                    controller: dateController,
                    enabled: false,
                    decoration: InputDecoration(
                      labelText: 'Choose Date',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    datePicker(choosenDate);
                  },
                  icon: Icon(Icons.access_time_outlined),
                ),
                Expanded(
                  child: TextFormField(
                    //controller: dateController,
                    enabled: false,
                    decoration: InputDecoration(
                      labelText: 'Choose Time',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            ElevatedButton(
              onPressed: () {
                datePicker(choosenDate);
              },
              child: Text('Book Now'),
            ),
          ],
        ),
      ),
    );
  }


  void getChargers() {
    print("StationId");
    print(data['stationId']);
    FirebaseFirestore.instance.collection('chargers')
        .where('stationId', isEqualTo: data['stationId'])
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

void datePicker(DateTime x){
    showDatePicker(context: context,
        initialDate: x,
        firstDate: DateTime(2020),
        lastDate: DateTime(2025),
    ).then((value) {
      setState(() {
        choosenDate = value!;
        dateController.text = choosenDate.toString().substring(0, 10);
      });
    });
}


  // getStationName() async {
  //   String? stationName;
  //   QuerySnapshot querySnapshot = await FirebaseFirestore.instance
  //       .collection('stations')
  //       .where('stationId', isEqualTo: data['stationId'])
  //       .get();
  //   // if (querySnapshot.size > 0) {
  //     stationName = querySnapshot.docs[0].get('name');
  //   // }
  //   print("Yarab n5ls");
  //   print(stationName);
  //   return stationName;
  // }


  getStationName() {
    FirebaseFirestore.instance.collection('stations').where('stationId', isEqualTo: data['stationId']).get().then((docs) {
        setState(() {
          ai7aga = docs.docs[0].data()['name'];
          return;
        });
    }

    );
    return ai7aga;
  }


}
