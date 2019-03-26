import 'package:flutter/material.dart';
import 'package:flutter_app/tabs/first.dart';
import 'package:flutter_app/tabs/second.dart';
import 'package:flutter_app/tabs/third.dart';
import 'package:flutter_app/video/videos.dart';

class VideoPage extends StatefulWidget {
  @override
  MyVideoState createState() => MyVideoState();
}

void search() {}

// SingleTickerProviderStateMixin is used for animation
class MyVideoState extends State<VideoPage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  // Create a tab controller
  TabController controller;
  int page = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    // Initialize the Tab Controller
    controller = new TabController(length: 7, vsync: this);
    controller.addListener(() {
      print("DDAI= controller.index=${controller.index}");
      page = controller.index;
      setState(() {
        page = controller.index;
      });
    });
  }

//  String getTitle() {
//    if (page == 0) {
//      return "人找车";
//    } else if (page == 1) {
//      return "车找人";
//    } else {
//      return "关于";
//    }
//  }

  @override
  void dispose() {
    // Dispose of the Tab Controller
    controller.dispose();
    super.dispose();
  }

  _getTabs() {
    return TabBar(
      tabs: <Tab>[
        new Tab(
          // set icon to the tab
          text: "宪法类",
        ),
        new Tab(
          text: "刑法类",
        ),
        new Tab(
          text: "行政法类",
        ),
        new Tab(
          text: "民商法类",
        ),
        new Tab(
          text: "程序法类",
        ),
        new Tab(
          text: "社会法类",
        ),
        new Tab(
          text: "经济法类",
        ),
      ],
      controller: controller,
      isScrollable: true,
    );
  }

  _getTabView() {
    return <Widget>[
      new VideoTab(1),
      new VideoTab(2),
      new VideoTab(3),
      new VideoTab(4),
      new VideoTab(5),
      new VideoTab(6),
      new VideoTab(7),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      // Appbar
      appBar: new AppBar(
        // Title
//        title: new Text(getTitle()),
//        actions: <Widget>[
//          new IconButton(icon: const Icon(Icons.search), onPressed: null)
//        ],
        // Set the background color of the App Bar
        flexibleSpace: SafeArea(
          child: _getTabs(),
        ),

        backgroundColor: Colors.blue,
      ),
      // Set the TabBar view as the body of the Scaffold
      body: new TabBarView(
        // Add tabs as widgets
        children: _getTabView(),
        // set the controller
        controller: controller,
      ),
      // Set the bottom navigation bar

//      bottomNavigationBar: new Material(
//        // set the color of the bottom navigation bar
//        color: Colors.blue,
//        // set the tab bar as the child of bottom navigation bar
//        child: new TabBar(
//          tabs: <Tab>[
//            new Tab(
//              // set icon to the tab
//              icon: new Icon(Icons.departure_board),
//            ),
//            new Tab(
//              icon: new Icon(Icons.group_add),
//            ),
//            new Tab(
//              icon: new Icon(Icons.favorite),
//            ),
//          ],
//          // setup the controller
//          controller: controller,
//        ),
//      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
