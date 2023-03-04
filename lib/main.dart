
import 'package:country_picker/country_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:luttas/bloc/States.dart';
import 'package:luttas/bloc/cuibt.dart';
import 'package:luttas/helper/saveData.dart';
import 'package:luttas/pages/splash.dart';
import 'helper/consts.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await CacheHelper.init_shared();

  isLogin= await CacheHelper.getData(key:"isLogin")??false;
  Uid= await CacheHelper.getData(key:"myId")??"";



  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) =>cubit()..getDataUser(Uid),
    child: BlocConsumer<cubit,MyState>(builder: (context, state) {
      return MaterialApp(
        supportedLocales: const [
          Locale('ar'),
        ],
        localizationsDelegates: const [
          CountryLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,

        ],
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(



          primarySwatch: Colors.blue,
        ),
        home: Splash(),
      );

    }, listener:  (context, state){}),
    );
  }
}

