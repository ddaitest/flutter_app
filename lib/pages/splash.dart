import 'dart:async';
import 'package:flutter_app/common/common.dart';
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
  bool mustUpdate = false;
  bool showUpdate = true;
  String splash_url;
  String splash_goto;
  String updateURL;
  String updateMessage;

  initValue() async {
    _getAdData();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      fristShowWelcome = prefs.getBool("welcome") ?? true;
      splash_url = prefs.getString("splash_url") ?? null;
      splash_goto = prefs.getString("splash_goto") ?? null;
      showUpdate = prefs.getBool("update") ?? false;
      mustUpdate = prefs.getBool("mustUpdate") ?? true;
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
    String apiUrl = "http://34.92.69.146:5000/api/ad/";
    var response = await http.get(apiUrl);
    if (response.statusCode == 200) {
      List datalist = jsonDecode(response.body);
      for (var i in datalist) {
        splash_url = i['splash_url'];
        splash_goto = i['splash_goto'];
      }
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.setString("splash_url", splash_url);
      sharedPreferences.setString("splash_goto", splash_goto);
    }
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
//        color: Colors.blue,
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            alignment: Alignment.bottomCenter,
            margin: EdgeInsets.only(top: 200.0),
            child: Text("在你需要的每个地方\n载着你去往每个地方\n无佣金，乘客少花钱\n不抽成，车主多挣钱",
                style: splashFont),
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: 300.0),
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
    if (splash_url == null) {
      return Image.asset(
        'images/Splash_first.png',
        color: Colors.white,
        width: 150.0,
        height: 150.0,
      );
    } else if (splash_url == '') {
      return Image.asset(
        'images/Splash_first.png',
        color: Colors.white,
        width: 150.0,
        height: 150.0,
      );
    } else {
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
                image: NetworkImage(splash_url),
                fit: BoxFit.cover,
              ),
            )),
      );
    }
  }

  _getUpgrade() {
    if (mustUpdate == true) {
      return Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.blue,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 200),
              child: Text(
                "这是普通升级",
                style: fontCall,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 100),
              child: Text(
                updateMessage,
                style: fontCall,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 100),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                onPressed: clickUpgrade,
                child: Text("立刻更新"),
              ),
            )
          ],
        ),
      );
    } else {
      return Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.blue,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 200),
              child: Text(
                "这是强制升级",
                style: fontCall,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 100),
              child: Text(
                updateMessage,
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 100),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 30.0),
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
              ),
            )
          ],
        ),
      );
    }
  }
}
