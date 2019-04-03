import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/pages/home.dart';


class WelcomePage extends StatefulWidget {
  @override
  WelcomeState createState() => WelcomeState();
}

class WelcomeState extends State<WelcomePage> {
  bool showWelcome = true;

  clickWelcome() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool("welcome", false);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
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
            children: <Widget>[
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
            ],
          ),
        ),
      ),
    );
  }
}