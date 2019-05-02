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

  @override
  Widget build(BuildContext context) {
    model = MainModel.of(context);
    return new Scaffold(
        key: _scaffoldKey,
        floatingActionButton: FloatingActionButton(
          onPressed: null,
          child: Icon(Icons.add),
        ),
        body: getBodyView(context));
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
//      model = model ?? MainModel.of(context);
      MainModel.of(context).queryVehicleList(0);
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
    if (model.getVehicleList().length > 0) {
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
      separatorBuilder: (context, index) =>
          Container(), //TODO wait to insert AD.
    ).build(context);
  }

  @override
  bool get wantKeepAlive => true;

//  Future<void> showDialogCard() async {
//    return showDialog<void>(
//      context: context,
//      barrierDismissible: true, // user must tap button!
//      builder: (BuildContext context) {
//        return AlertDialog(
//          content: SingleChildScrollView(
//            child: Image.asset(
//              'images/DialogAd.png',
//              fit: BoxFit.cover,
//              width: 300,
//              height: 500,
//            ),
//          ),
////          actions: <Widget>[
////            FlatButton(
////              child: Text('继续'),
////              onPressed: () {
////                Navigator.of(context).pop();
////              },
////            ),
////          ],
//        );
//      },
//    );
//  }
}
