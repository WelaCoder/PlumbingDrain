import 'package:flutter/material.dart';
import 'package:plumbing_drain/screens/wrapper.dart';
import 'package:plumbing_drain/services/auth.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plumbing Drain App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: StreamProvider.value(value: AuthService().user, child: Wrapper()),
    );
  }
}
