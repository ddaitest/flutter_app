import 'package:flutter/material.dart';
import 'package:flutter_app/common/common.dart';
import 'package:flutter_app/manager/api.dart';
import 'dart:convert';
import 'package:flutter_app/manager/beans.dart';
import 'package:package_info/package_info.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:equatable/equatable.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef DaiListener = int Function(bool hasMore);

class MainModel extends Model {
  /// Wraps [ScopedModel.of] for this [Model].
  static MainModel of(BuildContext context) =>
      ScopedModel.of<MainModel>(context, rebuildOnChange: true);

  //Search begin.
  ///人找车的筛选条件
  SearchCondition _findVehicle;

  ///车找人的筛选条件
  SearchCondition _findPassenger;

  ///获取筛选条件
  SearchCondition getSearchCondition(bool forFindVehicle) {
    return forFindVehicle ? _findVehicle : _findPassenger;
  }

  final PAGE_SIZE = 5;

  PageDataStatus _passengerStatus = PageDataStatus.LOADING;

  PageDataStatus _vehicleStatus = PageDataStatus.LOADING;

  getPassengerPageStatus() => _passengerStatus;

  getVehiclePageStatus() => _vehicleStatus;

  bool _passengerHasMore = true;

  bool _vehicleHasMore = true;

  passengerHasMore() => _passengerHasMore;

  vehicleHasMore() => _vehicleHasMore;

  ///更新筛选条件
  updateSearchCondition(bool forFindVehicle, SearchCondition newCondition) {
    if (forFindVehicle) {
      //如果条件改变，根据新的条件，刷新数据
      if (_findVehicle != newCondition) {
        _findVehicle = newCondition;
        queryVehicleList(true, done: () {});
      }
    } else {
      //如果条件改变，根据新的条件，刷新数据
      if (_findPassenger != newCondition) {
        _findPassenger = newCondition;
        queryPassengerList(true, done: () {});
      }
    }
    notifyListeners();
  }

  //List Data
  ///人找车的数据
  List<Event> _vehicleList = new List();

  ///车找人的数据
  List<Event> _passengerList = new List();

  ///车找人的数据
  List<BannerInfo> _bannerList = new List();

  getVehicleList() => _vehicleList;

  getPassengerList() => _passengerList;

  getBannerInfoList() => _bannerList;

  /// 请求 Passenger List, num after 表示从哪个timestamp 开始load more.
  queryPassengerList(bool refresh, {Function done}) async {
    if (!refresh && !_passengerHasMore) {
      print("ERROR. NO MORE, NO REQUEST");
      return;
    }
    Response response;
    Event after = refresh ? null : _passengerList.last;
    if (_findPassenger == null) {
      response = await API.queryEvents(
        FindType.FindPassenger.index,
        afterId: after?.id,
        pageSize: PAGE_SIZE,
      );
    } else {
      response = await API.searchEvents(
        FindType.FindPassenger.index,
        afterId: after?.id,
        afterTime: after?.time,
        pageSize: PAGE_SIZE,
        time: _findPassenger.time,
        dropOff: _findPassenger.dropoff,
        pickup: _findPassenger.pickup,
      );
    }
    final parsed = json.decode(response.data);
    final resultCode = parsed["code"] ?? 0;
    final resultData = parsed["data"];
    if (resultCode == 200 && resultData != null) {
      final dataList = resultData["list"];
      num hasMore = resultData["has_more"] ?? 0;
      if (dataList != null) {
        final newData =
            dataList.map<Event>((json) => Event.fromJson(json)).toList();
        if (refresh) {
          //refresh
          _passengerList.clear();
        }
        _passengerList.addAll(newData);
      }
      _passengerHasMore = (hasMore == 1);
    }
    _passengerStatus = _passengerList.length > 0
        ? PageDataStatus.READY
        : PageDataStatus.ERROR_EMPTY;
    done();
    notifyListeners();
  }

