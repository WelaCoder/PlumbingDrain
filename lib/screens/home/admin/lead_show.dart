import 'package:flutter/material.dart';
import 'package:plumbing_drain/models/User.dart';
import 'package:plumbing_drain/services/database.dart';
import 'package:provider/provider.dart';

class LeadShow extends StatefulWidget {
  final lead;
  var customer;
  LeadShow({Key key, this.lead, this.customer}) : super(key: key);

  @override
  _LeadShowState createState() => _LeadShowState();
}

class _LeadShowState extends State<LeadShow> {
  List months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  @override
  Widget build(BuildContext context) {
    // var user = Provider.of<UserData>(context);
    return Scaffold(
      body: Center(
        child: Material(
          borderRadius: BorderRadius.circular(20),
          elevation: 10,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  widget.lead.data['type'],
                  style: TextStyle(fontSize: 26),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  widget.lead.data['time'].toDate().day.toString() +
                      ' ' +
                      months[widget.lead.data['time'].toDate().month - 1],
                  style: TextStyle(fontSize: 26),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  widget.lead.data['address'],
                  style: TextStyle(fontSize: 26),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  widget.lead.data['email'],
                  style: TextStyle(fontSize: 26),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  widget.lead.data['phone'],
                  style: TextStyle(fontSize: 26),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  '\$' + widget.lead.data['price'].toString(),
                  style: TextStyle(fontSize: 26),
                ),
                SizedBox(
                  height: 10,
                ),
                widget.customer == null
                    ? Container(
                        height: 0,
                        width: 0,
                      )
                    : Container(
                        height: 40,
                        width: 120,
                        child: RaisedButton(
                          color: Colors.red[400],
                          child: Center(
                            child: Text(
                              'Delete Job',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          onPressed: () async {
                            await DatabaseService()
                                .userCollection
                                .document(widget.customer.documentID)
                                .collection('leads')
                                .document(widget.lead.documentID)
                                .delete();
                            Navigator.of(context).pop();
                          },
                        ),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
