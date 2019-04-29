import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_app/pages/home.dart';
import 'package:flutter_app/pages/publish.dart';
import 'package:flutter_app/pages/search.dart';
import 'package:flutter_app/pages/splash.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_jpush/flutter_jpush.dart';
import 'dart:io';
//import 'package:flutter_umeng_analytics/flutter_umeng_analytics.dart';


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
//    _umeng();
//    UMengAnalytics.beginPageView("StartUp");
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

//  _umeng()async{
//    if (Platform.isAndroid)
//      await UMengAnalytics.init('5cc481cc3fc19568a7000b7c',
//          encrypt: true, reportCrash: false);
//    else if (Platform.isIOS)
//      UMengAnalytics.init('5cc4860a4ca357a1fe000190',
//          encrypt: true, reportCrash: false);
//  }



}


