import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:luttas/pages/Register.dart';
import 'package:luttas/bloc/States.dart';
import 'package:luttas/bloc/cuibt.dart';

import '../helper/Data.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  bool isLogin=false;
  @override
  Widget build(BuildContext context) {


    return BlocConsumer<cubit,MyState>(builder: (context, state) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding:
          const EdgeInsets.only(top: 50.0, bottom: 20, left: 20, right: 20),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(mainAxisSize: MainAxisSize.max, children: [
              Image.asset(
                "images/splash.jpg",
                width: 150,
                height: 150,
              ),
              const SizedBox(
                height: 50,
              ),

              TextFormField(
                onTap: () {},
                controller: email,
                decoration: InputDecoration(
                  label: const Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text("Email"),
                  ),
                  border: OutlineInputBorder(
                      borderSide: const BorderSide(),
                      borderRadius: BorderRadius.circular(14)),
                ),
              ),
              const SizedBox(
                height: 20,
              ),

              TextFormField(
                keyboardType: TextInputType.visiblePassword,
                onTap: () {},
                controller: pass,
                decoration: InputDecoration(
                  label: const Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text("Password"),
                  ),
                  border: OutlineInputBorder(
                      borderSide: const BorderSide(),
                      borderRadius: BorderRadius.circular(14)),
                ),
              ),
              const SizedBox(
                height: 20,
              ),

              ElevatedButton(
                onPressed: () async {
                setState(() {
                  isLogin=true;
                });
                await cubit.get(context).userLogin(email: email.text, password: pass.text, context: context);
                setState(() {
                  isLogin=false;
                });
                },
                style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14))),
                    fixedSize: MaterialStateProperty.all(
                        Size(MediaQuery.of(context).size.width, 54))),
                child:isLogin?Center(child: CircularProgressIndicator(color: Colors.white,)):  Text(
                  "Login".toUpperCase(),
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text("Don't Have Account"),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () async {
                   navTo(context, Register());
                },
                style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14))),
                    fixedSize: MaterialStateProperty.all(
                        Size(MediaQuery.of(context).size.width, 54))),
                child:  Text(
                  "Register".toUpperCase(),
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),

              const SizedBox(
                height: 50,
              ),
            ]),
          ),
        ),
      );

    }, listener: (context, state) {});
  }
}
