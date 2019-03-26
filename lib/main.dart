import 'package:flutter/material.dart';
import 'package:flutter_app/home.dart';
import 'package:flutter_app/tabs/publish.dart';
import 'package:flutter_app/tabs/search.dart';
import 'package:flutter_app/tabs/splash.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new SplashPage(),
      routes: <String, WidgetBuilder>{
        '/publish': (BuildContext context) => PublishPage(),
        '/search': (BuildContext context) => SearchPage(),
      },
    );
//    return new MaterialApp(home: new VideoPage());
  }
}
