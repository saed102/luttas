import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:luttas/pages/Register.dart';
import 'package:luttas/bloc/States.dart';
import 'package:luttas/bloc/cuibt.dart';

import '../helper/consts.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  bool isLogin = false;

  var key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<cubit, MyState>(
        builder: (context, state) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              backgroundColor: Colors.white,
              body: Padding(
                padding: const EdgeInsets.only(
                    top: 50.0, bottom: 20, left: 20, right: 20),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Form(
                    key: key,
                    child: Column(mainAxisSize: MainAxisSize.max, children: [
                      InkWell(
                        onTap: () {
                          cubit.get(context).g();
                        },
                        child: Image.asset(
                          "images/splash.jpg",
                          width: 200,
                          height: 200,
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "ادخل الاميل من فضلك";
                          }
                        },
                        controller: email,
                        decoration: InputDecoration(
                          label: const Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Text("الاميل"),
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
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "ادخل كلمةالسر من فضلك";
                          }
                        },
                        controller: pass,
                        decoration: InputDecoration(
                          label: const Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Text("كلمة السر"),
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
                          if (key.currentState!.validate()) {
                            setState(() {
                              isLogin = true;
                            });
                            await cubit.get(context).userLogin(
                                email: email.text,
                                password: pass.text,
                                context: context);
                            setState(() {
                              isLogin = false;
                            });
                          }
                        },
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14))),
                            fixedSize: MaterialStateProperty.all(
                                Size(MediaQuery.of(context).size.width, 54))),
                        child: isLogin
                            ? Center(
                                child: CircularProgressIndicator(
                                color: Colors.white,
                              ))
                            : Text(
                                "دخول".toUpperCase(),
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text("ليس لديك حساب ؟"),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          navTo(context, Register());
                        },
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14))),
                            fixedSize: MaterialStateProperty.all(
                                Size(MediaQuery.of(context).size.width, 54))),
                        child: Text(
                          "الاشتراك".toUpperCase(),
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
              ),
            ),
          );
        },
        listener: (context, state) {});
  }
}
