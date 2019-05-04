import 'dart:async';
import 'dart:convert';
import 'package:flutter_app/manager/main_model.dart';
import 'package:flutter_app/manager/manager.dart';
import 'package:flutter_app/common/common.dart';
import 'package:flutter_app/common/ItemView2.dart';
import 'package:flutter_app/pages/search.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FirstTab extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new FirstState();
  }
}

class FirstState extends State<FirstTab> with AutomaticKeepAliveClientMixin {
  final List<Event> data = new List();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  String showCard_url;
  String showCard_goto;
  String list_url;
  String list_goto;
  bool mustUpdate;
  bool showUpdate;
  String updateURL;
  String updateMessage;
  bool canClose;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        floatingActionButton: FloatingActionButton(
          onPressed: null,
          child: Icon(Icons.add),
        ),
        body: getBodyView(context));
//        body: getContent());
  }

  initValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      showCard_url = prefs.getString("showCard_url") ?? null;
      showCard_goto = prefs.getString("showCard_goto") ?? null;
      list_url = prefs.getString("list_url") ?? null;
      list_goto = prefs.getString("list_goto") ?? null;
    });
    _loadData();
    _getUpgradeData();
  }

  @override
  void initState() {
    super.initState();
    initValue();
  }

  _getUpgradeData() async {
    String apiUrl = "http://34.92.69.146:5000/api/update/";
    var response = await http.get(apiUrl);
    if (response.statusCode == 200) {
      List datalist = jsonDecode(response.body);
      for (var i in datalist) {
        showUpdate = i['show_update'];
        mustUpdate = i['must_update'];
        updateURL = i['update_url'];
        updateMessage = i['update_message'];
      }
    }
    print('LC ############# $mustUpdate');
    print('LC ############# $updateURL');
    print('LC ############# $updateMessage');
    if (showUpdate == true && showUpdate != null) {
      upgradeCard();
    } else {
      showDialogCard();
    }
  }

  void _loadData() async {
//    upgradeCard();
//    showDialogCard();
    String dataURL = "http://39.96.16.125:8082/api/event/";
    http.Response response = await http.get(dataURL);
    print("DDAI= end=${response.body}");
    final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
    final newData = parsed.map<Event>((json) => Event.fromJson(json)).toList();
    data.clear();
    data.addAll(newData);
    setState(() {
      data.clear();
      data.addAll(newData);
    });
  }

  getBodyView(BuildContext context) {
    var views = <Widget>[];
    var model = MainModel.of(context);
    //添加搜索
    var searchCondition = model.getSearchCondition(true);
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
          model.updateSearchCondition(null);
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
          return new Image.network(
            "http://b-ssl.duitang.com/uploads/item/201607/04/20160704170016_hytGj.thumb.700_0.jpeg",
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
    if (data.length > 0) {
      return RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: () => new Future(() => _loadData()),
        child: _list(),
      );
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }

  Widget _list() {
    return new ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) =>
            ItemView2(data[index], index, 0),
        separatorBuilder: (BuildContext context, int index) {
          if (index == 1) {
            if (list_url != null ||
                list_url.isNotEmpty ||
                list_goto != null ||
                list_goto.isNotEmpty) {
              return Card(
                margin: EdgeInsets.all(8),
                child: Container(
                  padding: EdgeInsets.all(1),
                  child: Card(
                    child: GestureDetector(
                      onTap: () {
                        launch(list_goto);
                      },
                      child: CachedNetworkImage(
                        imageUrl: list_url,
                        fit: BoxFit.fitWidth,
                        width: 500,
                        height: 130,
                      ),
                    ),
                  ),
                ),
              );
            }
          } else {
            return Container();
          }
        }).build(context);
  }

  @override
  bool get wantKeepAlive => true;

  Future<void> showDialogCard() async {
    if (showCard_url != null && showCard_goto != null) {
      return showDialog<void>(
        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
              backgroundColor: Colors.transparent,
              content: GestureDetector(
                onTap: () {
                  launch(showCard_goto);
                  Navigator.of(context).pop();
                },
                child: CachedNetworkImage(
                  imageUrl: showCard_url,
                  fit: BoxFit.cover,
                  width: 500,
                  height: 300,
                ),
              ));
        },
      );
    }
  }

  _canCloseUpdateCard() {
    if (mustUpdate == true) {
      canClose = false;
    } else {
      canClose = true;
    }
    return canClose;
  }

  Future<void> upgradeCard() async {
    if (updateURL != null && updateMessage != null) {
      return showDialog<void>(
        context: context,
        barrierDismissible: _canCloseUpdateCard(), // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
              backgroundColor: Colors.transparent,
              content: Container(
                width: 400,
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
                          launch(updateURL);
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
}
