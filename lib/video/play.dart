import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/video/bean.dart';
import 'package:flutter_app/video/styles.dart';
import 'package:flutter_app/video/xxx.dart';
import 'package:video_player/video_player.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class PlayPage extends StatelessWidget {
  final VideoInfo info;

  PlayPage(this.info);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("视频详情"),
        ),
        body: Column(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Text(
              "刑法概说与犯罪概说",
              style: fontTitle,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "刑法的基本原则作为刑法概说中的重要内容，历来是考试出题的重点。其中罪刑法定原则又是重中之重，对于罪行法定的基本内容要做到掌握并能清楚辨析。",
              style: fontDesc,
            ),
            SizedBox(
              height: 10,
            ),
            NetworkPlayerLifeCycle(
              'http://starhalo.oss-ap-south-1.aliyuncs.com/sh/vd/00/k1/v0ft0000k1.mp4',
              (BuildContext context, VideoPlayerController controller) =>
                  AspectRatioVideo(controller),
            ),
          ],
        ));
  }
}
