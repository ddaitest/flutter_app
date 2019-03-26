import 'package:flutter/material.dart';

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
              new Text(
                "关于我们",
                style: new TextStyle(color: Colors.black54),
              )
            ],
          ),
        ),
      ),
    );
  }
}
