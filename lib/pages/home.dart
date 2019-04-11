import 'package:flutter/material.dart';
import 'package:flutter_app/pages/first.dart';
import 'package:flutter_app/pages/search.dart';
import 'package:flutter_app/pages/second.dart';
import 'package:flutter_app/pages/third.dart';
import 'package:flutter_app/router/routers.dart';
import 'package:flutter_app/pages/publish.dart';

class HomePage extends StatefulWidget {
  @override
//  HomeState createState() => HomeState();
  MyHomeState createState() => MyHomeState();
}

void search() {}

// SingleTickerProviderStateMixin is used for animation
class MyHomeState extends State<HomePage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  // Create a tab controller
  TabController controller;
  int page = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    // Initialize the Tab Controller
    controller = new TabController(length: 3, vsync: this);
    controller.addListener(() {
      print("DDAI= controller.index=${controller.index}");
      page = controller.index;
      setState(() {
        page = controller.index;
      });
    });
  }

  String getTitle() {
    if (page == 0) {
      return "人找车";
    } else if (page == 1) {
      return "车找人";
    } else {
      return "关于拼车帮";
    }
  }

  @override
  void dispose() {
    // Dispose of the Tab Controller
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      // Appbar
      appBar: AppBar(
        title: Text(getTitle()),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchPage()),
              ).then((map) {
                print("callback = $map");
              });
            },
            icon: const Icon(
              Icons.search,
              size: 30,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PublishPage()),
              );
            },
            icon: const Icon(
              Icons.add_circle_outline,
              size: 30,
            ),
          ),
          SizedBox(width: 10),
//          Padding(
//            padding: const EdgeInsets.only(left: 30.0, right: 20.0),
//            child:
//          ),
        ],
      ),
      // Set the TabBar view as the body of the Scaffold
      body: new TabBarView(
        // Add tabs as widgets
        children: <Widget>[new FirstTab(), new SecondTab(), new ThirdTab()],
        // set the controller
        controller: controller,
      ),
      // Set the bottom navigation bar

      bottomNavigationBar: new Material(
        // set the color of the bottom navigation bar
        color: Colors.blue,
        // set the tab bar as the child of bottom navigation bar
        child: new TabBar(
          tabs: <Tab>[
            new Tab(
              // set icon to the tab
              icon: new Icon(Icons.directions_car),
            ),
            new Tab(
              icon: new Icon(Icons.record_voice_over),
            ),
            new Tab(
              icon: new Icon(Icons.build),
            ),
          ],
          // setup the controller
          controller: controller,
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
