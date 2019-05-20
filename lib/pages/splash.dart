import 'dart:async';
import 'package:flutter_app/common/common.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/home.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:common_utils/common_utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_app/manager/api.dart';
import 'package:flutter_app/manager/main_model.dart';

class SplashPage extends StatefulWidget {
  @override
  SplashState createState() => SplashState();
}

final TextStyle splashFont = const TextStyle(
    fontSize: 27.0,
    height: 1.5,
    fontWeight: FontWeight.w500,
    color: Colors.white);
final TextStyle splashFontNow = const TextStyle(
    fontSize: 20.0, fontWeight: FontWeight.w500, color: Colors.black);

// 闪屏展示页面，首次安装时展示可滑动页面，第二次展示固定图片
class SplashState extends State<SplashPage> {
  bool fristShowWelcome = true;
  String splashUrl;
  String splashGoto;

  initValue() async {
    MainModel().queryAdData();
    MainModel().queryUpdateData();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      fristShowWelcome = prefs.getBool("welcome") ?? true;
      splashUrl = prefs.getString("splash_url") ?? null;
      splashGoto = prefs.getString("splash_goto") ?? null;
      if (fristShowWelcome == false) {
        Timer(const Duration(seconds: 3), () {
          _goHomepage();
        });
      }
    });
  }

  _getContent() {
    if (fristShowWelcome == true) {
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
        child: _getContent(),
      ),
    );
  }

  _getWelcome() {
    return Container(
//      color: Colors.blue,
      constraints: BoxConstraints.expand(
        width: double.infinity,
        height: double.infinity,
      ),
      decoration: BoxDecoration(
        image: DecorationImage(
            image: ExactAssetImage('images/welcome.png'), fit: BoxFit.cover),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            alignment: Alignment.bottomCenter,
            child: Text("在你需要的每个地方\n载着你去往每个地方\n无佣金，乘客少花钱\n不抽成，车主多挣钱",
                style: splashFont),
          ),
          Container(
            alignment: Alignment.center,
            child: MaterialButton(
              color: Colors.white,
              onPressed: clickWelcome,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              padding:
                  EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
              child: Text(
                '立即启程',
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _goHomepage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }

  _getSplash() {
    if (splashUrl != null) {
      return GestureDetector(
        onTap: () {
          launch(splashGoto);
        },
        child: Container(
            constraints: BoxConstraints.expand(
              width: double.infinity,
              height: double.infinity,
            ),
            child: CachedNetworkImage(
              imageUrl: splashUrl,
              fit: BoxFit.cover,
            ),
            decoration: BoxDecoration()),
      );
    } else {
      return Container(
        constraints: BoxConstraints.expand(
          width: double.infinity,
          height: double.infinity,
        ),
        decoration: BoxDecoration(
          image: DecorationImage(
              image: ExactAssetImage('images/welcome.png'), fit: BoxFit.cover),
        ),
      );
    }
  }
}
