import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BottomNavBarItem {
  static BottomNavigationBarItem bottomNavigationBaritem(
      String icons, String activeicons, String labels) {
    return BottomNavigationBarItem(
        icon: SizedBox(height: 24, width: 24, child: SvgPicture.asset(icons)),
        activeIcon: SizedBox(
            height: 24, width: 24, child: SvgPicture.asset(activeicons)),
        label: labels,
        backgroundColor: Colors.white,
        tooltip: "");
  }
}
