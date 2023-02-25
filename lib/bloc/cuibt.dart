import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:luttas/helper/Data.dart';
import 'package:luttas/pages/Home.dart';
import 'package:luttas/bloc/States.dart';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:luttas/helper/saveData.dart';


class cubit extends Cubit<MyState>{
  cubit() : super(InitState());

  static cubit get(context) => BlocProvider.of(context);

  showMessage(context, ms, backGround) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: backGround,
        content: Row(
          children: [
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                ms,
              ),
            ),
          ],
        )));
  }

  createAccount(email, password, name, age, gender, context) async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) async {
      Uid=value.user!.uid;
      await setDataUser(email, name, age, gender,value.user!.uid, context);
      await getDataUser(value.user!.uid);
      showMessage(context, "Successful login", Colors.green);
      navAndKaill(context, Home());
      await CacheHelper.saveData(key: "isLogin", value: true);
      await CacheHelper.saveData(key: "myId", value: value.user!.uid);
    })
        .catchError((error) {
      showMessage(context, "${error.message.toString()}", Colors.red);
    });
  }


  increaseNumOfUser(v)async{
    await FirebaseFirestore.instance.collection("NumOfUsers").doc("1").update({
      "NumOfUser":v,
    });
  }

  setDataUser(email, name, age, gender,id, context)async{
    var userId = await getUserId()+1;
    await increaseNumOfUser(userId+1);
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(id)
        .set({
      "name": name,
      "email": email,
      "age": age,
      "gender": gender,
      "userId": userId,
      "id": id,
      "imageCompleted": 0,
    })
        .then((value) {})
        .catchError((error) {
      showMessage(context, "${error.message.toString()}", Colors.red);
    });
  }

  userLogin(
      { required String email,
        required String password,
        required BuildContext context}) async {

    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) async {
          Uid=value.user!.uid;
       await getDataUser(value.user!.uid);
       showMessage(context, "Successful login", Colors.green);
          navAndKaill(context, Home());
       await CacheHelper.saveData(key: "isLogin", value: true);
       await CacheHelper.saveData(key: "myId", value: value.user!.uid);
    }).catchError((error) {
      showMessage(context, "${error.message.toString()}", Colors.red);
    });
  }

  Map<String,dynamic> myData={};

  getDataUser(String id) async{
    if (id.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(id)
          .get()
          .then((value) {
        myData = value.data()!;
        print(myData);
      });
    }
  }



  Future<int> getUserId() async {
    var res = await FirebaseFirestore.instance
        .collection("NumOfUsers")
        .doc("1")
        .get();
    return res.data()!["NumOfUser"].toInt();
  }

  Future<int> getTotalUsers() async {
    var rsp = await FirebaseFirestore.instance
        .collection("TotalUsers")
        .doc("1")
        .get();
    int j = rsp.data()!["total"];
    return j;
  }

  uploadAudio(path, index, context) async {
    await firebase_storage.FirebaseStorage.instance
        .ref()
        .child("$index/${Uri.file(path).pathSegments.last}")
        .putFile(File(path))
        .then((p0) {
      p0.ref.getDownloadURL().then((value) async {
        await FirebaseFirestore.instance
            .collection("Audios")
            .doc("${index}_${myData["userId"]}")
            .set({
          "UserId": myData["userId"],
          "ImageId": index,
          "Audio": value,
        });
      }).catchError((error) {
        showMessage(context, "${error.message.toString()}", Colors.red);
      });
    });
  }

}