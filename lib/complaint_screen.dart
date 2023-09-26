import 'package:flutter/material.dart';
import 'package:ev_charging_station_finder_1_0/side_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ComplaintScreen extends StatefulWidget {
  final dynamic cid;
  const ComplaintScreen({this.cid});

  @override
  State<ComplaintScreen> createState() => _ComplaintScreenState(cid: cid);
}

class _ComplaintScreenState extends State<ComplaintScreen> {
  final dynamic cid;
  _ComplaintScreenState({this.cid});

  CollectionReference notesRef = FirebaseFirestore.instance.collection('complaints');

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("CID: " + cid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Complaint'),
        centerTitle: true,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('complaints')
            .doc(cid)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (!snapshot.hasError && snapshot.data != null) {
              final data = snapshot.data!.data() as Map<String, dynamic>;
              TextEditingController responseController = TextEditingController(text: data['complaint']);
              TextEditingController cidController = TextEditingController(text: cid);

              return SingleChildScrollView(
                child: Column(
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
                            controller: cidController,
                            keyboardType: TextInputType.emailAddress,
                            enabled: false,
                            onFieldSubmitted: (value) {
                              print(value);
                            },
                            decoration: InputDecoration(
                              labelText: 'Complaint ID',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.email_outlined),
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          TextFormField(
                            controller: responseController,
                            keyboardType: TextInputType.emailAddress,
                            enabled: false,
                            onFieldSubmitted: (value) {
                              print(value);
                            },
                            decoration: InputDecoration(
                                labelText: 'Response:',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(
                                  Icons.email_outlined,
                                )),
                          ),

                        ],
                      ),
                    ),
                    Image(
                      image: AssetImage('assets/images/Complaint.png'),
                      width: 300, // Set the desired width
                      height: 300, // Set the desired height
                    ),
                  ],
                ),
              );
            } else {
              return const Text('Error retrieving data');
            }
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),

    );

  }


  // Future<String> getComplaint(String cid) async {
  //   DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
  //       .collection('chargers')
  //       .doc(cid)
  //       .get();
  //
  //   if (documentSnapshot.exists) {
  //     Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
  //     return data['complaint'].toString();
  //   } else {
  //     return ''; // Return an empty string or handle the case when the document doesn't exist
  //   }
  // }

  Future<DocumentSnapshot> getComplaint(String cid) async {
    print("ANA DA5ALT");
    return await FirebaseFirestore.instance
        .collection('complaints')
        .doc(cid)
        .get();
  }



}
