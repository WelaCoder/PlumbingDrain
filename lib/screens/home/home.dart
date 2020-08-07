import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:plumbing_drain/models/User.dart';
import 'package:plumbing_drain/screens/home/admin/admin_profile.dart';
import 'package:plumbing_drain/screens/home/admin/edit_admin_profile.dart';
import 'package:plumbing_drain/screens/home/customer/customer_profile.dart';
import 'package:plumbing_drain/services/auth.dart';
import 'package:plumbing_drain/services/database.dart';
import 'package:plumbing_drain/shared/hexcolor.dart';
import 'package:plumbing_drain/shared/loading.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List customers = [1, 2, 3, 4, 5];
  @override
  Widget build(BuildContext context) {
    UserData data = Provider.of<UserData>(context);
    void _showSettingsPanel() {
      showModalBottomSheet(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0)),
          ),
          isScrollControlled: true,
          context: context,
          builder: (context) {
            return Container(
              margin: MediaQuery.of(context).viewInsets,
              child: EditAdminProfile(
                data: data,
              ),
            );
          });
    }

    return data == null
        ? Loading()
        : data.role == "admin"
            ? AdminProfile()
            : CustomerProfile(customer: data);
  }
}
