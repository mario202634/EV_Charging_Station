import 'dart:ffi';
import 'package:ev_charging_station_finder_1_0/login_screen.dart';
import 'package:ev_charging_station_finder_1_0/model/users_model.dart';
import 'package:ev_charging_station_finder_1_0/side_bar.dart';
import 'package:ev_charging_station_finder_1_0/verify_screen.dart';
import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hexcolor/hexcolor.dart';

class SignupScreen extends StatefulWidget
{
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  var fnameController = TextEditingController(text: '');

  var lnameController = TextEditingController(text: '');

  var emailController = TextEditingController(text: '');

  var mobileController = TextEditingController(text: '');

  var passwordController = TextEditingController(text: '');

  var cpasswordController = TextEditingController(text: '');
//REMOVE ALL THE TEXTS AFTER CONNECTING TO DATABASE

  bool _obscureText = false;

  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();


  CountryCode countryCode = CountryCode(); // default country code
  String selectedCountryCode = '+20';

  String codenum = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   leading: Icon(
      //     Icons.menu, ),
      //   title: Text(
      //       'EV Charging Station'),
      //   centerTitle: true,
      //   actions: [
      //     // IconButton(
      //     //     onPressed: SearchFunction,
      //     //     icon: Icon(
      //     //       Icons.search, )),
      //     // IconButton(onPressed: RingFunction, icon: Icon(Icons.access_alarm))
      //   ],
      //   elevation: 0.0,
      // ),
      appBar: AppBar(
        title: Text(
          'Sign Up'
        ),
        centerTitle: true,
      ),

      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text(
                //   'Signup',
                //   style: TextStyle(
                //     fontSize: 30.0,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
                // SizedBox(
                //   height: 20.0,
                // ),
                Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: fnameController,
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
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter First Name';
                            }
                            return null;
                          },
                        ),
                      ),
                  SizedBox(
                    width: 20.0,
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: lnameController,
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
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter Last Name';
                        }
                        return null;
                      },
                    ),
                  )
                ]
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
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
                  validator: (value) {
                    if (value!.length == 0) {
                      return 'Please enter email address';
                    }
                    if (!RegExp(r'\S+@\S+.\S+').hasMatch(value.toString())) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  children: [
                    Container(
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        border: Border.all(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: CountryCodePicker(
                        onChanged: (CountryCode countryCode) {
                          setState(() {
                            selectedCountryCode = countryCode.toString();
                          });
                          print(selectedCountryCode);
                        },                        // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                        initialSelection: 'EG',
                        favorite: ['+20','EG'],
                        // optional. Shows only country name and flag
                        showCountryOnly: false,
                        // optional. Shows only country name and flag when popup is closed.
                        showOnlyCountryWhenClosed: false,
                        // optional. aligns the flag and the Text left
                        alignLeft: false,
                      ),
                    ),
                    SizedBox(width: 10,),
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        controller: mobileController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.phone_android),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter Phone Number';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  controller: passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(
                      Icons.lock,
                    ),
                    suffixIcon: IconButton(
                      icon: _obscureText
                          ? Icon(Icons.visibility_off)
                          : Icon(Icons.visibility),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value!.length < 6) {
                      return 'Password must be at least 6 characters long';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  controller: cpasswordController,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(
                      Icons.lock,
                    ),
                    suffixIcon: IconButton(
                      icon: _obscureText
                          ? Icon(Icons.visibility_off)
                          : Icon(Icons.visibility),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value!.length < 6) {
                      return 'Password must be at least 6 characters long';
                    }
                    if (value! != passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  // color: HexColor("#131734"),
                  color: Colors.deepOrange,
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: HexColor("#131734")),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        print("Full Name: " + fnameController.text + " " + lnameController.text);
                        print("E-Mail Address: " + emailController.text);
                        print("Number: +20" + mobileController.text);
                        print("Password: " + passwordController.text);
                        print("Password: " + cpasswordController.text);
                        print(selectedCountryCode);
                        //signUp(fname: fnameController.text, lname: lnameController.text, mobile: mobileController.text, email: emailController.text, password: passwordController.text);
                        signUp(emailController.text!, passwordController.text!);
                       }
                    },
                    child: Container(
                      child: Text(
                        'SIGN UP',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                Image(
                  image: AssetImage('assets/images/SignUp.png'),
                  width: 200, // Set the desired width
                  height: 200, // Set the desired height
                ),
              ],
            ),
          ),
        ),
      ),
    );

  }

  String removeLeadingZeros(String input) {
    if (input.startsWith('0')) {
      return input.substring(1);
    }
    return input;
  }

  void signUp(email, pwd) {
    FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: pwd,
    )
        .then((value) {
      addUserData(value.user!.uid);
      value.user!.sendEmailVerification();
    }).catchError((error) {
      print('Error: $error');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('E-Mail Exists'),
          content: Text('E-Mail already exists'),
          actions: [
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        ),
      );
    });
    Navigator.push(
      context,
      //MaterialPageRoute(builder: (context) => LoginScreen()),
      MaterialPageRoute(builder: (context) => VerifyScreen(mail: emailController.text)),
    );

  }

  // Future addUserData(String fname, String lname, String mobile, String email, String password) async {
  //   await FirebaseFirestore.instance.collection('users').add({
  //     'fname': fname,
  //     'lname': lname,
  //     'email': email,
  //     'mobile': mobile,
  //     'password': password
  //   });
  // }


  Future addUserData(uid) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'fname': fnameController.text.trim(),
      'lname': lnameController.text.trim(),
      'email': emailController.text.trim(),
      //'mobile': mobileController.text.trim(),
      'mobile': removeLeadingZeros(mobileController.text.trim()),
      'password': passwordController.text.trim()
    });
  }


//   final citiesRef = db.collection("cities");
//
// // Create a query against the collection.
//   final query = citiesRef.where("state", isEqualTo: "CA");
}
