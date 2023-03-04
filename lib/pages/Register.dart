import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
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
  var key = GlobalKey<FormState>();
  String _country="";

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<cubit, MyState>(
        builder: (context, state) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              appBar: AppBar(
                toolbarHeight: 30,
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
                  child: Form(
                    key: key,
                    child: Column(mainAxisSize: MainAxisSize.max, children: [
                      Image.asset(
                        "images/splash.jpg",
                        width: 200,
                        height: 200,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "ادخل الاسم من فضلك";
                          }
                        },                      controller: name,
                        decoration: InputDecoration(
                          label: const Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Text("الاسم"),
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
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "ادخل العمر من فضلك";
                          }
                        },
                        controller: date,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          label: const Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Text("العمر"),
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
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "ادخل كلمة السر من فضلك";
                          }
                        },                      controller: pass,
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
                      InkWell(
                        onTap: () {
                          showCountryPicker(
                            context: context,
                            countryListTheme: CountryListThemeData(
                              flagSize: 25,
                              backgroundColor: Colors.white,
                              textStyle: TextStyle(fontSize: 16, color: Colors.blueGrey),
                              bottomSheetHeight: 500, // Optional. Country list modal height
                              //Optional. Sets the border radius for the bottomsheet.
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20.0),
                                topRight: Radius.circular(20.0),
                              ),
                              //Optional. Styles the search field.
                              inputDecoration: InputDecoration(
                                labelText: 'Search',
                                hintText: 'Start typing to search',
                                prefixIcon: const Icon(Icons.search),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: const Color(0xFF8C98A8).withOpacity(0.2),
                                  ),
                                ),
                              ),
                            ),
                            onSelect: (Country country) {
                              setState(() {
                                _country=country.name;
                              });
                              print('Select country: ${_country}');
                            },
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 17,horizontal: 10),
                          child:Row(children: [
                            Expanded(child: Text(_country!=""?_country:"الجنسية")),
                            Icon(Icons.arrow_drop_down)
                          ]),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Colors.grey)
                          ),
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
                          hint: const Text("النوع"),
                          items: const [
                            DropdownMenuItem(
                              child: Text("ذكر"),
                              value: "ذكر",
                            ),
                            DropdownMenuItem(
                              child: Text("انثي"),
                              value: "انثي",
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
                            if(key.currentState!.validate()){
                              if(gender.isNotEmpty && _country.isNotEmpty){
                                setState(() {
                                  isLogin=true;
                                });
                                await cubit.get(context).createAccount(email.text, pass.text, name.text, date.text, gender,_country, context);
                                setState(() {
                                  isLogin=false;
                                });
                              }else{
                                cubit.get(context).showMessage(context, "اكمل البيانات من فضلك", Colors.red);
                              }

                            }



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
                                "تسجيل".toUpperCase(),
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
              ),
            ),
          );
        },
        listener: (context, state) {});
  }
}
