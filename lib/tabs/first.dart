import 'dart:async';
import 'dart:convert';
import 'package:flutter_app/manager.dart';
import 'package:flutter_app/common/common.dart';
import 'package:flutter_app/tabs/publish.dart';
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
        floatingActionButton: new FloatingActionButton(
          heroTag: "btn1",
          child: new Icon(Icons.add),
          onPressed: _add,
        ),
        body: getContent());
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _add() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PublishPage()),
    );
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
      child: ItemView(event, index,0),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
