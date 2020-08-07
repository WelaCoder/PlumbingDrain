import 'dart:async';
import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:plumbing_drain/models/User.dart';
import 'package:plumbing_drain/screens/home/admin/edit_admin_profile.dart';
import 'package:plumbing_drain/screens/home/admin/show_customer_profile.dart';
import 'package:plumbing_drain/services/auth.dart';
import 'package:plumbing_drain/services/database.dart';
import 'package:plumbing_drain/shared/hexcolor.dart';
import 'package:plumbing_drain/shared/loading.dart';
import 'package:provider/provider.dart';

class AdminProfile extends StatefulWidget {
  AdminProfile({Key key}) : super(key: key);

  @override
  _AdminProfileState createState() => _AdminProfileState();
}

class _AdminProfileState extends State<AdminProfile> {
  List customers;
  StreamSubscription customersStream;

  @override
  void initState() {
    super.initState();
    customersStream = DatabaseService().customers.listen((event) {
      setState(() {
        customers = event;
      });
    });
  }

  @override
  void dispose() {
    customersStream.cancel();
    super.dispose();
  }

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
        : Container(
            color: themeGreen,
            child: SafeArea(
              child: Scaffold(
                body: Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  color: HexColor('#fdfdfd'),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: themeGreen,
                            child: CircleAvatar(
                              radius: 48,
                              backgroundImage: CachedNetworkImageProvider(
                                  data.image ?? placeholderImage),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                data.username ?? '',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 26),
                              ),
                              Text(
                                data.role ?? '',
                                style:
                                    TextStyle(color: themeGrey, fontSize: 20),
                              ),
                            ],
                          ),
                          Expanded(
                            child: Container(),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.edit,
                              color: themeGreen,
                            ),
                            onPressed: () {
                              _showSettingsPanel();
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Container(
                          constraints: BoxConstraints(
                              minHeight: 50, minWidth: 50, maxWidth: 200),
                          child: Material(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            elevation: 3,
                            child: Container(
                              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Icon(
                                    Icons.attach_money,
                                    color: themeGreen,
                                  ),
                                  Text(
                                    data.balance.toString() ?? '',
                                    style: TextStyle(fontSize: 20),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Customers',
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 26),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      customers == null
                          ? Loading()
                          : Flexible(
                              flex: 1,
                              child: ListView.builder(
                                itemCount: customers.length,
                                itemBuilder: (BuildContext ctxt, int i) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ShowCustomerProfile(
                                                  customer: customers[i]),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      margin:
                                          EdgeInsets.fromLTRB(10, 10, 10, 10),
                                      child: Material(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        elevation: 4,
                                        child: Container(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: <Widget>[
                                                CircleAvatar(
                                                  radius: 40,
                                                  backgroundImage:
                                                      CachedNetworkImageProvider(
                                                          customers[i].data[
                                                                  'image'] ??
                                                              placeholderImage),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      customers[i].data[
                                                              'username'] ??
                                                          '',
                                                      style: TextStyle(
                                                          fontSize: 20),
                                                    ),
                                                    Text(
                                                      '\$' +
                                                          customers[i]
                                                              .data['balance']
                                                              .toString(),
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          color: themeGrey),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
