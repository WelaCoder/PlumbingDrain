import 'package:flutter/material.dart';
import 'package:plumbing_drain/services/auth.dart';
import 'package:plumbing_drain/shared/hexcolor.dart';
import 'package:plumbing_drain/shared/loading.dart';

class SignUp extends StatefulWidget {
  final Function setShowSignIn;
  SignUp({Key key, this.setShowSignIn}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String username = "";
  String email = "";
  String password = "";
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Material(
        color: themeGreen,
        child: SafeArea(
          child: Container(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(20),
                    width: double.maxFinite,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                print('tap');
                              },
                              child: Container(
                                padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                                child: Container(
                                  padding: EdgeInsets.only(bottom: 8),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              width: 1, color: Colors.white))),
                                  child: Text(
                                    'Sign Up',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                print('tap');
                                widget.setShowSignIn(true);
                              },
                              child: Container(
                                padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                                child: Container(
                                  // padding: EdgeInsets.only(bottom: 8),
                                  child: Text(
                                    'Sign In',
                                    style: TextStyle(
                                        color: Colors.grey[400], fontSize: 20),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Text(
                          'Hey, get on board,',
                          style: TextStyle(color: Colors.white, fontSize: 30),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Sign up to continue',
                          style:
                              TextStyle(color: Colors.grey[400], fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(30, 30, 30, 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      color: Colors.white,
                    ),
                    width: double.maxFinite,
                    height: 450,
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Username',
                              style: TextStyle(fontSize: 20),
                            ),
                            TextFormField(
                              onChanged: (val) {
                                setState(() {
                                  username = val;
                                });
                              },
                              validator: (val) => val.isEmpty
                                  ? "Please enter a username"
                                  : null,
                              decoration: InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Email',
                              style: TextStyle(fontSize: 20),
                            ),
                            TextFormField(
                              onChanged: (val) {
                                setState(() {
                                  email = val;
                                });
                              },
                              validator: (val) =>
                                  val.isEmpty ? "Please enter an email" : null,
                              decoration: InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Password',
                              style: TextStyle(fontSize: 20),
                            ),
                            TextFormField(
                              onChanged: (val) {
                                setState(() {
                                  password = val;
                                });
                              },
                              validator: (val) => val.isEmpty
                                  ? "Please enter a password atleast 6 char long"
                                  : null,
                              decoration: InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                              ),
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
                                            'SIGN UP',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18),
                                          ),
                                        ),
                                      ),
                                      onPressed: () async {
                                        if (_formKey.currentState.validate()) {
                                          try {
                                            setState(() {
                                              loading = true;
                                            });
                                            print(email);
                                            print(password);
                                            dynamic user = await AuthService()
                                                .signUpWithEmailAndPassword(
                                                    email, password, username);
                                            if (user == null) {
                                              setState(() {
                                                loading = false;
                                              });
                                            }
                                          } catch (e) {
                                            setState(() {
                                              loading = false;
                                            });
                                          }
                                        }
                                      },
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
