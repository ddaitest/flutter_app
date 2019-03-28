import 'package:fluro/fluro.dart';
import 'package:flutter_app/pages/home.dart';
import 'package:flutter_app/pages/publish.dart';
import 'package:flutter_app/pages/search.dart';

class Routers {
  static Router router;
  static String pageHome = "/";
  static String pageSearch = "/search";
  static String pagePublish = "/publish";

  static void config(Router router) {
    router.define(pageHome,
        handler: Handler(handlerFunc: (context, params) => HomePage()));
    router.define(pageSearch,
        handler: Handler(handlerFunc: (context, params) => SearchPage()));
    router.define(pagePublish,
        handler: Handler(handlerFunc: (context, params) => PublishPage()));
    Routers.router = router;
  }
}
