import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plumbing_drain/models/User.dart';
import 'package:plumbing_drain/services/auth.dart';
import 'package:plumbing_drain/services/database.dart';
import 'package:plumbing_drain/shared/hexcolor.dart';
import 'package:plumbing_drain/shared/loading.dart';

class AddLeadForm extends StatefulWidget {
  final UserData data;
  AddLeadForm({Key key, this.data}) : super(key: key);

  @override
  _AddLeadFormState createState() => _AddLeadFormState();
}

class _AddLeadFormState extends State<AddLeadForm> {
  int balance = 0;
  String type;
  String address;
  String phone;
  String email;
  int price;

  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // _image = File('assets/google.png');
    balance = widget.data.balance;
    // age = widget.data.age.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: 30),
        child: () {
          if (true) {
            return SingleChildScrollView(
              child: Container(
                // color: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Job Type',
                        style: TextStyle(fontSize: 20),
                      ),
                      TextFormField(
                        onChanged: (val) {
                          setState(() {
                            type = (val);
                          });
                        },
                        validator: (val) =>
                            val.isEmpty ? "Please enter job type" : null,
                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Job Address',
                        style: TextStyle(fontSize: 20),
                      ),
                      TextFormField(
                        onChanged: (val) {
                          setState(() {
                            address = (val);
                          });
                        },
                        validator: (val) =>
                            val.isEmpty ? "Please enter job address" : null,
                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Phone',
                        style: TextStyle(fontSize: 20),
                      ),
                      TextFormField(
                        onChanged: (val) {
                          setState(() {
                            phone = (val);
                          });
                        },
                        validator: (val) =>
                            val.isEmpty ? "Please enter phone" : null,
                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Email',
                        style: TextStyle(fontSize: 20),
                      ),
                      TextFormField(
                        onChanged: (val) {
                          setState(() {
                            email = (val);
                          });
                        },
                        validator: (val) =>
                            val.isEmpty ? "Please enter email" : null,
                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Price',
                        style: TextStyle(fontSize: 20),
                      ),
                      TextFormField(
                        onChanged: (val) {
                          setState(() {
                            price = int.parse(val);
                          });
                        },
                        keyboardType: TextInputType.number,
                        validator: (val) =>
                            val.isEmpty ? "Please enter price" : null,
                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ButtonTheme(
                        height: 50.0,
                        child: RaisedButton(
                          color: themeGreen,
                          child: Container(
                            height: 30,
                            child: Center(
                              child: Text(
                                'Add Job',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              try {
                                print(balance);
                                // dynamic user = await AuthService()
                                //     .signUpWithEmailAndPassword(
                                //         email, password, username);
                                // if (user == null) {

                                await DatabaseService().addLead(widget.data.uid,
                                    type, address, phone, email, price);

                                // }
                                Navigator.of(context).pop();
                              } catch (e) {
                                print(e.toString());
                              }
                            }
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          return Center(
            child: Loading(),
          );
        }());
  }
}
