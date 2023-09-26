import 'package:ev_charging_station_finder_1_0/complaint_response_screen.dart';
import 'package:flutter/material.dart';
import 'package:ev_charging_station_finder_1_0/side_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hexcolor/hexcolor.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({Key? key}) : super(key: key);

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {

  //var emailController = TextEditingController();
  late TextEditingController emailController = TextEditingController(text: getEmail());
  var complaintController = TextEditingController();

  String getEmail() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.email ?? '';
    }
    return '';
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Contact Us'
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              // Handle button press
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => ComplaintResponseScreen(uid: getCurrentUserId(),)));

            },
            icon: Icon(Icons.message_outlined),
          ),
        ],
      ),
      drawer: SideBar(),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20.0,
              ),
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                enabled: false,
                onFieldSubmitted: (value)
                {
                  print(value);
                },
                decoration: InputDecoration(
                    labelText: 'E-Mail Address',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(
                      Icons.email_outlined,
                    )
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              SizedBox(
                // height: 85.0 + (complaintController.text.length / 20.0) * 15.0,
                child: TextFormField(
                  controller: complaintController,
                  keyboardType: TextInputType.text,
                  maxLines: null,
                  onChanged: (value) {
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    labelText: 'Write Complaint',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.text_snippet_outlined),
                  ),
                ),
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
                                title: Text('Confirm complaint'),
                                content: Text('Are you sure you want to submit this complaint?'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('CANCEL'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      addComplaint(emailController.text.trim(), complaintController.text.trim());
                                      Navigator.of(context).pop();
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('Complaint submitted'),
                                            content: Text('Your complaint has been submitted successfully.'),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  complaintController.clear();
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text('OK'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: Text('SEND'),
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
              SizedBox(height: 20,),
              Image(
                image: AssetImage('assets/images/Contact.png'),
                width: 340, // Set the desired width
                height: 340, // Set the desired height
              ),
            ],
          ),



        ),
      ),


    );

  }

  Future addComplaint(String email, String complaint) async {
    await FirebaseFirestore.instance.collection('complaints').add({
      'email': email,
      'complaint': complaint,
      'uid': getCurrentUserId(),
      'status': true
    });
  }

  String getCurrentUserId() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userId = user.uid;
      return userId;
    } else {
      // User is not signed in
      return '';
    }
  }

}
