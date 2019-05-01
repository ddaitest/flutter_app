import 'package:flutter/material.dart';
import 'package:flutter_app/manager/main_model.dart';
import 'dart:async';
import 'package:flutter_app/pages/home.dart';
import 'package:flutter_app/pages/publish.dart';
import 'package:flutter_app/pages/search.dart';
import 'package:flutter_app/pages/splash.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:scoped_model/scoped_model.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new ScopedModel<MainModel>(
        model: MainModel(),
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
