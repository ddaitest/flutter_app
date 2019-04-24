import 'dart:async';
import 'package:flutter_app/common/common.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/home.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:common_utils/common_utils.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

class SplashPage extends StatefulWidget {
  @override
  SplashState createState() => SplashState();
}

// 闪屏展示页面，首次安装时展示可滑动页面，第二次展示固定图片
class SplashState extends State<SplashPage> {
  bool fristShowWelcome = true;
  bool mustUpdate = false;
  bool showUpdate = true;
  String splash_url;
  String splash_goto;
  String updateURL = '';
  String updateMessage ='';

  initValue() async {
    _getAdData();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      fristShowWelcome = prefs.getBool("welcome") ?? true;
      splash_url = prefs.getString("splash_url") ?? '';
      splash_goto = prefs.getString("splash_goto") ?? '';
      showUpdate = prefs.getBool("update") ?? false;
      mustUpdate = prefs.getBool("mustUpdate") ?? false;
      updateURL = prefs.getString("updateURL") ?? "http://www.baidu.com";
      updateMessage = prefs.getString("updateMessage") ?? "11111";

      if (showUpdate == false && fristShowWelcome == false) {
        Timer(const Duration(seconds: 3), () {
          _goHomepage();
        });
      }
    });
  }

  _getAdData() async {
    String apiUrl = 'http://192.168.123.171:5000/api/ad';
    Response response = await Dio().get(apiUrl);
    Map<String, dynamic> json_data = jsonDecode(response.data);
    splash_url = json_data['splash_url'];
    splash_goto = json_data['splash_goto'];
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("splash_url", splash_url);
    sharedPreferences.setString("splash_goto", splash_goto);
    print('LC ############# $splash_url');
    print('LC ############# $splash_goto');
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


  _goHomepage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }

  _getSplash() {
    if (splash_url == null) {
      return <Widget>[
        Image.asset(
          'images/Splash_first.png',
          color: Colors.white,
          width: 150.0,
          height: 150.0,
        ),
      ];
    } else if(splash_url == ''){
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
        GestureDetector(
          onTap: (){
            launch(splash_goto);
          },
          child: Image.network(
            splash_url,
            fit: BoxFit.fill,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
        )

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
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top:30.0),
              child: FlatButton(
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
            ),
            Padding(
              padding: EdgeInsets.only(top: 5.0),
              child: FlatButton(
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
              ),
            )
          ],
        )
      ];
    }
  }
}
