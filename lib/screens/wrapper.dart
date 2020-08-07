import 'package:flutter/material.dart';
import 'package:plumbing_drain/models/User.dart';
import 'package:plumbing_drain/screens/auth/auth_wrapper.dart';
import 'package:plumbing_drain/screens/home/home.dart';
import 'package:plumbing_drain/services/database.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatefulWidget {
  Wrapper({Key key}) : super(key: key);

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  bool isLoggedIn = false;
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    if (user != null) {
      return StreamProvider.value(
        child: Home(),
        value: DatabaseService(uid: user.uid).userData,
      );
    } else {
      return AuthWrapper();
    }
  }
}
