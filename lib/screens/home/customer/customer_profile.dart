import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:plumbing_drain/models/User.dart';
import 'package:plumbing_drain/screens/home/admin/edit_admin_profile.dart';
import 'package:plumbing_drain/screens/home/admin/lead_show.dart';
import 'package:plumbing_drain/screens/home/customer/update_customer_profile.dart';
import 'package:plumbing_drain/services/database.dart';
import 'package:plumbing_drain/shared/hexcolor.dart';
import 'package:plumbing_drain/shared/loading.dart';
import 'package:provider/provider.dart';

class CustomerProfile extends StatefulWidget {
  final customer;
  CustomerProfile({Key key, this.customer}) : super(key: key);

  @override
  _CustomerProfileState createState() => _CustomerProfileState();
}

class _CustomerProfileState extends State<CustomerProfile> {
  List customers = [1, 2, 3, 4, 5];
  List leads;
  StreamSubscription leadsStream;
  UserData customer;
  @override
  void initState() {
    leadsStream = DatabaseService(currentCustomer: widget.customer.uid)
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
    leadsStream.cancel();
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
              child: UpdateCustomerProfile(
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
                                itemCount: leads.length,
                                itemBuilder: (BuildContext ctxt, int index) {
                                  return Container(
                                    margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                    child: GestureDetector(
                                      onTap: () {
                                        print('hi');
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => LeadShow(
                                              lead: leads[index],
                                            ),
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
                                                      leads[index].data['type'],
                                                      style: TextStyle(
                                                          fontSize: 20),
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                      '\$' +
                                                          leads[index]
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
