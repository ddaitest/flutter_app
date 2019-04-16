import 'dart:async';
import 'package:flutter_app/common/common.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/home.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:common_utils/common_utils.dart';

class SplashPage extends StatefulWidget {
  @override
  SplashState createState() => SplashState();
}

// 闪屏展示页面，首次安装时展示可滑动页面，第二次展示固定图片
class SplashState extends State<SplashPage> {
  bool fristShowWelcome = true;
  bool mustUpdate = false;
  bool showUpdate = true;
  String adShowUrl = '';
  String updateURL = "";
  String updateMessage =
      "风急天高猿啸哀，\n渚清沙白鸟飞回。\n无边落木萧萧下，\n不尽长江滚滚来。\n万里悲秋常作客，\n百年多病独登台。\n艰难苦恨繁霜鬓，\n潦倒新停浊酒杯。";
  TimerUtil _timerUtil;
  int _status = 0;
  int _count = 3;

  initValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      fristShowWelcome = prefs.getBool("welcome") ?? true;
      showUpdate = prefs.getBool("update") ?? true;
      mustUpdate = prefs.getBool("mustUpdate") ?? false;
      updateURL = prefs.getString("updateURL") ?? "http://www.baidu.com";
      updateMessage = prefs.getString("updateMessage") ?? "";

      if (showUpdate == false && fristShowWelcome == false) {
        Timer(const Duration(seconds: 3), () {
          _goHomepage();
        });
      }
    });
  }

  _getContent() {
    if (showUpdate == true) {
      return _getUpgrade();
    } else if (fristShowWelcome == true) {
      return _getWelcome();
    } else {
      return _getSplash();
    }
  }

  clickWelcome() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool("welcome", false);
    _goHomepage();
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

  _getWelcome() {
    return <Widget>[
      Image.asset(
        'images/Splash_first.png',
        color: Colors.white,
        width: 150.0,
        height: 150.0,
      ),
      Text(
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

  void _doCountDown() {
    setState(() {
      _status = 1;
    });
    _timerUtil = new TimerUtil(mTotalTime: 3 * 1000);
    _timerUtil.setOnTimerTickCallback((int tick) {
      double _tick = tick / 1000;
      setState(() {
        _count = _tick.toInt();
      });
      if (_tick == 0) {
        _goHomepage();
      }
    });
    _timerUtil.startCountDown();
  }

  _goHomepage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }

  _getSplash() {
    if (adShowUrl == '') {
      return <Widget>[
        Image.asset(
          'images/Splash_first.png',
          color: Colors.white,
          width: 150.0,
          height: 150.0,
        ),
      ];
    } else {
      return <Widget>[
        Image.network(
          adShowUrl,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          fit: BoxFit.fill,
        ),
      ];
    }
  }

  _getUpgrade() {
    if (mustUpdate == true) {
      return <Widget>[
        Text(
          "这是普通升级",
          style: fontCall,
        ),
        Text(
          updateMessage,
          style: fontCall,
        ),
        RaisedButton(
          onPressed: clickUpgrade,
          child: Text("立刻更新"),
        )
      ];
    } else {
      return <Widget>[
        Text(
          "这是强制升级",
          style: fontCall,
        ),
        Text(
          updateMessage,
          style: fontCall,
        ),
        Column(
          children: <Widget>[
            FlatButton(
              color: Colors.white,
              shape: BeveledRectangleBorder(
                side: BorderSide(
                  color: Colors.white,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(2),
              ),
              onPressed: clickUpgrade,
              child: Text("立刻更新"),
            ),
            FlatButton(
              color: Colors.white,
              shape: BeveledRectangleBorder(
                side: BorderSide(
                  color: Colors.white,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(2),
              ),
              onPressed: _goHomepage,
              child: Text("跳过"),
            )
          ],
        )
      ];
    }
  }
}
