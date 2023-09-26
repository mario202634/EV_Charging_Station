import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:flutter/material.dart';

class StationModel  {
  //Geoposition? location;
  String? name;
  String? stationId;


  StationModel ({
    //required this.location,
    required this.name,
    required this.stationId,

  });

  // Map<String, dynamic> fromJson() {
  //   return {
  //     'location': location,
  //     'name': name,
  //     'stationId': stationId
  //   };
  // }

  StationModel.fromJson(Map<String, dynamic> json) {
    //location = json['location'];
    name = json['name'];
    stationId = json['stationId'];
  }


  Map<String, dynamic> toMap() {
    return {
      //'location' : location,
      'name' : name,
      'stationId' : stationId,
    };
  }

}