import 'dart:async';
import 'package:ev_charging_station_finder_1_0/testing_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'login_screen.dart';


class VerifyScreen extends StatefulWidget {
  dynamic mail;
  VerifyScreen({required this.mail}); // Make the mail parameter a named parameter

  @override
  State<VerifyScreen> createState() => _VerifyScreenState(mail); // Pass the mail parameter to the constructor
}
class _VerifyScreenState extends State<VerifyScreen> {
  dynamic mail;
  _VerifyScreenState(this.mail);
  // const ResetPasswordScreen({Key? key}) : super(key: key);
  // final auth = FirebaseAuth.instance;
  // late User user;
  // dynamic user = FirebaseAuth.instance.currentUser;

  late Timer timer;
  late Timer checker;
  @override
  void initState(){
    // user.sendEmailVerification();
    // checker = Timer.periodic(Duration(seconds: 1), (timer) {
    //   setState(() {
    //
    //   });
    // });
    timer = Timer.periodic(Duration(seconds: 5), (timer) {
      checkEmailVerified();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
              'Verify Account'
          ),
          centerTitle: true,
        ),

        body: FutureBuilder<void>(
          future: sendEmail(), // Use Future<void> instead of Future<String>
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            else {
              String currentUserEmail = FirebaseAuth.instance.currentUser?.email ?? "";
              // TextEditingController emailController = TextEditingController(text: "E-Mail sent to: $currentUserEmail");
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20.0,
                    ),
                    Text("E-Mail sent to: ", style: TextStyle(fontSize: 30),),
                    Text(mail, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                    SizedBox(height: 20,),
                    Image(
                      image: AssetImage('assets/images/Verification.png'),
                      width: 340, // Set the desired width
                      height: 340, // Set the desired height
                    ),
                  ],
                ),



              ); // Update the displayed text
            }
          },
        )
    );

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    checkEmailVerified();
    timer;
    checker;
  }

  Future<void> checkEmailVerified() async {
    User user = FirebaseAuth.instance.currentUser!;
    await user.reload();
    if(user.emailVerified){
      timer.cancel();
      FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'verified' : true
      }).then((value) {
        print('Attribute updated successfully');
      }).catchError((error) {
        print('Error updating attribute: $error');
      });
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Verified'),
          content: Text('Account Verified successfully'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => TestingScreen()));
                dispose();
              },
            )
          ],
        ),
      );
      setState(() {

      });
    }
  }
  Future<void> sendEmail() async {
    FirebaseAuth.instance.currentUser!.sendEmailVerification();
  }
}
// void getCurrentUser() {
//   User? user = FirebaseAuth.instance.currentUser;
//   if (user != null) {
//     // User is signed in
//     String uid = user.uid; // User ID
//     String email = user.email!; // User email (if available)
//     // Access other properties of the user object as needed
//     print('User ID: $uid');
//     print('Email: $email');
//   } else {
//     // User is not signed in
//     print('No user signed in');
//   }
// }
