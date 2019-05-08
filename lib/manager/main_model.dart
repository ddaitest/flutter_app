import 'package:flutter/material.dart';
import 'package:flutter_app/manager/api.dart';
import 'dart:convert';
import 'package:flutter_app/manager/beans.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:equatable/equatable.dart';
import 'package:dio/dio.dart';

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

  getVehicleList() => _vehicleList;

  getPassengerList() => _passengerList;

  /// 请求 Vehicle List, num after 表示从哪个timestamp 开始load more.
  queryVehicleList(num after) async {
    var condition = _findVehicle ?? SearchCondition();
    Response response = await API.queryVehicles(
      after: after,
      pickup: condition.pickup,
      dropOff: condition.dropoff,
      time: condition.time,
    );
    final parsed = response.data.cast<Map<String, dynamic>>();
    final newData = parsed.map<Event>((json) => Event.fromJson(json)).toList();
    _vehicleList.clear();
    _vehicleList.addAll(newData);
    print("====== notifyListeners ${newData.length}");
    notifyListeners();
  }

  /// 请求 Passenger List, num after 表示从哪个timestamp 开始load more.
  queryPassengerList(num after) async {
    var condition = _findVehicle ?? SearchCondition();
    Response response = await API.queryPassengers(
      after: after,
      pickup: condition.pickup,
      dropOff: condition.dropoff,
      time: condition.time,
    );
    print("DDAI= end=${response.data}");
    final parsed = json.decode(response.data).cast<Map<String, dynamic>>();
    final newData = parsed.map<Event>((json) => Event.fromJson(json)).toList();
    _passengerList.clear();
    _passengerList.addAll(newData);
    notifyListeners();
  }

  //Search end.
  ///Banner
  num getBannerData() {
    return 1;
  }

  queryBanner() {}
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
