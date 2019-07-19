import 'package:flutter/material.dart';

ThemeData getTheme() {
  return ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color(0xff5680fa),
  );
}

const Color primaryTextColor = const Color(0xff203152);

const TextStyle textStyle1 = const TextStyle(
  fontSize: 30.0,
  color: primaryTextColor,
);

const TextStyle textStyle2 = const TextStyle(
  fontSize: 14.0,
  color: const Color(0xff7C8698),
);
