import 'package:dio/dio.dart';
import 'package:flutter_app/manager/api.dart';

class Event {
  Event({this.time, this.start, this.end, this.phone, this.remark});

  num time;
  String start = "";
  String end = "";
  String phone = "";
  String remark = "";
  num type; //0:car 1:passenger
  num publishTime;
  String publisherId;

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      time: json['time'],
      start: json['start'],
      end: json['end'],
      phone: json['phone'],
      remark: json['remark'],
    );
  }
}

class BannerInfo {
  BannerInfo();

  String id = "";

  String image = "";
  String action = "";
}

///广告数据映射
class AdInfo {
  AdInfo(
      {this.splashUrl,
      this.splashGoto,
      this.showCardUrl,
      this.showCardGoto,
      this.listUrl,
      this.listGoto});

  String splashUrl = "";
  String splashGoto = "";
  String showCardUrl = "";
  String showCardGoto = "";
  String listUrl = "";
  String listGoto = "";

  factory AdInfo.fromJson(Map<String, dynamic> json) {
    return AdInfo(
      splashUrl: json['splash_url'],
      splashGoto: json['splash_goto'],
      showCardUrl: json['showCard_url'],
      showCardGoto: json['showCard_goto'],
      listUrl: json['list_url'],
      listGoto: json['list_goto'],
    );
  }
}

///升级数据映射
class UpdateInfo {
  UpdateInfo(
      {this.updateMessage, this.updateUrl, this.mustUpdate, this.showUpdate});

  String updateMessage;
  String updateUrl;
  bool mustUpdate;
  bool showUpdate;

  factory UpdateInfo.fromJson(Map<String, dynamic> json) {
    return UpdateInfo(
      updateMessage: json['update_message'],
      updateUrl: json['update_url'],
      mustUpdate: json['must_update'],
      showUpdate: json['show_update'],
    );
  }
}
