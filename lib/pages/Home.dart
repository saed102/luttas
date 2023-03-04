import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:luttas/bloc/States.dart';
import 'package:luttas/bloc/cuibt.dart';
import 'package:luttas/helper/consts.dart';
import 'package:luttas/pages/login.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

import '../helper/saveData.dart';

var p = PageStorageBucket();

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int index = 1;
  final Record _record = Record();
  PageController c = PageController();
  String? path;
  bool isRecording = false;
  bool isUploading = false;
  bool isClick = false;
  late Directory appDirectory;

  Future<String> getFilePath() async {
    Directory storageDirectory = await getApplicationDocumentsDirectory();
    String sdPath =
        "${storageDirectory.path}/record${DateTime.now().microsecondsSinceEpoch}.acc";
    var d = Directory(sdPath);
    if (!d.existsSync()) {
      d.createSync(recursive: true);
    }
    return "$sdPath/${index}_${cubit.get(context).myData["userId"]}.wav";
  }

  startRecord() async {
    if (await _record.hasPermission()) {
      path = await getFilePath();
      print(path);
      setState(() {
        isRecording = true;
      });
      await _record.start(
        path: path,
        bitRate: 128000,
        samplingRate: 44100,
        encoder: AudioEncoder.wav,
      );
    }
  }

  void stopRecord() async {
    await _record.stop();
    setState(() {
      isRecording = false;
      isUploading = true;
    });

    showLoading();

    await cubit.get(context).uploadAudio(path, index, context);

    Navigator.pop(context);

    setState(() {
      isUploading = false;
    });


    c.nextPage(
        duration: const Duration(milliseconds: 400), curve: Curves.linear);
  }

  showLoading() {
    showDialog(
      barrierDismissible: false,
      useRootNavigator: false,
      useSafeArea: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            CircularProgressIndicator(),
            SizedBox(
              width: 10,
            ),
            Expanded(
                child: Text(
                  "الرجاء الانتظار جارى تحميل الصوت المسجل....",
                  textDirection: TextDirection.rtl,
                )),
          ]),
          elevation: 10,
        );
      },
    );
  }

  String getTitle() {
    if (isUploading == true) {
      return "جاري رفع الصوت....";
    }
    if (isRecording == true) {
      return "جاري التسجيل لان....";
    }
    return "";
  }

  late Timer timer;

  @override
  void initState() {
    timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      c.animateToPage(cubit.get(context).myData["imageCompleted"].toInt(),
          duration: const Duration(milliseconds: 400), curve: Curves.linear);
      timer.cancel();
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<cubit, MyState>(
        builder: (context, state) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              appBar: AppBar(
                actions: [
                  IconButton(
                      onPressed: () async {
                        await CacheHelper.removeData(key: "isLogin");
                        navAndKaill(context, const Login());
                        await FirebaseAuth.instance.signOut();
                      },
                      icon: const Icon(Icons.logout))
                ],
                title: Text(getTitle()),
              ),
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        if (isUploading == true)
                          const LinearProgressIndicator(),
                        const SizedBox(
                          height: 30,
                        ),
                        InkWell(
                          onTap: () {},
                          child: Container(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 4,
                                    spreadRadius: 4,
                                    color: Colors.grey.shade200,
                                  )
                                ]),
                            height: 250,
                            child: PageStorage(
                              bucket: p,
                              child: PageView.builder(
                                key: PageStorageKey<String>("1"),
                                onPageChanged: (value) {
                                  setState(() {
                                    index = value + 1;
                                  });
                                },
                                controller: c,
                                allowImplicitScrolling: false,
                                physics: const NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                itemCount: 84,
                                itemBuilder: (context, index) => Image.asset(
                                  "images/${index + 1}.jpg",
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        if (isRecording == true)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.0),
                            child: Text(
                              "عند الانتهاء من التسجيل النقر على رز (انتهاء) والانتظار حتى يتم رفع الصوت والانتقال الى الصورة التالية",
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        if (isRecording == false)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.0),
                            child: Text(
                              "لتسجيل نطق الكلمة الموجودة بالصورة رجاء النقر على رز (تسجيل)",
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            if (isRecording == false && isUploading == false)
                              ElevatedButton(
                                  onPressed: startRecord,
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15.0),
                                    child: Text(
                                      "تسجيل",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )),
                            if (isRecording == true)
                              ElevatedButton(
                                  onPressed: stopRecord,
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15.0),
                                    child: Text(
                                      "انتهاء",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )),
                          ],
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        listener: (context, state) {});
  }
}
