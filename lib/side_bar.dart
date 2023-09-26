import 'dart:ffi';
import 'package:ev_charging_station_finder_1_0/contact_us_screen.dart';
import 'package:ev_charging_station_finder_1_0/login_screen.dart';
import 'package:ev_charging_station_finder_1_0/map_screen.dart';
import 'package:ev_charging_station_finder_1_0/model/users_model.dart';
import 'package:ev_charging_station_finder_1_0/my_booking_screen.dart';
import 'package:ev_charging_station_finder_1_0/profile_screen.dart';
import 'package:ev_charging_station_finder_1_0/signup_screen.dart';
import 'package:ev_charging_station_finder_1_0/terms_screen.dart';
import 'package:ev_charging_station_finder_1_0/testing_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

import 'map_test_screen.dart';

//https://oflutter.com/create-a-sidebar-menu-in-flutter/ source

late User_Model user;

String getEmail() {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    return user.email ?? '';
  }
  return '';
}

late String fullName;

@override
// void getData() async {
//   FirebaseFirestore.instance.collection('users').doc(
//       FirebaseAuth.instance.currentUser!.uid).
//   get().
//   then((value) {
//     User_Model myUser = User_Model.fromJson(value.data()!);
//     user = myUser;
//   }).catchError((error) {
//     print('error while fetching user from firestore');
//   });
// }


class SideBar extends StatefulWidget {
  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {

  // String getStudentName(String email)  {
  //   FirebaseFirestore.instance.collection('users')
  //       .where('email', isEqualTo: email)
  //       .get().then((value) {
  //     // if (value.docs.isNotEmpty) {
  //     //   String fname = value.docs.first.get('fname');
  //     //   String lname = value.docs.first.get('lname');
  //     //   return '$fname $lname';
  //     // }
  //     // else {
  //     //   return '';
  //     // }
  //     String fname = value.docs.first.get('fname');
  //     String lname = value.docs.first.get('lname');
  //     fullName = '$fname $lname';
  //     print(value.docs.first.get('fname'));
  //     print(value.docs.first.get('lname'));
  //     return fullName;
  //   });
  //   return fullName;
  // }
  //
  // String studentName = getStudentName(getEmail());

  String? fname;
  String? lname;

  void _launchURL() async {
    final Uri url = Uri.parse('https://docs.google.com/forms/d/e/1FAIpQLSe5ioT3aAUzATizZDrZMfJW32Bl8hrBPVg5yRANmqIuwHK38w/viewform');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  getfName() {
    FirebaseFirestore.instance.collection('users')
      .where('email', isEqualTo: getEmail()).get().then((docs) {
      setState(() {
        fname = docs.docs[0].data()['fname'];
        return;
      });
    }

    );
    return fname;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getfName();
    getlName();
  }

  getlName() {
    FirebaseFirestore.instance.collection('users')
        .where('email', isEqualTo: getEmail()).get().then((docs) {
      setState(() {
        lname = docs.docs[0].data()['lname'];
        return;
      });
    }

    );
    return lname;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Remove padding
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(getfName().toString() + " " + getlName().toString()),
            accountEmail: Text(getEmail()),
            // currentAccountPicture: CircleAvatar(
            //   child: ClipOval(
            //     child: Image.network(
            //       'https://oflutter.com/wp-content/uploads/2021/02/girl-profile.png',
            //       fit: BoxFit.cover,
            //       width: 90,
            //       height: 90,
            //     ),
            //   ),
            // ),
            // decoration: BoxDecoration(
            //   color: Colors.blue,
            //   image: DecorationImage(
            //       fit: BoxFit.fill,
            //       //image: AssetImage('assets/images/sidebar.jpg')
            //        image: NetworkImage('https://egbc-images.s3-eu-west-1.amazonaws.com/content/w620/426995.jpg')),
            //   //https://aaaliving.acg.aaa.com/wp-content/uploads/2021/08/questions-about-electric-car-768x432.jpg picture 1
            //   //https://www.hdfcergo.com/images/default-source/two-wheeler-insurance-page-images/electric-vehicle-rules.jpg picture 2
            //   //https://mediacloud.theweek.com/image/upload/f_auto,t_primary-image-desktop@1/v1644342520/electric%20pollution.jpg picture 3
            //   //https://www.resilinc.com/wp-content/uploads/2021/12/electric-car-2.jpg picture 4
            // ),
            decoration: BoxDecoration(
              color: Colors.purple,
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('assets/images/FinalSidebarNew.jpeg'),
              ),
            ),
          ),

          ListTile(
            leading: Icon(Icons.map_outlined),
            title: Text('Home'),
            // onTap: () {
            //   Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()),
            //   );
            // },
            onTap: (){
              Navigator.pop(context);
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const TestingScreen()));
            },
          ),

          ListTile(
            leading: Icon(Icons.account_circle_outlined),
            title: Text('Profile'),
            // onTap: () {
            //   Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()),
            //   );
            // },
            onTap: (){
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfileScreen()));
            },
          ),
          ListTile(
              leading: Icon(Icons.library_books_outlined),
              title: Text('My Bookings'),
            onTap: (){
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyBookingsScreen()));
            },
          ),

          Divider(),

          ListTile(
            leading: Icon(Icons.message_outlined),
            title: Text('Contact Us'),
            onTap: (){
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => ContactUsScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.description),
            title: Text('Terms & Condition'),
            onTap: (){
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => TermsScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.rate_review_outlined),
            title: Text('Rate Experience'),
            onTap: (){
              Navigator.pop(context);
              //Navigator.of(context).push(MaterialPageRoute(builder: (context) => TermsScreen()));
              _launchURL();
            },
          ),
          Divider(),
          ListTile(
            title: Text('Log Out'),
            leading: Icon(Icons.exit_to_app),
            onTap: (){
              //Navigator.pop(context);
              //Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginScreen()));
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Logout'),
                    content: Text('Are you sure you want to log out?'),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Cancel')
                      ),
                      TextButton(
                        child: Text('Logout'),
                        onPressed: () {
                          Navigator.pop(context);
                          FirebaseAuth.instance.signOut();
                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
                        },
                      )
                    ],
                  ),
              );
            },
          ),
        ],
      ),
    );
  }
}