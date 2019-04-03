import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ThirdTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Container(
        child: new Center(
          child: new Column(
            // center the children
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Icon(
//                Icons.airport_shuttle,
                Icons.hot_tub,
                size: 78.0,
                color: Colors.blue,
              ),
              new FlatButton(
                onPressed: _launchURL,
                child: new Text(
                  'https://www.baidu.com/',
                  style: new TextStyle(color: Colors.black54),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}

_launchURL() async {
  const url = 'https://www.baidu.com';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
