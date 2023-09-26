import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';


class User_Model  {
  String id;
  String fname;
  String lname;
  String email;
  String mobile;
  String password;

  User_Model ({
    this.id = '',
    required this.fname,
    required this.lname,
    required this.email,
    required this.mobile,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fname': fname,
      'lname': lname,
      'email': email,
      'mobile': mobile,
      'password': password,
    };
  }

  // static User_Model  fromJson(Map<String, dynamic> json) => User_Model (
  //     fname: json['fname'],
  //     lname: json['lname'],
  //     email: json['email'],
  //     mobile: json['mobile'],
  //     password: json['password']
  // );


  Map<String, dynamic> toMap() {
    return {
      'fname': fname,
      'lname': lname,
      'email': email,
      'mobile': mobile,
      'password': password,
    };
  }

}