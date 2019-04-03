import 'dart:async';
import 'package:flutter_app/common/common.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/home.dart';
import 'package:url_launcher/url_launcher.dart';

class SplashPage extends StatefulWidget {
  @override
  SplashState createState() => SplashState();
}

// 闪屏展示页面，首次安装时展示可滑动页面，第二次展示固定图片
class SplashState extends State<SplashPage> {
  bool showWelcome = true;
  bool showUpdate = true;
  String updateURL = "";
  String updateMessage = "";

  initValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      showWelcome = prefs.getBool("welcome") ?? true;
      showUpdate = prefs.getBool("update") ?? false;
      updateURL = prefs.getString("updateURL") ?? "http://www.baidu.com";
      updateMessage = prefs.getString("updateMessage") ?? "";

      print("initState   showUpdate= $showUpdate ; showWelcome=$showWelcome");
      if (!showUpdate && !showWelcome) {
        Timer(const Duration(seconds: 2), () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomePage()));
        });
      }
    });
  }

  clickWelcome() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool("welcome", false);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }

  clickUpgrade() {
    launch(updateURL);
  }

  @override
  void initState() {
    super.initState();
    initValue();

  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
        color: Colors.blue,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: _getContent(),
          ),
        ),
      ),
    );
  }

  _getContent() {

    print("_getContent  showUpdate= $showUpdate ; showWelcome=$showWelcome");
    if (showUpdate) {
      return _getUpgrade();
    } else if (showWelcome) {
      return _getWelcome();
    } else {
      return _getSplash();
    }
  }

  _getWelcome() {
    return <Widget>[
      new Image.asset(
        'images/Splash_first.png',
        color: Colors.white,
        width: 150.0,
        height: 150.0,
      ),
      new Text(
        '无佣金，更快捷',
        style: TextStyle(
          color: Colors.white,
          fontSize: 34.0,
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 70.0),
        child: new Text(
          '最后一公里不再难',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 100.0),
        child: new MaterialButton(
          onPressed: clickWelcome,
          child: new Text(
            '马上体验',
            style: TextStyle(
              color: Colors.black,
              fontSize: 24.0,
            ),
          ),
          color: Colors.white,
          splashColor: Colors.blue,
        ),
      ),
    ];
  }

  _getSplash() {
    return <Widget>[
      Text(
        "HELLO WORLD",
        style: fontCall,
      ),
    ];
  }

  _getUpgrade() {
    return <Widget>[
      Text(
        "请升级版本",
        style: fontCall,
      ),
      Text(
        updateMessage,
        style: fontCall,
      ),
      RaisedButton(
        onPressed: clickUpgrade,
        child: Text("更新"),
      )
    ];
  }
}
