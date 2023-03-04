import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:luttas/helper/saveData.dart';

bool isLogin = false;

String Uid = "";



navTo(context,page){
  Navigator.push(context, MaterialPageRoute(builder:(context) => page, ));
}

navAndKaill(context,page){
  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder:(context) => page,), (route) => false);
}


