import 'package:dio/dio.dart';

class API {
  static Dio dio = Dio(BaseOptions(
    baseUrl: "http://39.96.16.125:8082/",
    connectTimeout: 5000,
    receiveTimeout: 3000,
//    responseType: ResponseType.plain
  ));

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

  static refreshList({Map<String, dynamic> queryParameters}) {
    return dio.get("api/event/", queryParameters: queryParameters);
  }

  static queryVehicles({num after, String pickup, String dropOff, num time}) {
    return dio.get("api/event/", queryParameters: {
      "after": after,
      "pickup": pickup,
      "drop_off": dropOff,
      "time": time
    });
  }

  static queryPassengers({num after, String pickup, String dropOff, num time}) {
    return dio.get("api/event/", queryParameters: {
      "after": after,
      "pickup": pickup,
      "drop_off": dropOff,
      "time": time
    });
  }
}
