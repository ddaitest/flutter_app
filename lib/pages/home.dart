import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/first.dart';
import 'package:flutter_app/pages/search.dart';
import 'package:flutter_app/pages/second.dart';
import 'package:flutter_app/pages/third.dart';
import 'package:flutter_app/router/routers.dart';
import 'package:flutter_app/pages/publish.dart';
import 'package:flutter_app/common/common.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_app/manager/main_model.dart';

class HomePage extends StatefulWidget {
  @override
//  HomeState createState() => HomeState();
  MyHomeState createState() => MyHomeState();
}

// SingleTickerProviderStateMixin is used for animation
class MyHomeState extends State<HomePage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  // Create a tab controller
  TabController controller;
  int page = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String updateMessage;
  String updateUrl;
  String showCardUrl;
  String showCardGoto;
  bool mustUpdate;
  bool showUpdate;
  bool canClose;

  ///获取升级和弹窗广告数据
  ///如果又升级弹窗出现则不弹广告弹窗，如没有升级则弹广告弹窗，根据must_update和show_update判断
  _getDialogData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      updateMessage = prefs.getString("update_message") ?? null;
      updateUrl = prefs.getString("update_url") ?? null;
      mustUpdate = prefs.getBool("must_update") ?? false;
      showUpdate = prefs.getBool("show_update") ?? false;
      showCardUrl = prefs.getString("showCard_url") ?? null;
      showCardGoto = prefs.getString("showCard_goto") ?? null;
    });

    ///弹窗延迟3s弹出
    Timer(const Duration(seconds: 3), () {
      if (showUpdate == true && showUpdate != null) {
        upgradeCard();
      } else {
        showAdDialogCard();
      }
    });
  }

  ///判断升级弹窗是否可关闭
  _canCloseUpdateCard() {
    if (mustUpdate == true) {
      canClose = false;
    } else {
      canClose = true;
    }
    return canClose;
  }

  @override
  void initState() {
    super.initState();
    _getDialogData();
    // Initialize the Tab Controller
    controller = new TabController(length: 3, vsync: this);
    controller.addListener(() {
      print("DDAI= controller.index=${controller.index}");
      page = controller.index;
      setState(() {
        page = controller.index;
      });
    });
  }

  String getTitle() {
    if (page == 0) {
      return "车找人";
    } else if (page == 1) {
      return "人找车";
    } else {
      return "关于拼车帮";
    }
  }

  @override
  void dispose() {
    // Dispose of the Tab Controller
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: _scaffoldKey,
        // Appbar
        appBar: AppBar(
          title: Text(getTitle()),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SearchPage(findVehicle: page == 0)),
                ).then((map) {
                  print("callback = $map");
                });
              },
              icon: const Icon(
                Icons.search,
                size: 30,
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PublishPage()),
                );
              },
              icon: const Icon(
                Icons.add_circle_outline,
                size: 30,
              ),
            ),
            SizedBox(width: 10),
//          ),
          ],
        ),
        // Set the TabBar view as the body of the Scaffold
        body: new TabBarView(
          // Add tabs as widgets
          children: <Widget>[
            new FirstTab(),
            new SecondTab(),
            new ThirdTab(),
          ],
          // set the controller
          controller: controller,
        ),
        // Set the bottom navigation bar

        bottomNavigationBar: new Material(
          // set the color of the bottom navigation bar
          color: Colors.blue,
          // set the tab bar as the child of bottom navigation bar
          child: new TabBar(
            tabs: <Tab>[
              Tab(icon: Icon(Icons.directions_car)),
              Tab(icon: Icon(Icons.record_voice_over)),
              Tab(icon: Icon(Icons.build)),
            ],
            // setup the controller
            controller: controller,
          ),
        ),
      ),
    );
  }

  ///广告弹窗ui
  Future<void> showAdDialogCard() async {
    if (showCardUrl != null && showCardGoto != null) {
      return showDialog<void>(
        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
              backgroundColor: Colors.transparent,
              content: GestureDetector(
                onTap: () {
                  launch(showCardGoto);
                  Navigator.of(context).pop();
                },
                child: CachedNetworkImage(
                  imageUrl: showCardUrl,
                  fit: BoxFit.cover,
                  width: 500,
                  height: 300,
                ),
              ));
        },
      );
    }
  }

  ///升级弹窗ui
  Future<void> upgradeCard() async {
    if (updateUrl != null && updateMessage != null) {
      return showDialog<void>(
        context: context,
        barrierDismissible: _canCloseUpdateCard(), // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
              backgroundColor: Colors.transparent,
              content: Container(
                height: 400,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: ExactAssetImage('images/Upgrade_Card.png'),
                      fit: BoxFit.cover),
                ),
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.bottomLeft,
                      margin: EdgeInsets.only(left: 30.0, top: 180.0),
                      child: Text(
                        updateMessage,
                        textAlign: TextAlign.left,
                        softWrap: true,
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.fromLTRB(15, 42, 15, 40),
                      child: MaterialButton(
                        minWidth: 250,
                        height: 50,
                        color: Colors.blue,
                        onPressed: () {
                          launch(updateUrl);
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: Text(
                          '立即更新',
                          style: TextStyle(fontSize: 17, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ));
        },
      );
    }
  }

  ///主界面back弹窗
  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('确定退出吗?'),
                content: Text('退出后将不能收到最新的拼车信息'),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: new Text('是'),
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: new Text('否'),
                  ),
                ],
              ),
        ) ??
        false;
  }

  @override
  bool get wantKeepAlive => true;
}
