import 'package:flutter/material.dart';
import 'package:plumbing_drain/screens/auth/login/login.dart';
import 'package:plumbing_drain/screens/auth/signup/signup.dart';

class AuthWrapper extends StatefulWidget {
  AuthWrapper({Key key}) : super(key: key);

  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool showSignIn = true;
  void setShowSignIn(val) {
    // print(val);
    setState(() {
      showSignIn = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return showSignIn
        ? Login(
            setShowSignIn: setShowSignIn,
          )
        : SignUp(
            setShowSignIn: setShowSignIn,
          );
  }
}
