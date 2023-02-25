
import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:luttas/bloc/States.dart';
import 'package:luttas/bloc/cuibt.dart';
import 'package:luttas/helper/Data.dart';
import 'package:luttas/pages/login.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:record_mp3/record_mp3.dart';

import '../helper/saveData.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int index=1;
  final Record _record=Record();
  PageController c=PageController();
  String? path;
  bool isRecording = false;
  bool isUploading = false;
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
  startRecord()async{
    if (await _record.hasPermission()) {
      path =await getFilePath();
      print(path);
      // RecordMp3.instance.start(path!, (type) {
      //   setState(() {});
      // });
      await _record.start(
        path: path,
        bitRate: 128000,
        samplingRate: 44100,
        encoder: AudioEncoder.wav,
      );
      setState(() {
        isRecording=true;
      });
    }
  }

  void stopRecord() async {
    //player.stop();
    await _record.stop();
    //RecordMp3.instance.stop();
    setState(() {
      isRecording=false;
      isUploading=true;
    });
   await cubit.get(context).uploadAudio(path, index,context);
    await FirebaseFirestore.instance.collection("Users").doc(cubit.get(context).myData["id"]).update({
      "imageCompleted":cubit.get(context).myData["imageCompleted"].toInt()+1
    });
   c.nextPage(duration: Duration(milliseconds: 400), curve: Curves.linear);
   setState(() {
     isUploading=false;
   });

  }


String  getTitle(){
    if(isUploading==true){
      return "Uploading....";
    }if(isRecording==true){
      return "Recording....";
    }
      return "";

  }
  late Timer timer;

  @override
  void initState() {
    timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      c.animateToPage(cubit.get(context).myData["imageCompleted"].toInt(), duration: Duration(milliseconds: 400), curve: Curves.linear);
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
  return  BlocConsumer<cubit,MyState>(builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(onPressed: ()async{
              await CacheHelper.removeData(key: "isLogin");
              navAndKaill(context, const Login());
              await FirebaseAuth.instance.signOut();
            }, icon: Icon(Icons.logout))
          ],
          title: Text(getTitle()),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                if(isUploading==true)
                  LinearProgressIndicator(),
                SizedBox(height: 30,),
                Container(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(blurRadius: 4, spreadRadius: 4, color: Colors.grey.shade200,)]
                  ),
                  height: 250,
                  child: PageView.builder(

                    onPageChanged: (value) {
                      setState(() {
                        index=value+1;
                      });
                    },
                    controller: c,
                    allowImplicitScrolling: false,
                    physics: NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: 84,
                    itemBuilder: (context, index) =>
                        Image.asset("images/${index + 1}.jpg",fit: BoxFit.fill,),
                  ),
                ),
                SizedBox(height: 50,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(onPressed:startRecord, child: const Text("Start Record")),
                    if(isRecording==true)
                      ElevatedButton(onPressed: stopRecord, child: const Text("Finish")),
                  ],),
                SizedBox(height: 50,),
              ],
            ),
          ),
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed:isUploading==true?null: (){
        //     c.nextPage(duration: Duration(milliseconds: 400), curve: Curves.linear);
        //   },
        //   tooltip: 'Increment',
        //   child: isUploading==true?CircularProgressIndicator(color: Colors.white,): Icon(Icons.arrow_forward_ios),
        // ), // This trailing comma makes auto-formatting nicer for build methods.
      );
    }, listener: (context, state){});

  }
}
