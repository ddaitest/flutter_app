import 'dart:async';
import 'dart:convert';
import 'package:flutter_app/manager/manager.dart';
import 'package:flutter_app/common/common.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dio/dio.dart';
import 'package:flutter_app/pages/home.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FirstTab extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new FirstState();
  }
}

class FirstState extends State<FirstTab> with AutomaticKeepAliveClientMixin {
  String showCard_url;
  String showCard_goto;
  String list_url;
  String list_goto;
  String AdURL = "http://34.92.69.146:5000/api/ad/";
  List datalist;
  final List<Event> data = new List();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    _loadData();
    _getAdData();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      body: getContent(),
    );
  }

  _getAdData() async {
    var response = await http.get(AdURL);
    if (response.statusCode == 200) {
      datalist = jsonDecode(response.body);
      for (var i in datalist) {
        list_url = i['list_url'];
        list_goto = i['list_goto'];
        showCard_goto = i['showCard_goto'];
        showCard_url = i['showCard_url'];
      }
    }
    if (showCard_url != null && showCard_url != '') {
      Timer(const Duration(seconds: 2), () {
        showDialogCard();
      });
    }
  }

  void _loadData() async {
    upgradeCard();
    String dataURL = "http://39.96.16.125:8082/api/event/";
    http.Response response = await http.get(dataURL);
    print("DDAI= end=${response.body}");
    final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
    final newData = parsed.map<Event>((json) => Event.fromJson(json)).toList();
    data.clear();
    data.addAll(newData);
    setState(() {
      data.clear();
      data.addAll(newData);
    });
  }

  getContent() {
    if (data.length > 0) {
      return RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: () => new Future(() => _loadData()),
        child: _list(),
      );
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }

  Widget _list() {
    return new ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: data.length,
      itemBuilder: (BuildContext context, int index) {
        return _buildRow(data[index], index);
      },
    ).build(context);
  }

  Widget _buildRow(Event event, int index) {
//    print('LC############ $index');
    return new Card(
      child: ItemView(event, index, 0),
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    // Dispose of the Tab Controller
    super.dispose();
  }

  Future<void> showDialogCard() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
            backgroundColor: Colors.transparent,
            content: GestureDetector(
              onTap: () {
                launch(showCard_goto);
                Navigator.of(context).pop();
              },
              child: CachedNetworkImage(
                imageUrl: showCard_url,
                fit: BoxFit.cover,
                width: 500,
                height: 300,
              ),
            ));
      },
    );
  }

  Future<void> upgradeCard() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
            backgroundColor: Colors.transparent,
            content: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: ExactAssetImage('images/Upgrade_Card.png'),
                    fit: BoxFit.cover),
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.bottomCenter,
                    margin: EdgeInsets.only(top: 180.0),
                    child: Text(
                      "1、在你需要的每个地方\n2、载着你去往每个地方\n3、无佣金，乘客少花钱\n4、不抽成，车主多挣钱",
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.fromLTRB(15, 42, 15, 40),
                    child: MaterialButton(
                      minWidth: 250,
                      height: 50,
                      color: Colors.blue,
                      onPressed: null,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
//                      padding: EdgeInsets.only(
//                          top: 10, bottom: 10, left: 15, right: 15),
                      child: Text(
                        '立即更新',
                        style: TextStyle(fontSize: 17, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ));
      },
    );
  }
}
