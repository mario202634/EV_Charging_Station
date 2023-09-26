import 'package:ev_charging_station_finder_1_0/reset_password_screen.dart';
import 'package:ev_charging_station_finder_1_0/side_bar.dart';
import 'package:ev_charging_station_finder_1_0/station_screen.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hexcolor/hexcolor.dart';

import 'model/users_model.dart';

class ProfileScreen extends StatefulWidget {

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isEditing = false;
  bool value = true;

  late TextEditingController emailController = TextEditingController(text: getEmail());
  // late TextEditingController fnameController = TextEditingController(text: user.fname);
  // late TextEditingController lnameController = TextEditingController(text: user.lname);
  // late TextEditingController numberController = TextEditingController(text: user.mobile);
  // late TextEditingController passwordController = TextEditingController(text: user.password);


  late User_Model user;
  CollectionReference notesRef = FirebaseFirestore.instance.collection("users");

  //
  // String? fName = "Mario";
  // String? lName = "Medhat";
  // String? email = " ";
  // String? mobile = "01287688898";
  // String? password = "123456";


  String getEmail() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.email ?? '';
    }
    return '';
  }

  @override
  void initState() {
    super.initState();
    // FirebaseFirestore.instance.collection('users').doc(
    //     FirebaseAuth.instance.currentUser!.uid).
    // get().
    // then((value) {
    //   User_Model myUser = User_Model.fromJson(value.data()!);
    //   user = myUser;
    // }).catchError((error) {
    //   print('Error while fetching user from firestore');
    // });
    //getUserDetails();
    setState(() {

    });
  }



  late TextEditingController fnameController = TextEditingController();
  late TextEditingController lnameController = TextEditingController();
  late TextEditingController numberController = TextEditingController();
  late TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text(
            'Profile'
        ),
        centerTitle: true,
      ),

      drawer: SideBar(),

      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              //          stream: notesRef.snapshots(),
              //          stream: notesRef.where('stationId', isEqualTo: data['stationId']).snapshots(),
                stream: notesRef
                    .where('email', isEqualTo: getEmail())
                    .snapshots(),
                builder: (context, snapshot) {
                  // if(snapshot.data?.docs.length == 0)
                  // {
                  //   return Column(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       Image(
                  //         image: AssetImage('assets/images/FinalCharging.png'),
                  //         width: 250, // Set the desired width
                  //         height: 250, // Set the desired height
                  //       ),
                  //       SizedBox(height: 20,),
                  //       Center(
                  //         child: Text(
                  //           'No Profile found',
                  //           style: TextStyle(
                  //             fontSize: 14,
                  //             //fontWeight: FontWeight.bold
                  //           ),
                  //         ),
                  //       ),
                  //
                  //     ],
                  //   );
                  // }
                  if (snapshot.hasError) {
                    return Text("Error");
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.white),
                          backgroundColor: Colors.purple,
                        )
                      // child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        //return Text("${snapshot.data?.docs[index]['stationId']}");
                        fnameController.text = snapshot.data?.docs[index]['fname'];
                        lnameController.text = snapshot.data?.docs[index]['lname'];
                        numberController.text = snapshot.data?.docs[index]['mobile'];
                        passwordController.text = snapshot.data?.docs[index]['password'];

                        print(fnameController.text);
                        return Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            //crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // SizedBox(
                              //   height: 5.0,
                              // ),
                              Row(children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: fnameController,
                                    enabled: isEditing,
                                    keyboardType: TextInputType.text,
                                    onFieldSubmitted: (value)
                                    {
                                      print(value);
                                    },
                                    decoration: InputDecoration(
                                        labelText: 'First Name',
                                        border: OutlineInputBorder(),
                                        prefixIcon: Icon(
                                          Icons.account_circle_outlined,
                                        )
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 20.0,
                                ),
                                Expanded(
                                  child: TextFormField(
                                    controller: lnameController,
                                    enabled: isEditing,
                                    keyboardType: TextInputType.text,
                                    onFieldSubmitted: (value)
                                    {
                                      print(value);
                                    },
                                    decoration: InputDecoration(
                                        labelText: 'Last Name',
                                        border: OutlineInputBorder(),
                                        prefixIcon: Icon(
                                          Icons.account_circle_outlined,
                                        )
                                    ),
                                  ),
                                ),
                              ]),
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
                              Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: TextFormField(
                                      controller: numberController,
                                      enabled: isEditing,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        labelText: 'Phone Number',
                                        border: OutlineInputBorder(),
                                        prefixIcon: Icon(Icons.phone_android),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              TextFormField(
                                controller: passwordController,
                                enabled: false,
                                obscureText: true,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(
                                    Icons.lock,
                                  ),
                                ),
                              ),

                              SizedBox(height: 5),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  //Disable Enable Text
                                  // ElevatedButton(
                                  //   onPressed: () {
                                  //     setState(() {
                                  //       isEditing = !isEditing;
                                  //     });
                                  //   },
                                  //   style: isEditing
                                  //       ? ElevatedButton.styleFrom(primary: Colors.grey)
                                  //       : ElevatedButton.styleFrom(primary: Colors.blue),
                                  //   child: Text(isEditing ? 'Disable Edit' : 'Enable Edit'),
                                  // ),
                                  buildSwitch(),
                                  Spacer(),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => ResetPasswordScreen()),
                                      );
                                    },
                                    child: Text(
                                      'Reset Password',
                                      style: TextStyle(
                                        //color: Colors.white,
                                      ),
                                    ),
                                  )
                                ],
                              ),

                              SizedBox(
                                height: 20.0,
                              ),
                              Container(
                                // color: HexColor("#131734"),
                                color: HexColor("#3f1651"),
                                width: double.infinity,
                                  child: Container(
                                      child: TextButton(
                                        onPressed: () {
                                          print(fnameController.toString());
                                          print(lnameController.toString());
                                            User_Model user = User_Model(
                                              fname: fnameController.text.trim(),
                                              lname: lnameController.text.trim(),
                                              mobile: numberController.text.trim(),
                                              email: emailController.text.trim(),
                                              password: passwordController.text.trim(),
                                            );
                                            print(fnameController.text);
                                            updateUserDetails(user);
                                            print('User updated sucessfully');
                                            print(user.toString());
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: Text('Edited'),
                                              content: Text('Changes saved successfully'),
                                              actions: [
                                                TextButton(
                                                    onPressed: () => Navigator.pop(context),
                                                    child: Text('Ok')
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        child: Text(
                                          'Save Changes',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      )
                                  ),
                              ),
                              //
                              // SizedBox(
                              //   height: 20.0,
                              // ),
                              Image(
                                image: AssetImage('assets/images/Account.png'),
                                width: 300, // Set the desired width
                                height: 300, // Set the desired height
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                  return Text("loding");
                }),
          ),
        ],
      ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             //crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(
//                 height: 20.0,
//               ),
//               Row(children: [
//                 Expanded(
//                   child: TextFormField(
//                     controller: fnameController,
//                     enabled: isEditing,
//                     keyboardType: TextInputType.text,
//                     onFieldSubmitted: (value)
//                     {
//                       print(value);
//                     },
//                     decoration: InputDecoration(
//                         labelText: 'First Name',
//                         border: OutlineInputBorder(),
//                         prefixIcon: Icon(
//                           Icons.account_circle_outlined,
//                         )
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   width: 20.0,
//                 ),
//                 Expanded(
//                   child: TextFormField(
//                     controller: lnameController,
//                     enabled: isEditing,
//                     keyboardType: TextInputType.text,
//                     onFieldSubmitted: (value)
//                     {
//                       print(value);
//                     },
//                     decoration: InputDecoration(
//                         labelText: 'Last Name',
//                         border: OutlineInputBorder(),
//                         prefixIcon: Icon(
//                           Icons.account_circle_outlined,
//                         )
//                     ),
//                   ),
//                 ),
//               ]),
//               SizedBox(
//                 height: 20.0,
//               ),
//               TextFormField(
//                 controller: emailController,
//                 keyboardType: TextInputType.emailAddress,
//                 enabled: isEditing,
//                 onFieldSubmitted: (value)
//                 {
//                   print(value);
//                 },
//                 decoration: InputDecoration(
//                     labelText: 'E-Mail Address',
//                     border: OutlineInputBorder(),
//                     prefixIcon: Icon(
//                       Icons.email_outlined,
//                     )
//                 ),
//               ),
//               SizedBox(
//                 height: 20.0,
//               ),
//               Row(
//                 children: [
//                   Expanded(
//                     flex: 3,
//                     child: TextFormField(
//                       controller: numberController,
//                       enabled: isEditing,
//                       keyboardType: TextInputType.number,
//                       decoration: InputDecoration(
//                         labelText: 'Phone Number',
//                         border: OutlineInputBorder(),
//                         prefixIcon: Icon(Icons.phone_android),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(
//                 height: 20.0,
//               ),
//               TextFormField(
//                 controller: passwordController,
//                 enabled: false,
//                 obscureText: true,
//                 decoration: InputDecoration(
//                   labelText: 'Password',
//                   border: OutlineInputBorder(),
//                   prefixIcon: Icon(
//                     Icons.lock,
//                   ),
//                 ),
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   Text(
//                     '',
//                   ),
//                   TextButton(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => ResetPasswordScreen()),
//                       );
//                     },
//                     child: Text(
//                       'Reset Password',
//                       style: TextStyle(
//                         //color: Colors.white,
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//               SizedBox(
//                 height: 20.0,
//               ),
//
//               Container(
//                 color: Colors.blue,
//                 width: double.infinity,
//                 child: MaterialButton(
//                   onPressed: ()
//                   {
// },
//                   child: Container(
//                       child: TextButton(
//                         onPressed: () {
//
//                         },
//                         child: Text(
//                           'Save Changes',
//                           style: TextStyle(
//                             color: Colors.white,
//                           ),
//                         ),
//                       )
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: 20.0,
//               ),
//
//             ],
//           ),
//         ),
//       ),
    );
  }

  void updateUserDetails(User_Model user) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update(user.toMap())
        .then((value) {}).catchError((error) {});
    setState(() {

    });
  }

    Widget buildSwitch() => Switch.adaptive(
        value: isEditing,
        onChanged: (value) => setState(() => isEditing = value),
    );

  // Future getUserDetails() async {
  //    await FirebaseFirestore.instance.collection('users').
  //    doc(FirebaseAuth.instance.currentUser!.uid).
  //    get().then((snapshot) async {
  //      if(snapshot.exists){
  //        setState(() {
  //          fName = snapshot.data()!["fname"];
  //          lName = snapshot.data()!["lname"];
  //          email = snapshot.data()!["email"];
  //          mobile = snapshot.data()!["mobile"];
  //          password = snapshot.data()!["password"];
  //        });
  //      }
  //    });
  // }

}
