import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_app/manager/manager.dart';
import 'package:flutter_app/pages/home.dart';

//import 'package:flutter_app/common/DateUtil.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';

final TextStyle fontTime = const TextStyle(
    fontSize: 18.0, fontWeight: FontWeight.w500, color: Colors.black87);
final TextStyle fontTarget = const TextStyle(
    fontSize: 20.0, color: Colors.black87, fontWeight: FontWeight.bold);
final TextStyle fontX = const TextStyle(fontSize: 14.0, color: Colors.black54);
final TextStyle fontCall =
    TextStyle(fontSize: 14.0, color: Colors.black, fontWeight: FontWeight.w500);

class ItemView extends StatelessWidget {
  final Event event;
  final int index;
  final int type;

  ItemView(this.event, this.index, this.type);

  void _launchcaller(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _getIcon() {
    if (type == 0) {
      return Icons.departure_board;
    } else {
      return Icons.group_add;
    }
  }

  _getAvatar() {
    return Container(
      width: 50,
      margin: EdgeInsets.only(left: 16, right: 16),
      height: 50,
      child: Icon(
        _getIcon(),
        color: Colors.white,
      ),
      decoration: BoxDecoration(
        color: Colors.blue,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.blue, width: 2),
      ),
    );
  }

  _getStartTime() {
    final dt = new DateTime.fromMillisecondsSinceEpoch(event.time);
    return Row(
      children: <Widget>[
        Icon(
          Icons.access_time,
          color: Colors.blueAccent,
          size: 20.0,
        ),
        SizedBox(width: 8.0),
        Text(
          new DateFormat("HH:mm  y年M月d日").format(dt),
          style: fontTime,
        ),
      ],
    );
  }

  _getStart2End() {
    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 5),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            child: Text(
              event.start ?? "start",
              style: fontTarget,
              textAlign: TextAlign.left,
            ),
            flex: 1,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 30),
            child: Icon(
              Icons.forward,
            ),
          ),
          Expanded(
            child: Text(
              event.end ?? "end",
              style: fontTarget,
              textAlign: TextAlign.center,
            ),
            flex: 1,
          ),
        ],
      ),
    );
  }

  _getRemark() {
    return Row(
      children: <Widget>[
        Text(
          event.remark ?? "remark",
          style: fontX,
        ),
      ],
    );
  }

  _getAction() {
    return Row(
      children: <Widget>[
        Expanded(
            child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(
              event.phone ?? "phone",
              style: fontX,
            ),
          ],
        )),
        FlatButton(
          onPressed: () {
            _launchcaller('tel:' + event.phone);
          },
          child: Row(
            children: <Widget>[
              Icon(
                Icons.call,
                size: 16.0,
                color: Colors.blueAccent,
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                "打电话",
                style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 16, right: 16),
      child: Row(
        children: <Widget>[
          _getAvatar(),
          Expanded(
            child: Column(
              children: event.remark != null && event.remark.isNotEmpty
                  ? <Widget>[
                      _getStartTime(),
                      _getStart2End(),
                      _getRemark(),
                      Divider(),
                      _getAction(),
                    ]
                  : <Widget>[
                      _getStartTime(),
                      _getStart2End(),
                      Divider(),
                      _getAction(),
                    ],
            ),
            flex: 1,
          ),
        ],
      ),
    );
  }
}
