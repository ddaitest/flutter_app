import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/ItemView2.dart';
import 'package:flutter_app/common/common.dart';
import 'package:flutter_app/common/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';

const Color c4 = Color(0xFF13D3CE);
const Color c5 = Color(0xFFFF7200);
final TextStyle mainTitleFont = const TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w500,
);
final TextStyle subTitleFont = const TextStyle(
  fontSize: 16,
);

class DetailPage extends StatefulWidget {
  final String phone;
  final String from;
  final String to;
  final String remark;
  final num time;

  DetailPage(this.phone, this.from, this.to, this.remark, this.time);

  @override
  State<DetailPage> createState() {
    return DetailState();
  }
}

class DetailState extends State<DetailPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dt = new DateTime.fromMillisecondsSinceEpoch(widget.time);
    var date = dateFormat.format(dt);
    var time = timeFormat.format(dt);
    return Scaffold(
        appBar: AppBar(
          title: Text('拼车详情'),
        ),
        body: Center(
          child: ListView(padding: EdgeInsets.all(16), children: <Widget>[
            _getContainer(
              '路线',
              Icons.location_city,
              mainTitleFont,
            ),
            Container(
                width: 360.0,
                child: Card(
                  child: ListTile(
                    leading: Icon(
                      Icons.access_time,
                    ),
                    title: Text(
                      '时间',
                      style: mainTitleFont,
                      softWrap: true,
                    ),
                    subtitle: Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Row(
                          children: <Widget>[
                            Text(
                              date,
                              style: subTitleFont,
                            ),
                            Text(
                              time,
                              style: subTitleFont,
                            ),
                          ],
                        )),
                  ),
                )),
            Container(
                width: 360.0,
                child: Card(
                  child: ListTile(
                    leading: Icon(
                      Icons.event_note,
                    ),
                    title: Text(
                      '备注',
                      style: mainTitleFont,
                      softWrap: true,
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        widget.remark,
                        style: subTitleFont,
                      ),
                    ),
                  ),
                )),
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: MaterialButton(
                height: 50,
                color: Colors.blue,
                child: Text(
                  '马上联系 ' + '(' + widget.phone + ')',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                onPressed: () {
                  launchcaller('tel:' + widget.phone);
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: GestureDetector(
                child: Card(
                  margin: EdgeInsets.all(8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: Image(
                      image: CachedNetworkImageProvider(
                          "https://img.zcool.cn/community/012de8571049406ac7251f05224c19.png@1280w_1l_2o_100sh.png"),
                      fit: BoxFit.cover,
                      width: 500,
                      height: 300,
                    ),
                  ),
                ),
//                onTap: () {
//                  launch(listGoto);
//                },
              ),
            )
          ]),
        ));
  }

  Widget _getContainer(String title, IconData leadIcon, mainTitleFont,
      {IconData trailIcon}) {
    return Container(
        width: 360.0,
        child: Card(
          child: ListTile(
            leading: Icon(leadIcon),
            trailing: Icon(trailIcon),
            title: Text(
              title,
              style: mainTitleFont,
              softWrap: true,
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Column(
                children: <Widget>[
                  _getInfoView(
                      Icons.trip_origin, c4, widget.from, subTitleFont),
                  _getInfoView(Icons.trip_origin, c5, widget.to, subTitleFont)
                ],
              ),
            ),
          ),
        ));
  }

  _getSubtitle() {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Column(
        children: <Widget>[
          _getInfoView(Icons.trip_origin, c4, widget.from, subTitleFont),
          _getInfoView(Icons.trip_origin, c5, widget.to, subTitleFont)
        ],
      ),
    );
  }

  ///公用ICON + TEXT
  _getInfoView(IconData icon, Color color, String info, TextStyle style) {
    return Row(
      children: <Widget>[
        Icon(
          icon,
          color: color,
          size: 14.0,
        ),
        SizedBox(width: 6),
        Expanded(
          child: Text(
            info,
            style: style,
            textAlign: TextAlign.left,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
