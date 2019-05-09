import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_app/log/log.dart';
import 'package:flutter_app/manager/main_model.dart';
import 'package:flutter_app/common/common.dart';
import 'package:flutter_app/common/ItemView2.dart';
import 'package:flutter_app/pages/search.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class FirstTab extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new FirstState();
  }
}

class FirstState extends State<FirstTab> with AutomaticKeepAliveClientMixin {
//  final List<Event> data = new List();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  MainModel model;
  String list_url;
  String list_goto;

  @override
  Widget build(BuildContext context) {
    model = MainModel.of(context);
    print("WARN. build  model=${model.hashCode}; context=${context.hashCode}");
//    model.queryVehicleList(0);
    return new Scaffold(key: _scaffoldKey, body: getBodyView(context));
  }

  initValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      list_url = prefs.getString("list_url") ?? null;
      list_goto = prefs.getString("list_goto") ?? null;
    });
//    _getUpgradeData();
  }

  @override
  void initState() {
    super.initState();
    initValue();
    Future.delayed(Duration.zero, () {
      var x = MainModel.of(context);
      x.queryVehicleList(0);
      print(
          "WARN. initState  model=${model.hashCode}; context=${context.hashCode}");
//      MainModel.of(context).queryVehicleList(0);
    });
  }

//  _getUpgradeData() async {
//    String apiUrl = "http://34.92.69.146:5000/api/update/";
//    var response = await http.get(apiUrl);
//    if (response.statusCode == 200) {
//      List datalist = jsonDecode(response.body);
//      for (var i in datalist) {
//        showUpdate = i['show_update'];
//        mustUpdate = i['must_update'];
//        updateURL = i['update_url'];
//        updateMessage = i['update_message'];
//      }
//    }
//    if (showUpdate == true && showUpdate != null) {
//      upgradeCard();
//    } else {
//      showDialogCard();
//    }
//  }

  getBodyView(BuildContext context) {
    var views = <Widget>[];
    //添加搜索
    var searchCondition = model.getSearchCondition(true);
    print("getBodyView searchCondition=$searchCondition");
    if (searchCondition != null) {
      views.add(getSearchView(
        searchCondition,
        () {
          print("11111");
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SearchPage(findVehicle: true)),
          ).then((map) {
            print("callback = $map");
          });
        },
        () {
          print("22222");
          model.updateSearchCondition(true, null);
        },
      ));
    }
    //添加banner
    if (model.getBannerData() > 0) {
      views.add(getBannerView());
    }
    //添加列表
    views.add(Expanded(child: getListView()));

    return Container(child: Column(children: views));
  }

  /// View: 当前搜索信息。
  getSearchView(
      SearchCondition condition, Function callSearch, Function callClean) {
    return Card(
      color: Colors.blue,
      child: Container(
        height: 50,
        padding: EdgeInsets.only(left: 8, right: 8),
        child: InkWell(
          child: Row(
            children: <Widget>[
              SizedBox(width: 8),
              Icon(Icons.search, color: Colors.white),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  getDesc(condition),
                  style: TextStyle(color: Colors.white),
                ),
                flex: 1,
              ),
              InkWell(
                child: Container(
                  child: Icon(
                    Icons.clear,
                    color: Colors.white,
                    size: 24,
                  ),
                  padding: EdgeInsets.all(10),
                ),
                onTap: callClean,
              ),
            ],
          ),
          onTap: callSearch,
        ),
      ),
    );
  }

  /// View: Banner
  getBannerView() {
    return Container(
      height: 120,
      child: new Swiper(
        itemBuilder: (BuildContext context, int index) {
          return Image(
            image: new CachedNetworkImageProvider(
                "https://desk-fd.zol-img.com.cn/t_s720x360c5/g5/M00/03/02/ChMkJ1v9A1mIN_iKABERj1MSlcQAAtatAEvvFEAERGn385.jpg"),
            fit: BoxFit.fitWidth,
          );
        },
        itemHeight: 120,
        itemCount: 3,
        viewportFraction: 0.8,
        scale: 0.9,
        pagination: new SwiperPagination(),
        control: new SwiperControl(),
      ),
    );
  }

  /// View: 列表。
  getListView() {
    var listData = model.getVehicleList();
    print("====== listData = ${listData.length} @ ${model.hashCode}");
    if (listData.length > 0) {
      return RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: () => new Future(() => model.queryVehicleList(0)),
        child: _list(),
      );
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }

  Widget _list() {
    var data = model.getVehicleList();
    return new ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) =>
            ItemView2(data[index], index, 0),
        separatorBuilder: (BuildContext context, int index) {
          if (index == 1) {
            if (list_url != null || list_goto != null) {
              return Card(
                margin: EdgeInsets.all(8),
                child: Container(
                  padding: EdgeInsets.all(1),
                  child: Card(
                    child: GestureDetector(
                        onTap: () {
                          launch(list_goto);
                        },
                        child: Image(
                          image: CachedNetworkImageProvider(list_url),
                          fit: BoxFit.fitWidth,
                          width: 500,
                          height: 130,
                        )),
                  ),
                ),
              );
            } else {
              return Container();
            }
          } else {
            return Container();
          }
        }).build(context);
  }

  @override
  bool get wantKeepAlive => true;