  queryVehicleList(bool refresh, {Function done}) async {
    Response response;
    Event after = refresh ? null : _vehicleList.last;
    if (_findVehicle == null) {
      response = await API.queryEvents(
        FindType.FindVehicle.index,
        afterId: after?.id,
        pageSize: PAGE_SIZE,
      );
    } else {
      response = await API.searchEvents(
        FindType.FindVehicle.index,
        afterId: after?.id,
        afterTime: after?.time,
        pageSize: PAGE_SIZE,
        time: _findVehicle.time,
        dropOff: _findVehicle.dropoff,
        pickup: _findVehicle.pickup,
      );
    }
    final parsed = json.decode(response.data);
    final resultCode = parsed["code"] ?? 0;
    final resultData = parsed["data"];
    if (resultCode == 200 && resultData != null) {
      final dataList = resultData["list"];
      num hasMore = resultData["has_more"] ?? 0;
      if (dataList != null) {
        final newData =
            dataList.map<Event>((json) => Event.fromJson(json)).toList();
        if (after == null) {
          //refresh
          _vehicleList.clear();
        }
        _vehicleList.addAll(newData);
      }
      _vehicleHasMore = (hasMore == 1);
    }
    _vehicleStatus = _vehicleList.length > 0
        ? PageDataStatus.READY
        : PageDataStatus.ERROR_EMPTY;
    done();
    notifyListeners();
  }

//  /// 请求 Vehicle List, num after 表示从哪个timestamp 开始load more.
//  queryVehicleList2(num after, Function done) async {
//    var condition = _findVehicle ?? SearchCondition();
//    Response response = await API.queryEvents(
//      FindType.FindVehicle.index,
//      after: after,
//      pickup: condition.pickup,
//      dropOff: condition.dropoff,
//      time: condition.time,
//    );
//    final parsed = json.decode(response.data);
//    var resultCode = parsed["code"] ?? 0;
//    var resultData = parsed["data"];
//    if (resultCode == 200 && resultData != null) {
//      final newData =
//          resultData.map<Event>((json) => Event.fromJson(json)).toList();
//
//      if (after == 0) {
//        _vehicleList.clear();
//      }
//      _vehicleList.addAll(newData);
//      done();
//      notifyListeners();
//    }
//  }

  //Search end.
  queryBanner(bool forFindVehicle) async {
    Response response = await API.queryBanners(0);
    final parsed = json.decode(response.data);
    var resultCode = parsed['code'] ?? 0;
    var resultData = parsed['data'];
    if (resultCode == 200 && resultData != null) {
      final newData = resultData
          .map<BannerInfo>((json) => BannerInfo.fromJson(json))
          .toList();
      _bannerList.clear();
      _bannerList.addAll(newData);
      notifyListeners();
    }
  }

  ///广告数据
  queryAdData() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    print("ERROR. packageInfo.version ${packageInfo.version}");
    print("ERROR. packageInfo.buildNumber ${packageInfo.buildNumber}");

    Response response = await API.queryAD();
    final parsed = json.decode(response.data);
    var resultCode = parsed['code'] ?? 0;
    var resultData = parsed['data'];
    if (resultCode == 200 && resultData != null) {
      final newData =
          resultData.map<AdInfo>((json) => AdInfo.fromJson(json)).toList();
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      for (var ad in newData) {
        switch (ad.type) {
          case 0: //Splash
            sharedPreferences.setString("splash_url", ad.image);
            sharedPreferences.setString("splash_goto", ad.action);
            break;
          case 1: //Home
            sharedPreferences.setString("showCard_url", ad.image);
            sharedPreferences.setString("showCard_goto", ad.action);
            break;
          case 2: //List

            break;
        }
      }
    }
  }

//  getAdData() async {
//    Response response = await ApiForAd.queryAdData();
//    final parsed = response.data;
//    final data = AdInfo.fromJson(parsed[0]);
//    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//    sharedPreferences.setString("splash_url", data.splashUrl);
//    sharedPreferences.setString("splash_goto", data.splashGoto);
//    sharedPreferences.setString("showCard_url", data.showCardUrl);
//    sharedPreferences.setString("showCard_goto", data.showCardGoto);
//    sharedPreferences.setInt("card_index", data.cardIndex);
//    sharedPreferences.setString("list_url", data.listUrl);
//    sharedPreferences.setString("list_goto", data.listGoto);
//  }

  ///升级数据
  getUpdateData() async {
    Response response = await ApiForUpdate.queryUpdateData();
    final parsed = response.data;
    final data = UpdateInfo.fromJson(parsed[0]);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("update_message", data.updateMessage);
    sharedPreferences.setString("update_url", data.updateUrl);
    sharedPreferences.setBool("must_update", data.mustUpdate);
    sharedPreferences.setBool("show_update", data.showUpdate);
  }
}

///搜索条件
class SearchCondition extends Equatable {
  SearchCondition({this.time, this.pickup, this.dropoff})
      : super([time, pickup, dropoff]);

  ///时间
  num time;

  ///起点
  String pickup = "";

  ///终点
  String dropoff = "";
}
