import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/home.dart';
import 'package:flutter_app/pages/update.dart';
import 'package:flutter_app/pages/welcome.dart';

class SplashPage extends StatefulWidget {
  @override
  SplashState createState() => SplashState();
}

// 欢迎页点击立刻体验后再次进入app不再展示欢迎页；不升级时&&不展示欢迎页时展示开屏页
class SplashState extends State<SplashPage> {

  initValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      WelcomeState().showWelcome = prefs.getBool("welcome") ?? true;
      UpdateState().showUpdate = prefs.getBool("update") ?? true;
//      UpdateState().updateURL = prefs.getString("updateURL") ?? "http://www.baidu.com";
//      UpdateState().updateMessage = prefs.getString("updateMessage") ?? "";

      print("initState   showUpdate= ${UpdateState().showUpdate} ; showWelcome=${WelcomeState().showWelcome}");
      if (UpdateState().showUpdate && !WelcomeState().showWelcome) {
        Timer(const Duration(seconds: 2), () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomePage()));
        });
      } else if(!UpdateState().showUpdate){
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => UpdatePage()));
      }else if(!WelcomeState().showWelcome){
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => WelcomePage()));
      }
    });
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

//    print("initState   showUpdate= ${UpdateState().showUpdate} ; showWelcome=${WelcomeState().showWelcome}");
    if (UpdateState().showUpdate) {
      return UpdatePage();
    } else if (WelcomeState().showWelcome) {
      return WelcomePage();
    } else {
      return _getSplash();
    }
  }

  _getSplash() {
    return <Widget>[
      new Image.asset(
        'images/Splash_first.png',
        color: Colors.white,
        width: 150.0,
        height: 150.0,
      ),
    ];
  }


}
