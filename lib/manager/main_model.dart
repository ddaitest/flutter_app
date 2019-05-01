import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class MainModel extends Model {
  /// Wraps [ScopedModel.of] for this [Model].
  static MainModel of(BuildContext context) =>
      ScopedModel.of<MainModel>(context, rebuildOnChange: true);

  //Search begin.
  SearchCondition findVehicle;
  SearchCondition findPassenger;

  SearchCondition getSearchCondition(bool forFindVehicle) {
    return forFindVehicle ? findVehicle : findPassenger;
  }

  updateSearchCondition(SearchCondition newCondition) {
    findVehicle = newCondition;
    notifyListeners();
  }

  //Search end.
  ///Banner
  num getBannerData() {
    return 1;
  }

  queryBanner() {}

  getFirstList() {}

  queryFirstList() {}
}

///搜索条件
class SearchCondition {
  SearchCondition({this.time, this.pickup, this.dropoff});

  ///时间
  num time;

  ///起点
  String pickup = "";

  ///终点
  String dropoff = "";
}
