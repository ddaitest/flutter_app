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
    String apiUrl = 'http://192.168.123.171:5000/api/ad';
    Response response = await Dio().get(apiUrl);
    Map<String, dynamic> json_data = jsonDecode(response.data);
    showCard_url = json_data['showCard_url'];
    showCard_goto = json_data['showCard_goto'];
    print('LC ############# $showCard_url');
    print('LC ############# $showCard_goto');
    if (showCard_url != null){
      showDialogCard();
    }else if(showCard_url != ''){
      showDialogCard();
    }
  }

  void _loadData() async {
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
}
