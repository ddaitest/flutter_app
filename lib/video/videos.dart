import 'dart:async';
import 'dart:convert';
import 'package:flutter_app/manager/manager.dart';
import 'package:flutter_app/common/common.dart';
import 'package:flutter_app/pages/publish.dart';
import 'package:flutter_app/video/bean.dart';
import 'package:flutter_app/video/play.dart';
import 'package:flutter_app/video/styles.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class VideoTab extends StatefulWidget {
  final int type;

  VideoTab(this.type);

  @override
  State<StatefulWidget> createState() {
    return new VideoState(type);
  }
}

class VideoState extends State<VideoTab> with AutomaticKeepAliveClientMixin {
  final List<Event> data = new List();
  final int type;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  VideoState(this.type);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        floatingActionButton: new FloatingActionButton(
          heroTag: "btn$type",
          child: new Icon(Icons.search),
          onPressed: _search,
        ),
        body: getContent());
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _showDetail(Event event) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PlayPage(new VideoInfo())),
    );
  }

  void _search() {
//    Navigator.push(
//      context,
//      MaterialPageRoute(builder: (context) => PublishPage()),
//    );
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
    return new GestureDetector(
      child: Card(child: VideoItem(event)),
      onTap: () {
        _showDetail(event);
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class VideoItem extends StatelessWidget {
  final Event event;

  VideoItem(this.event);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      children: <Widget>[
        CachedNetworkImage(
          height: 120,
          width: 120,
          placeholder: (context, url) => new CircularProgressIndicator(),
          imageUrl:
              'http://att.xuefa.com/forum/201902/12/205258h2pvds63calbvyku.png',
//          imageUrl: 'https://picsum.photos/250?image=9',
        ),
        Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.all(16),
              height: 120,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "刑法概说与犯罪概说",
                    style: fontTitle,
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    "刑法的基本原则作为刑法概说中的重要内容，历来是考试出题的重点。其中罪刑法定原则又是重中之重，对于罪行法定的基本内容要做到掌握并能清楚辨析。",
                    style: fontDesc,
                    softWrap: true,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            )),
      ],
    );
  }
}
