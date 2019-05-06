import 'package:flutter/material.dart';
import 'package:flutter_app/manager/api.dart';
import 'package:flutter_app/manager/main_model.dart';
import 'package:flutter_app/pages/publish.dart';
import 'package:flutter_app/pages/search.dart';
import 'package:flutter_app/pages/splash.dart';
import 'package:scoped_model/scoped_model.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  MainModel mainModel = MainModel();

  @override
  Widget build(BuildContext context) {
    print("ERROR. MyApp.build ${context.hashCode}");
    API.init();
    return new ScopedModel<MainModel>(
        model: mainModel,
        child: new MaterialApp(
          debugShowCheckedModeBanner: false,
          home: new SplashPage(),
          routes: <String, WidgetBuilder>{
            '/publish': (BuildContext context) => PublishPage(),
            '/search': (BuildContext context) => SearchPage(),
          },
        ));
  }
}
