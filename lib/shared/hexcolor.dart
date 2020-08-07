import 'package:flutter/material.dart';

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

final themeGreen = HexColor('#306060');
final themeGrey = HexColor('#648888');
final placeholderImage =
    'https://keepitlocalcc.com/wp-content/uploads/2019/11/placeholder.png';
