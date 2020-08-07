import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:plumbing_drain/models/User.dart';
import 'package:plumbing_drain/screens/home/admin/add_lead_form.dart';
import 'package:plumbing_drain/screens/home/admin/edit_admin_profile.dart';
import 'package:plumbing_drain/screens/home/admin/edit_customer_profile.dart';
import 'package:plumbing_drain/screens/home/admin/lead_show.dart';
import 'package:plumbing_drain/services/database.dart';
import 'package:plumbing_drain/shared/hexcolor.dart';
import 'package:plumbing_drain/shared/loading.dart';
import 'package:provider/provider.dart';

class ShowCustomerProfile extends StatefulWidget {
  final customer;
  ShowCustomerProfile({Key key, this.customer}) : super(key: key);

  @override
  _ShowCustomerProfileState createState() => _ShowCustomerProfileState();
}

class _ShowCustomerProfileState extends State<ShowCustomerProfile> {
  List leads = [];
  StreamSubscription customerStream;
  StreamSubscription leadsStream;
  UserData customer;
  @override
  void initState() {
    customerStream = DatabaseService(uid: widget.customer.documentID)
        .userData
        .listen((event) {
      setState(() {
        customer = event;
      });
    });
    leadsStream = DatabaseService(currentCustomer: widget.customer.documentID)
        .leads
        .listen((event) {
      setState(() {
        leads = event;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    customerStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // var user = Provider.of<UserData>(context);
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
              child: EditCustomerProfile(
                data: customer,
              ),
            );
          });
    }

    void _showAddLeadPanel() {
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
              child: AddLeadForm(
                data: customer,
              ),
            );
          });
    }

    return customer == null
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
                                  customer.image ?? placeholderImage),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                customer.username ?? '',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 26),
                              ),
                              Text(
                                customer.role.toString() ?? '',
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
                                    customer.balance.toString() ?? '',
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
                        'Jobs',
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 26),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      leads == null
                          ? Loading()
                          : Flexible(
                              flex: 1,
                              child: ListView.builder(
                                itemCount: leads.length + 1,
                                itemBuilder: (BuildContext ctxt, int index) {
                                  if (index == 0) {
                                    return Center(
                                      child: FloatingActionButton(
                                        onPressed: () {
                                          _showAddLeadPanel();
                                        },
                                        child: Icon(Icons.add),
                                        backgroundColor: themeGreen,
                                      ),
                                    );
                                  }
                                  return Container(
                                    margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                    child: GestureDetector(
                                      onTap: () {
                                        print('hi');
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => LeadShow(
                                                lead: leads[index - 1],
                                                customer: widget.customer),
                                          ),
                                        );
                                      },
                                      child: Material(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        elevation: 4,
                                        child: Container(
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                8, 14, 8, 14),
                                            child: Row(
                                              children: <Widget>[
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      leads[index - 1]
                                                          .data['type'],
                                                      style: TextStyle(
                                                          fontSize: 20),
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                      '\$' +
                                                          leads[index - 1]
                                                              .data['price']
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
