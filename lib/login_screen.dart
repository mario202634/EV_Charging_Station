import 'dart:ffi';
import 'package:ev_charging_station_finder_1_0/map_screen.dart';
import 'package:ev_charging_station_finder_1_0/map_test_screen.dart';
import 'package:ev_charging_station_finder_1_0/reset_password_screen.dart';
import 'package:ev_charging_station_finder_1_0/side_bar.dart';
import 'package:ev_charging_station_finder_1_0/signup_screen.dart';
import 'package:ev_charging_station_finder_1_0/testing_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hexcolor/hexcolor.dart';

class LoginScreen extends StatefulWidget
{
  const LoginScreen({Key?key}) : super(key:key); //to know why

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  bool _obscureText = true;
  final _formKey = GlobalKey<FormState>();

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
          'Login'
        ),
        centerTitle: true,
        automaticallyImplyLeading: false, // Hide the back button
      ),

     //drawer: SideBar(),

      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text(
                //     'Login',
                //   style: TextStyle(
                //     fontSize: 30.0,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
                Image(
                  image: AssetImage('assets/images/login2.png'),
                  width: 250, // Set the desired width
                  height: 250, // Set the desired height
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
                    if (value!.isEmpty) {
                      return 'Please enter an email address';
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
                    if (value!.length == 0) {
                      return 'Please enter password';
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
                      if (_formKey.currentState!.validate())
                      {
                        print(emailController.text);
                        print(passwordController.text);
                        logIn();
                        print('Logged in');
                        MaterialPageRoute(builder: (context) => MapScreen());
                      }
                    },
                    child: Container(
                      child: Text(
                        'LOGIN',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '',
                    ),
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
                          color: HexColor("#3f1651"),
                        ),
                      ),
                    )
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Do not have an account?',
                    ),
                    TextButton(
                      onPressed: () {
                        // add your navigation function here
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignupScreen()),
                        );
                      },
                      child: Text(
                        'SIGNUP',
                        style: TextStyle(
                          color: HexColor("#3f1651"),
                        ),
                      ),
                    )
                  ],
                )

              ],
            ),
          ),
        ),
      ),
    );
  }

 Future logIn() async {
  await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim()).then((value) {
          if(value.user!.emailVerified == false)
          {
            print('email still not verified');
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Not Verified'),
                content: Text('Please verify your account'),
                actions: [
                  TextButton(
                    child: Text('Ok'),
                    onPressed: () {
                      Navigator.pop(context);
                      // Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginScreen()));

                    },
                  )
                ],
              ),
            );
          }
    if(value.user!.emailVerified == true)
      {
        print('email is verified');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TestingScreen()),
        );
      }
  }).catchError((onError) {
    print('Error: $onError');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Wrong Credentials'),
        content: Text('E-Mail or Password are incorrect'),
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

  //Navigator.push(context, MaterialPageRoute(builder: (context) => MapTestScreen()),);
  }


  // Future logIn() async {
  // await FirebaseAuth.instance.signInWithEmailAndPassword(
  // email: emailController.text.trim(),
  // password: passwordController.text.trim());
  // Navigator.push(context, MaterialPageRoute(builder: (context) => MapTestScreen()),);
  // }

 @override //for better memory efficiency
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

}
