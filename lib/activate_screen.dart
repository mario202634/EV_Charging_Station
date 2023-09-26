import 'package:ev_charging_station_finder_1_0/my_booking_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ActivateScreen extends StatefulWidget {
  final dynamic data;
  final dynamic id;
  const ActivateScreen({this.data, this.id});

  @override
  _ActivateScreenState createState() => _ActivateScreenState(data: data, id: id);
}

class _ActivateScreenState extends State<ActivateScreen> {
  final dynamic data;
  final dynamic id;
  _ActivateScreenState({this.data, this.id});

  final GlobalKey _gLobalkey = GlobalKey();
  QRViewController? controller;
  Barcode? result;
  bool isInvalid = false; // Add this variable to the state

  void qr(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((event) {
      setState(() {
        result = event;
        print("Result: " + result!.code.toString());
        if (result!.code.toString() == id.toString()) {
          print("Valid QR Code");
          updateReservations();
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyBookingsScreen()));
          // Navigate to the next screen
        } else if (!isInvalid) {
          isInvalid = true;
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Invalid'),
              content: Text('Invalid QR Code \n Please try again'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    isInvalid = false;
                  },
                  child: Text('OK'),
                ),
              ],
            ),
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Activate Session"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 400,
              width: 400,
              child: QRView(
                  key: _gLobalkey,
                  onQRViewCreated: qr
              ),
            ),
            SizedBox(height: 20,),
            // ElevatedButton(
            //   onPressed: ()
            //   {
            //     updateReservations();
            //   },
            //   child: Text('Update'),
            // ),
            Center(
              child: (result !=null) ?
              // Text('${result!.code}')
              Text('Try again',
                style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),)
                  :
              Text(
                'Scan the QR Code',
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
              ),

            ),
            // Text(
            //   id.toString(),
            //   style: TextStyle(
            //     fontSize: 30.0,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  void updateReservations() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot reservations = await firestore
        .collection('reservations')
        .where('status', isEqualTo: "Reserved")
        .where('chargerId', isEqualTo: id.toString())
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid.toString())
        .get();

    reservations.docs.forEach((reservation) async {
      await firestore
          .collection('reservations')
          .doc(reservation.id)
          .update({'status': "Active"});
    });
    // Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyBookingsScreen()));
  }

}


// body: Column(
//   children: [
//     Text(data.toString()),
//     Text(data.toString()),
//     Text(data['stationId']),
//     Text(id.toString()),
//     //Generates the QR Code
//     QrImage(
//       data: id.toString(),
//       version: QrVersions.auto,
//       size: 200.0,
//     ),
//   ],
// ),