import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_app/common/common.dart';

class API {
  static Dio dio = Dio(BaseOptions(
//      baseUrl: "http://localhost:8082/",
    baseUrl: "http://39.96.16.125:8082/",
      connectTimeout: 5000,
      receiveTimeout: 3000,
      responseType: ResponseType.plain));

  static InterceptorsWrapper _interceptorsWrapper = InterceptorsWrapper(
    onRequest: (RequestOptions options) {
      print(">> ${options.hashCode} ${options.uri.toString()}");
      return options;
    },
    onResponse: (Response response) {
      print("<< ${response.data}");
      return response; // continue
    },
    onError: (DioError e) {
      print("xx ${e.message}");
      return e; //continue
    },
  );

  static init() {
    if (!dio.interceptors.contains(_interceptorsWrapper)) {
      dio.interceptors.add(_interceptorsWrapper);
    }
  }

//  static refreshList({Map<String, dynamic> queryParameters}) {
//    return dio.get("api/event/", queryParameters: queryParameters);
//  }

  static queryEvents(num pageType,
      {num after, String pickup, String dropOff, num time}) {
    var params = Map<String, dynamic>();
    params['page_type'] = pageType;

    if (after != null && after > 1) {
      params['after'] = after;
    }
    if (pickup != null) {
      params['pickup'] = pickup;
    }
    if (dropOff != null) {
      params['drop_off'] = dropOff;
    }
    if (time != null && time > 1) {
      params['time'] = time;
    }
    return dio.get("api/event/", queryParameters: params);
  }

  static queryBanners(num pageType) {
    return dio.get("api/banner/", queryParameters: {
      "page_type": pageType,
    });
  }
}

///广告相关api请求
class ApiForAd {
  static Dio dio = Dio(BaseOptions(
    baseUrl: "http://34.92.69.146:5000/",
    responseType: ResponseType.json,
  ));

  static InterceptorsWrapper _interceptorsWrapper = InterceptorsWrapper(
    onRequest: (RequestOptions options) {
      return options;
    },
    onResponse: (Response response) {
      return response; // continue
    },
    onError: (DioError e) {
      return e; //continue
    },
  );

  static init() {
    if (!dio.interceptors.contains(_interceptorsWrapper)) {
      dio.interceptors.add(_interceptorsWrapper);
    }
  }

  static queryAdData() {
    return dio.get("api/ad/");
  }
}

///升级相关api请求
class ApiForUpdate {
  static Dio dio = Dio(BaseOptions(
    baseUrl: "http://34.92.69.146:5000/",
    responseType: ResponseType.json,
  ));

  static InterceptorsWrapper _interceptorsWrapper = InterceptorsWrapper(
    onRequest: (RequestOptions options) {
      return options;
    },
    onResponse: (Response response) {
      return response; // continue
    },
    onError: (DioError e) {
      return e; //continue
    },
  );

  static init() {
    if (!dio.interceptors.contains(_interceptorsWrapper)) {
      dio.interceptors.add(_interceptorsWrapper);
    }
  }

  static queryUpdateData() {
    return dio.get("api/update/");
  }
}
