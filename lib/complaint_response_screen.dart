import 'package:ev_charging_station_finder_1_0/complaint_screen.dart';
import 'package:flutter/material.dart';
import 'package:ev_charging_station_finder_1_0/side_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ComplaintResponseScreen extends StatefulWidget {
  final dynamic uid;
  const ComplaintResponseScreen({this.uid});

  @override
  State<ComplaintResponseScreen> createState() => _ComplaintResponseScreenState(uid: uid);
}

class _ComplaintResponseScreenState extends State<ComplaintResponseScreen> {
  final dynamic uid;
  _ComplaintResponseScreenState({this.uid});

  CollectionReference notesRef = FirebaseFirestore.instance.collection("responses");


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Responses'),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: notesRef.where('uid', isEqualTo: uid).snapshots(),
        builder: (context, snapshot) {
          if(snapshot.data?.docs.length == 0)
          {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage('assets/images/Message.png'),
                  width: 250, // Set the desired width
                  height: 250, // Set the desired height
                ),
                SizedBox(height: 20,),
                Center(
                  child: Text(
                    'No Previous Cases',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ],
            );
          }
          if (snapshot.hasError) {
            return Text("Error");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading...");
          }
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext context, int index) {
                // bool isActive = snapshot.data?.docs[index]['active'] ?? false;

                TextEditingController responseController = TextEditingController(text: snapshot.data?.docs[index]['response']);
                TextEditingController cidController = TextEditingController(text: snapshot.data?.docs[index]['cid']);
                print(responseController.text);
                print(cidController.text);

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        //crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 20.0,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
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
                              ),
                              IconButton(
                                icon: Icon(Icons.arrow_forward),
                                onPressed: () {
                                  // Handle the arrow button click event here
                                  // Add your desired functionality
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => ComplaintScreen(cid: cidController.text)));

                                },
                              ),
                            ],
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
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0), // Set the left and right margin to 16.0 pixels
                      child: Divider(
                        thickness: 2.0,
                      ),
                    )

                  ],
                );
              },
            );
          }
          return Text('No data available');
        },
      ),
    );


  }


}
