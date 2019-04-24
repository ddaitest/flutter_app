import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_app/pages/home.dart';
import 'package:flutter_app/pages/publish.dart';
import 'package:flutter_app/pages/search.dart';
import 'package:flutter_app/pages/splash.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_jpush/flutter_jpush.dart';


void main() => runApp(MyApp());


class MyApp extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    _startupJpush();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new SplashPage(),
      routes: <String, WidgetBuilder>{
        '/publish': (BuildContext context) => PublishPage(),
        '/search': (BuildContext context) => SearchPage(),
      },
    );


//    return new MaterialApp(home: new VideoPage());
  }

  void _startupJpush() async {
    print("初始化jpush");
    await FlutterJPush.startup();
    print("初始化jpush成功");
  }


}


