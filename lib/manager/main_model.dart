import 'package:flutter/material.dart';
import 'package:flutter_app/common/common.dart';
import 'package:flutter_app/manager/api.dart';
import 'dart:convert';
import 'package:flutter_app/manager/beans.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:equatable/equatable.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  ///更新筛选条件
  updateSearchCondition(bool forFindVehicle, SearchCondition newCondition) {
    if (forFindVehicle) {
      //如果条件改变，根据新的条件，刷新数据
      if (_findVehicle != newCondition) {
        _findVehicle = newCondition;
        queryVehicleList(0);
      }
    } else {
      //如果条件改变，根据新的条件，刷新数据
      if (_findPassenger != newCondition) {
        _findPassenger = newCondition;
        queryPassengerList(0);
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

  /// 请求 Vehicle List, num after 表示从哪个timestamp 开始load more.
  queryVehicleList(num after) async {
    var condition = _findVehicle ?? SearchCondition();
    Response response = await API.queryEvents(
      FindType.FindVehicle.index,
      after: after,
      pickup: condition.pickup,
      dropOff: condition.dropoff,
      time: condition.time,
    );
    final parsed = json.decode(response.data);
    var resultCode = parsed["code"] ?? 0;
    var resultData = parsed["data"];
    if (resultCode == 200 && resultData != null) {
      final newData =
          resultData.map<Event>((json) => Event.fromJson(json)).toList();
      _vehicleList.clear();
      _vehicleList.addAll(newData);
      notifyListeners();
    }
  }

  /// 请求 Passenger List, num after 表示从哪个timestamp 开始load more.
  queryPassengerList(num after) async {
    var condition = _findVehicle ?? SearchCondition();
    Response response = await API.queryEvents(
      FindType.FindPassenger.index,
      after: after,
      pickup: condition.pickup,
      dropOff: condition.dropoff,
      time: condition.time,
    );
//    final parsed = json.decode(response.data).cast<Map<String, dynamic>>();
    final parsed = json.decode(response.data);
    var resultCode = parsed["code"] ?? 0;
    var resultData = parsed["data"];
    if (resultCode == 200 && resultData != null) {
      final newData =
          resultData.map<Event>((json) => Event.fromJson(json)).toList();
      _passengerList.clear();
      _passengerList.addAll(newData);
      notifyListeners();
    }
  }

  //Search end.
  queryBanner(bool forFindVehicle) async {
//    var condition = _findVehicle ?? SearchCondition();
    Response response = await API.queryBanners(0);
    print(response.data);
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
  getAdData() async {
    Response response = await ApiForAd.queryAdData();
    final parsed = response.data;
    final data = AdInfo.fromJson(parsed[0]);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("splash_url", data.splashUrl);
    sharedPreferences.setString("splash_goto", data.splashGoto);
    sharedPreferences.setString("showCard_url", data.showCardUrl);
    sharedPreferences.setString("showCard_goto", data.showCardGoto);
    sharedPreferences.setInt("card_index", data.cardIndex);
    sharedPreferences.setString("list_url", data.listUrl);
    sharedPreferences.setString("list_goto", data.listGoto);
  }

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
