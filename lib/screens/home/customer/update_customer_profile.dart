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

class UpdateCustomerProfile extends StatefulWidget {
  final UserData data;
  UpdateCustomerProfile({Key key, this.data}) : super(key: key);

  @override
  _UpdateCustomerProfileState createState() => _UpdateCustomerProfileState();
}

class _UpdateCustomerProfileState extends State<UpdateCustomerProfile> {
  Future getImage() async {
    try {
      final pickedFile = await picker.getImage(source: ImageSource.gallery);
      setState(() {
        try {
          _image = File(pickedFile.path);
          filename =
              (_image.path.split('/')[_image.path.split('/').length - 1]);
        } catch (e) {
          print(e.toString());
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }

  final StorageReference storageReference = FirebaseStorage().ref().child('');
  Future uploadFile() async {
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child('chats/${widget.data.uid}}');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    print('File Uploaded');
    String fileURL = await storageReference.getDownloadURL();
    setState(() {
      _uploadedFileURL = fileURL;
    });
  }

  File _image;
  final picker = ImagePicker();
  var _uploadedFileURL;
  String filename;
  String username = '';
  String firstnameError = '';
  String image;
  int balance = 0;

  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // _image = File('assets/google.png');
    username = widget.data.username;
    image = widget.data.image;
    balance = widget.data.balance;
    // age = widget.data.age.toString();
    _uploadedFileURL = widget.data.image;
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
                      Center(
                        child: GestureDetector(
                          onTap: () async {
                            print('tap');
                            await getImage();
                          },
                          child: CircleAvatar(
                            radius: 55,
                            backgroundColor: themeGreen,
                            child: _image == null
                                ? CircleAvatar(
                                    radius: 53,
                                    backgroundImage: CachedNetworkImageProvider(
                                        widget.data.image ?? placeholderImage),
                                  )
                                : new CircleAvatar(
                                    backgroundImage: new FileImage(_image),
                                    radius: 53.0,
                                  ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Username',
                        style: TextStyle(fontSize: 20),
                      ),
                      TextFormField(
                        initialValue: widget.data.username,
                        onChanged: (val) {
                          setState(() {
                            username = val;
                          });
                        },
                        validator: (val) =>
                            val.isEmpty ? "Please enter a username" : null,
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
                      loading == true
                          ? Container(
                              margin: EdgeInsets.only(top: 20),
                              child: Loading(),
                            )
                          : ButtonTheme(
                              height: 50.0,
                              child: RaisedButton(
                                color: themeGreen,
                                child: Container(
                                  height: 30,
                                  child: Center(
                                    child: Text(
                                      'UPDATE',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    ),
                                  ),
                                ),
                                onPressed: () async {
                                  if (_formKey.currentState.validate()) {
                                    try {
                                      setState(() {
                                        loading = true;
                                      });
                                      print(username);
                                      print(balance);
                                      // dynamic user = await AuthService()
                                      //     .signUpWithEmailAndPassword(
                                      //         email, password, username);
                                      // if (user == null) {
                                      if (_image != null) {
                                        await uploadFile();
                                        setState(() {
                                          image = _uploadedFileURL;
                                        });
                                      }
                                      await DatabaseService(
                                              uid: widget.data.uid)
                                          .updateAdminData(
                                              username, image, balance);
                                      setState(() {
                                        loading = false;
                                      });
                                      Navigator.of(context).pop();
                                      // }
                                    } catch (e) {
                                      setState(() {
                                        loading = false;
                                      });
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
                      ButtonTheme(
                        height: 50.0,
                        child: RaisedButton(
                          color: Colors.white,
                          child: Container(
                            height: 30,
                            child: Center(
                              child: Text(
                                'SIGN OUT',
                                style:
                                    TextStyle(color: themeGreen, fontSize: 18),
                              ),
                            ),
                          ),
                          onPressed: () async {
                            AuthService().signOut();
                            Navigator.of(context).pop();
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(10.0),
                          ),
                        ),
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
