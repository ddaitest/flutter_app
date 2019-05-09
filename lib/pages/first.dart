import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_app/common/utils.dart';
import 'package:flutter_app/log/log.dart';
import 'package:flutter_app/manager/beans.dart';
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
  String listUrl;
  String listGoto;

  @override
  Widget build(BuildContext context) {
    model = MainModel.of(context);
    return new Scaffold(key: _scaffoldKey, body: getBodyView(context));
  }

  initValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      listUrl = prefs.getString("list_url") ?? null;
      listGoto = prefs.getString("list_goto") ?? null;
    });
  }

  @override
  void initState() {
    super.initState();
    initValue();
    Future.delayed(Duration.zero, () {
      var x = MainModel.of(context);
      //加载 list 数据
      x.queryVehicleList(0);
      //加载 banner 数据
      x.queryBanner(true);
    });
  }

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
    var info = model.getBannerInfoList();
    if (info > 0) {
      views.add(getBannerView(info));
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
  getBannerView(List<BannerInfo> infos) {
    return Container(
      height: 120,
      child: new Swiper(
        itemBuilder: (BuildContext context, int index) {
          return Image(
//            image: new CachedNetworkImageProvider(
//                "https://desk-fd.zol-img.com.cn/t_s720x360c5/g5/M00/03/02/ChMkJ1v9A1mIN_iKABERj1MSlcQAAtatAEvvFEAERGn385.jpg"),
//            fit: BoxFit.fitWidth,
            image: new CachedNetworkImageProvider(
                infos[index].image),
            fit: BoxFit.fitWidth,
          );
        },
        itemHeight: 120,
        itemCount: infos.length,
        viewportFraction: 0.8,
        scale: 0.9,
        pagination: new SwiperPagination(),
        control: new SwiperControl(),
        onTap: (index){
          try{
          launchcaller(infos[index].action);
          }catch(id){

          }
        },
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
            if (listUrl != null || listGoto != null) {
              return Card(
                margin: EdgeInsets.all(8),
                child: Container(
                  padding: EdgeInsets.all(1),
                  child: Card(
                    child: GestureDetector(
                        onTap: () {
                          launch(listGoto);
                        },
                        child: Image(
                          image: CachedNetworkImageProvider(listUrl),
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
}
