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

/// return A positive number if a>b , negative number if a<b , 0 if a=b
int compareVersion(String a, String b) {
  var as = a.split(".").map((string) => int.tryParse(string));
  var bs = b.split(".").map((string) => int.tryParse(string));
  int x, y;
  for (var i = 0; i < 3; i++) {
    x = as.elementAt(i);
    y = bs.elementAt(i);
    if (x != y) {
      break;
    }
  }
  return x - y;
}