//  Future<void> showDialogCard() async {
//    if (showCard_url != null && showCard_goto != null) {
//      return showDialog<void>(
//        context: context,
//        barrierDismissible: true, // user must tap button!
//        builder: (BuildContext context) {
//          return AlertDialog(
//              backgroundColor: Colors.transparent,
//              content: GestureDetector(
//                onTap: () {
//                  launch(showCard_goto);
//                  Navigator.of(context).pop();
//                },
//                child: CachedNetworkImage(
//                  imageUrl: showCard_url,
//                  fit: BoxFit.cover,
//                  width: 500,
//                  height: 300,
//                ),
//              ));
//        },
//      );
//    }
//  }

//  _canCloseUpdateCard() {
//    if (mustUpdate == true) {
//      canClose = false;
//    } else {
//      canClose = true;
//    }
//    return canClose;
//  }

//  Future<void> upgradeCard() async {
//    if (updateURL != null && updateMessage != null) {
//      return showDialog<void>(
//        context: context,
//        barrierDismissible: _canCloseUpdateCard(), // user must tap button!
//        builder: (BuildContext context) {
//          return AlertDialog(
//              backgroundColor: Colors.transparent,
//              content: Container(
//                height: 400,
//                decoration: BoxDecoration(
//                  image: DecorationImage(
//                      image: ExactAssetImage('images/Upgrade_Card.png'),
//                      fit: BoxFit.cover),
//                ),
//                child: Column(
//                  children: <Widget>[
//                    Container(
//                      alignment: Alignment.bottomLeft,
//                      margin: EdgeInsets.only(left: 30.0, top: 180.0),
//                      child: Text(
//                        updateMessage,
//                        textAlign: TextAlign.left,
//                        softWrap: true,
//                      ),
//                    ),
//                    Container(
//                      alignment: Alignment.center,
//                      margin: EdgeInsets.fromLTRB(15, 42, 15, 40),
//                      child: MaterialButton(
//                        minWidth: 250,
//                        height: 50,
//                        color: Colors.blue,
//                        onPressed: () {
//                          launch(updateURL);
//                        },
//                        shape: RoundedRectangleBorder(
//                          borderRadius: BorderRadius.all(Radius.circular(5)),
//                        ),
//                        child: Text(
//                          '立即更新',
//                          style: TextStyle(fontSize: 17, color: Colors.white),
//                        ),
//                      ),
//                    ),
//                  ],
//                ),
//              ));
//        },
//      );
//    }
//  }
}
