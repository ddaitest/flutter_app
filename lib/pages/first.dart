import 'dart:async';
import 'dart:convert';
import 'package:flutter_app/manager/manager.dart';
import 'package:flutter_app/common/common.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class FirstTab extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new FirstState();
  }
}

class FirstState extends State<FirstTab> with AutomaticKeepAliveClientMixin {
  final List<Event> data = new List();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        floatingActionButton: FloatingActionButton(
          onPressed: null,
          child: Icon(Icons.add),
        ),
        body: getView());
//        body: getContent());
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    showDialogCard();
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

  getView() {
    return Container(
      child: Column(
        children: <Widget>[
          Card(
            color: Colors.blue,
            child: getSearchView(),
          ),
          Expanded(
            child: getContent(),
          ),
        ],
      ),
    );
  }

  getSearchView() {
    return Container(
      height: 50,
      padding: EdgeInsets.only(left: 8, right: 8),
      child: Row(
        children: <Widget>[
          Icon(Icons.search, color: Colors.white),
          Expanded(
            child: Text(
              "筛选:北京->天津",
              style: TextStyle(color: Colors.white),
            ),
            flex: 1,
          ),
          Icon(Icons.clear, color: Colors.white),
        ],
      ),
    );
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

  Future<void> showDialogCard() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Image.asset(
              'images/DialogAd.png',
              fit: BoxFit.cover,
              width: 300,
              height: 500,
            ),
          ),
//          actions: <Widget>[
//            FlatButton(
//              child: Text('继续'),
//              onPressed: () {
//                Navigator.of(context).pop();
//              },
//            ),
//          ],
        );
      },
    );
  }
}
