import 'package:amap_base/amap_base.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/home.dart';
import 'package:amap_base/src/search/model/poi_item.dart';

import 'manager/main_model.dart';

/**
 * hope_ios	30a97518348a9b6b8cc652b2dbabe3a2
 * hope_android	926c883e181700a1d3f0f01c7ed8ea7b
 *
 * <meta-data
    android:name="com.amap.api.v2.apikey"
    android:value="926c883e181700a1d3f0f01c7ed8ea7b"/>

 */
class TestState extends State<HomePage> {
  MainModel model;

  @override
  void initState() {
    MainModel.initAmap();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).primaryColor;
    model = MainModel.of(context);
    List<PoiItem> data = model.getSearchResult();
    return new Scaffold(
        appBar: AppBar(
          title: Text("Test"),
          actions: <Widget>[
//          new IconButton(icon: const Icon(Icons.search), onPressed: search)
          ],
        ),
        body: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[

                  RaisedButton(
                    onPressed: () async {
                      if (await Permissions().requestPermission()) {
                        model.locate();
                      } else {
                        Scaffold.of(context)
                            .showSnackBar(SnackBar(content: Text('权限不足')));
                      }
                    },
                    child: Text("Locate()"),
                  ),

                  Expanded(child: Text(model.currentPOI)),
                ],
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              ),
              TextField(
                  decoration: InputDecoration(
                    hintText: '请输入出发点',
                    icon: Icon(Icons.pin_drop),
                    labelText: '出发地',
                  ),
                  onChanged: search),
              Flexible(
                child: ListView.builder(
                  itemBuilder: (BuildContext context, int index) =>
                      ListTile(title: Text(data[index].title)),
                  itemCount: data.length,
                ),
              )
            ],
          ),
        ));
  }

  search(String keyword) {
    print("INFO. searchController changed. $keyword");
    if (keyword.length > 0) {
      model.searchPOI(keyword);
    }
  }
}
