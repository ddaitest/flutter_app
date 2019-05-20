import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info/package_info.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_app/common/utils.dart';

class ThirdTab extends StatefulWidget {
  @override
  ThirdTabState createState() => ThirdTabState();
}

class ThirdTabState extends State<ThirdTab> {
  String localVersionName = '';
  String telphoneNum = '1234567';
  String thirdMessage = '';

  initValue() async {
    var dialogDataMap = await getDialogData();
    setState(() {
      thirdMessage = dialogDataMap["message"];
    });
  }

  @override
  void initState() {
    super.initState();
    _getVersion();
    initValue();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Column(
          children: <Widget>[
            Container(
//              padding: EdgeInsets.only(top: 100.0),
              child: Image.asset(
                'images/icon.png',
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 0.0),
              child: Text(
                localVersionName,
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
        Container(
//          padding: EdgeInsets.only(top: 50.0),
          child: Text(
            thirdMessage,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.black,
            ),
          ),
        ),
        Container(
//          padding: const EdgeInsets.only(top: 100.0),
          child: FlatButton(
            onPressed: () {
              launchcaller('tel:' + telphoneNum);
            },
            child: Column(
              children: <Widget>[
                Text(
                  '联系电话：' + telphoneNum,
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  _getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    localVersionName = packageInfo.version;
    return localVersionName;
  }

//
//  _checkVersion() {
//    LocalVersionName = int.parse(localVersionName.replaceAll('.', ''));
//    OnlineVersionName = int.parse(onlineVersionName.replaceAll('.', ''));
//    if (LocalVersionName < OnlineVersionName) {
//      _updateURL();
//    }else{
//      _checkVersionToast();
//    }
//  }
//}

//  _aboutURL() async {
//    launch('https://$website');
//  }

//
//_updateURL() async {
//  launch('http:///www.sina.com.cn');
//}
//
//_checkVersionToast(){
//  Fluttertoast.showToast(
//    msg: '当前已是最新版本',
//    toastLength: Toast.LENGTH_SHORT,
//    gravity: ToastGravity.BOTTOM,
//    timeInSecForIos: 1,
//  );
}
