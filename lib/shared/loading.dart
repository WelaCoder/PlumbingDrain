import 'package:flutter/material.dart';
import 'package:plumbing_drain/shared/hexcolor.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:pet_walker/src/constants/hexcolor.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: HexColor('#fdfdfd'),
      child: Center(
        child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(themeGreen),
          strokeWidth: 5,
        ),
      ),
    );
  }
}
