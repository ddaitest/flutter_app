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
  String onlineVersionName = '1.0.1';
  int LocalVersionName;
  int OnlineVersionName;

  @override
  void initState() {
    super.initState();
    _getVersion();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 80.0),
            child: Center(
              child: Column(
                children: <Widget>[
                  Image.asset(
                    'images/icon.png',
                  ),
                  Text(
                    '$localVersionName',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.black,
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20.0),
            color: Colors.white,
            height: 50.0,
            child: ListTile(
              title: Text('功能介绍'),
              onTap: null,
              trailing: Icon(Icons.arrow_forward_ios),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 3.0),
            color: Colors.white,
            child: ListTile(
              title: Text('版本升级'),
              onTap: _checkVersion,
              trailing: Icon(Icons.arrow_forward_ios),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 3.0),
            color: Colors.white,
            child: ListTile(
              title: Text('官方网站'),
              onTap: _aboutURL,
              trailing: Icon(Icons.arrow_forward_ios),
            ),
          ),
        ],
      ),
    );
  }

  _getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    localVersionName = packageInfo.version ?? ' ';
    return localVersionName;
  }

  _checkVersion() {
    LocalVersionName = int.parse(localVersionName.replaceAll('.', ''));
    OnlineVersionName = int.parse(onlineVersionName.replaceAll('.', ''));
    if (LocalVersionName < OnlineVersionName) {
      _updateURL();
    }else{
      _checkVersionToast();
    }
  }
}

_aboutURL() async {
  launch('https://www.baidu.com');
}

_updateURL() async {
  launch('http:///www.sina.com.cn');
}

_checkVersionToast(){
  Fluttertoast.showToast(
    msg: '当前已是最新版本',
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIos: 1,
  );
}
