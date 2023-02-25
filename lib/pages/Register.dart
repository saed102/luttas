import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:luttas/bloc/States.dart';
import 'package:luttas/bloc/cuibt.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController date = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  String gender = "";
  bool isLogin = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<cubit, MyState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                    size: 30,
                  )),
            ),
            backgroundColor: Colors.white,
            body: Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(mainAxisSize: MainAxisSize.max, children: [
                  Image.asset(
                    "images/splash.jpg",
                    width: 150,
                    height: 150,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    onTap: () {},
                    controller: name,
                    decoration: InputDecoration(
                      label: const Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: Text("Name"),
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
                    controller: date,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      label: const Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: Text("Date"),
                      ),
                      border: OutlineInputBorder(
                          borderSide: const BorderSide(),
                          borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
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
                  DropdownButtonFormField(
                      borderRadius: BorderRadius.circular(14),
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14))),
                      hint: const Text("Gender"),
                      items: const [
                        DropdownMenuItem(
                          child: Text("Male"),
                          value: "Male",
                        ),
                        DropdownMenuItem(
                          child: Text("Female"),
                          value: "Female",
                        ),
                      ],
                      onChanged: (v) {
                        gender = v!;
                        print(gender);
                      }),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        isLogin=true;
                      });
                     await cubit.get(context).createAccount(email.text, pass.text, name.text, date.text, gender, context);
                      setState(() {
                        isLogin=false;
                      });
                      },
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14))),
                        fixedSize: MaterialStateProperty.all(
                            Size(MediaQuery.of(context).size.width, 54))),
                    child: isLogin
                        ? const Center(
                            child: CircularProgressIndicator(
                            color: Colors.white,
                          ))
                        : Text(
                            "Register".toUpperCase(),
                            style: const TextStyle(
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
        },
        listener: (context, state) {});
  }
}
