import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/common/common.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/pages/home.dart';
import 'package:flutter_app/pages/first.dart';
import 'package:flutter_app/pages/second.dart';
import 'package:flutter_app/pages/third.dart';
import 'package:url_launcher/url_launcher.dart';

class SplashPage extends StatefulWidget {
  @override
  SplashState createState() => SplashState();
}

// 闪屏展示页面，首次安装时展示可滑动页面，第二次展示固定图片
class SplashState extends State<SplashPage> {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      body: new Stack(
        children: <Widget>[
          new Container(
            width: double.infinity,
            color: Colors.blue,
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Image.asset(
                  'images/Splash_first.png',
                  color: Colors.white,
                  width: 150.0,
                  height: 150.0,
                ),
                new Text(
                  '无佣金,更快捷',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 34.0,
                  ),
                ),
                new Text(
                  '''平台不收取佣金
                  更快捷的叫车方式''',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                )
              ],
            ),
          )
        ],

      ),
    );
  }



}
