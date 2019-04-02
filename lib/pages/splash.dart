import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/home.dart';


class SplashPage extends StatefulWidget {
  @override
  SplashState createState() => SplashState();
}


// 闪屏展示页面，首次安装时展示可滑动页面，第二次展示固定图片
class SplashState extends State<SplashPage> {
  final splash = 'splash_key';


  Future saveSplashDB() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      sharedPreferences.setInt(
          splash, 1);
    });
  }
  Future getSplashDB() async {
    int _firstStart;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _firstStart = await prefs.getInt(splash);
    return _firstStart;
  }

  @override
  Widget build(BuildContext context) {
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
                  '无佣金，更快捷 $getSplashDB',
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
                    onPressed: (){
                      saveSplashDB();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );
                    },
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
              ],
            ),
          ),
        ],
      ),
    );
  }



}
