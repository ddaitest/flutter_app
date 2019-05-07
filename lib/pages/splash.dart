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
  String splash_url;
  String splash_goto;
  String showCard_url;
  String showCard_goto;
  String list_url;
  String list_goto;

  initValue() async {
    _getAdData();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      fristShowWelcome = prefs.getBool("welcome") ?? true;
      splash_url = prefs.getString("splash_url") ?? null;
      splash_goto = prefs.getString("splash_goto") ?? null;
      if (fristShowWelcome == false) {
        Timer(const Duration(seconds: 3), () {
          _goHomepage();
        });
      }
    });
  }

  _getAdData() async {
    String apiUrl = "http://34.92.69.146:5000/api/ad/";
    var response = await http.get(apiUrl);
    if (response.statusCode == 200) {
      List datalist = jsonDecode(response.body);
      for (var i in datalist) {
        splash_url = i['splash_url'];
        splash_goto = i['splash_goto'];
        showCard_url = i['showCard_url'];
        showCard_goto = i['showCard_goto'];
        list_url = i['list_url'];
        list_goto = i['list_goto'];
      }
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.setString("splash_url", splash_url);
      sharedPreferences.setString("splash_goto", splash_goto);
      sharedPreferences.setString("showCard_url", showCard_url);
      sharedPreferences.setString("showCard_goto", showCard_goto);
      sharedPreferences.setString("list_url", list_url);
      sharedPreferences.setString("list_goto", list_goto);
    }
    print('LC ############# $splash_url');
    print('LC ############# $splash_goto');
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
    if (splash_url != null) {
      return GestureDetector(
        onTap: () {
          launch(splash_goto);
        },
        child: Container(
            constraints: BoxConstraints.expand(
              width: double.infinity,
              height: double.infinity,
            ),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: CachedNetworkImageProvider(splash_url),
                fit: BoxFit.cover,
              ),
            )),
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
