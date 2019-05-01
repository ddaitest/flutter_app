import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

void launchcaller(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

getRoundIcon(IconData icon) {
  return Container(
    width: 36,
//    margin: EdgeInsets.only(left: 16, right: 16),
    height: 36,
    child: Icon(
      icon,
      color: Colors.white,
      size: 22,
    ),
    decoration: BoxDecoration(
      color: Colors.blue,
      shape: BoxShape.circle,
      border: Border.all(color: Colors.blue, width: 2),
    ),
  );
}

