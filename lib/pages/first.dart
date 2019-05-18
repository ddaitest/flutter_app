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
import 'package:flutter_app/pages/webview.dart';
//import 'package:pull_to_refresh/pull_to_refresh.dart';

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
  int cardIndex;

//  bool enablePullUp = true;

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
      cardIndex = prefs.getInt("card_index") ?? null;
    });
  }

  @override
  void initState() {
    super.initState();
    refreshing = false;
    loading = false;
    initValue();
//    _refreshController = RefreshController();
    Future.delayed(Duration.zero, () {
      var x = MainModel.of(context);
      //加载 list 数据
//      x.queryPassengerList(true);
      _onRefresh();
      //加载 banner 数据
      x.queryBanner(true);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  getBodyView(BuildContext context) {
    var views = <Widget>[];
    //添加搜索
    var searchCondition = model.getSearchCondition(false);
    print("getBodyView searchCondition=$searchCondition");
    if (searchCondition != null) {
      views.add(getSearchView(
        searchCondition,
        () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SearchPage(findVehicle: false)),
          );
        },
        () {
          model.updateSearchCondition(false, null);
        },
      ));
    }
    //添加banner
    List<BannerInfo> info = model.getBannerInfoList();
    if (info != null && info.length > 0) {
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
            image: new CachedNetworkImageProvider(infos[index].image),
            fit: BoxFit.fitWidth,
          );
        },
        itemHeight: 120,
        itemCount: infos.length,
        viewportFraction: 0.8,
        scale: 0.9,
        pagination: new SwiperPagination(),
        control: new SwiperControl(),
        onTap: (index) {
          try {
            launchcaller(infos[index].action);
          } catch (id) {}
        },
      ),
    );
  }

//  RefreshController _refreshController;

  /// View: 列表。
  getListView() {
    var status = model.getPassengerPageStatus();
    print("====== page status = $status ");
    if (status == PageDataStatus.READY) {
      return RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _onRefresh,
//        child: _list(),
        child: _listWrapper(),
      );
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }

  _listWrapper() {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {

          _onLoadMore();
        }
      },
      child: _list(),
    );
  }

  Widget _list() {
    var data = model.getPassengerList();
    final enablePullUp = model.passengerHasMore();
    return new ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: enablePullUp ? data.length + 1 : data.length,
      itemBuilder: (BuildContext context, int index) => index == data.length
          ? _getLoadMore()
          : ItemView2(data[index], index, 0),
      separatorBuilder: (BuildContext context, int index) {
        if (index != null && listUrl != null && index == cardIndex) {
          return _getListADItem();
        } else {
          return Container();
        }
      },
    );
  }

  _getLoadMore() {
    return Container(
        color: Colors.greenAccent,
        child: FlatButton(
          child: Text("Load More"),
          onPressed: _onLoadMore,
        ));
  }

//  getListView() {
//    var listData = model.getPassengerList();
//    print("====== listData = ${listData.length} @ ${model.hashCode}");
//
//    if (listData.length > 0) {
//      return SmartRefresher(
//        controller: _refreshController,
//        enablePullDown: true,
//        header: WaterDropHeader(),
//        onRefresh: _onRefresh,
//        onLoading: _onLoadMore(),
//        child: _list(),
////        enablePullUp: true,
//        enablePullUp: enablePullUp,
//      );
//    } else {
//      return Center(child: CircularProgressIndicator());
//    }
//  }

  bool refreshing = false;
  bool loading = false;

  Future _onRefresh() {
    return Future(() {
      if (!refreshing) {
        refreshing = true;
        print("ERROR. _onRefresh");
        model.queryPassengerList(true, done: () {
          refreshing = false;
        });
      }
    });
  }

  _onLoadMore() {
    print("INFO. _onLoadMore $loading");
    if (!loading) {
      loading = true;
      print("ERROR. _onLoadMore");
      model.queryPassengerList(false, done: () {
        loading = false;
      });
    }
  }

  _getListADItem() {
    return GestureDetector(
      child: Card(
        margin: EdgeInsets.all(8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: Image(
            image: CachedNetworkImageProvider(listUrl),
            fit: BoxFit.fitWidth,
            width: 500,
            height: 130,
          ),
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => WebViewPage('TEST', listGoto)),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
