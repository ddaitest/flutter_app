import 'package:flutter/material.dart';
import 'package:flutter_app/common/common.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdatePage extends StatefulWidget {
  @override
  UpdateState createState() => UpdateState();
}

class UpdateState extends State<UpdatePage> {

  bool showUpdate = true;
  String updateURL = "";
  String updateMessage = "";

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: getContent(),
          ),
        ),
      ),
    );
  }

  clickUpgrade() {
    launch(updateURL);
  }

  getContent() {
    if (showUpdate) {
      return <Widget>[
        Text(
          "请升级版本",
          style: fontCall,
        ),
        Text(
          updateMessage,
          style: fontCall,
        ),
        RaisedButton(
          onPressed: clickUpgrade,
          child: Text("更新"),
        )
      ];
    } else {
      return <Widget>[
        Text(
          "HELLO WORLD",
          style: fontCall,
        ),
      ];
    }
  }
}
