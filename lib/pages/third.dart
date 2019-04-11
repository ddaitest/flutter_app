import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info/package_info.dart';


class ThirdTab extends StatefulWidget {
  @override
  ThirdTabState createState() => ThirdTabState();
}

class ThirdTabState extends State<ThirdTab> {
  String versionName = '';
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
                    versionName,
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
              onTap: null,
              trailing: Icon(Icons.arrow_forward_ios),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 3.0),
            color: Colors.white,
            child: ListTile(
              title: Text('官方网站'),
              onTap: _launchURL,
              trailing: Icon(Icons.arrow_forward_ios),
            ),
          ),
        ],
      ),
    );
  }

  _getVersion() async{
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    versionName = packageInfo.version ?? ' ';
    return versionName;
  }
}



_launchURL() async {
  launch('https://www.baidu.com');
}


