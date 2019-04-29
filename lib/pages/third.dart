import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info/package_info.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ThirdTab extends StatefulWidget {
  @override
  ThirdTabState createState() => ThirdTabState();
}

class ThirdTabState extends State<ThirdTab> {
  String localVersionName = '';
  String telphoneNum = '12345678';
  String website = 'www.baidu.com';

//  String onlineVersionName = '1.0.0';
//  int LocalVersionName;
//  int OnlineVersionName;

  @override
  void initState() {
    super.initState();
    _getVersion();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 100.0),
          child: Image.asset(
            'images/ic_launcher.png',
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 0.0),
          child: Text(
            localVersionName,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.black,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 100.0),
          child: FlatButton(
            onPressed: () {
              _launchcaller('tel:' + telphoneNum);
            },
            child: Column(
              children: <Widget>[
                Text(
                  '合作电话：' + telphoneNum,
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
    localVersionName = packageInfo.version ?? ' ';
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

  _aboutURL() async {
    launch('https://$website');
  }

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
  void _launchcaller(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
