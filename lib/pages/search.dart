import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/common/date_time_picker.dart';
import 'package:flutter_app/manager/main_model.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class SearchPage extends StatelessWidget {
  ///表示从哪个页面进来的。 true = 人找车；false = 车找人；
  final bool findVehicle;

  SearchPage({Key key, @required this.findVehicle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("筛选 " + (findVehicle ? "人找车" : "车找人")),
        ),
        body: MyCustomForm(findVehicle));
  }
}

class MyCustomForm extends StatefulWidget {
  final bool findVehicle;

  MyCustomForm(this.findVehicle);

  @override
  MyCustomFormState createState() {
    return MyCustomFormState(findVehicle);
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  final bool findVehicle;

  MyCustomFormState(this.findVehicle);

  // Create a global key that will uniquely identify the Form widget and allow
  // us to validate the form
  //
  // Note: This is a `GlobalKey<FormState>`, not a GlobalKey<MyCustomFormState>!
  final _formKey = GlobalKey<FormState>();

  final myControllerStart = TextEditingController();
  final myControllerEnd = TextEditingController();

  MainModel model;

  DateTime _fromDate = DateTime.now();
  TimeOfDay _fromTime = TimeOfDay.fromDateTime(DateTime.now());

  @override
  void dispose() {
    myControllerStart.dispose();
    myControllerEnd.dispose();
    super.dispose();
  }

  _search() {
    final x = DateTime(
      _fromDate.year,
      _fromDate.month,
      _fromDate.day,
      _fromTime.hour,
      _fromTime.minute,
    );

    model.updateSearchCondition(new SearchCondition(
        pickup: myControllerStart.text,
        dropoff: myControllerEnd.text,
        time: x.millisecondsSinceEpoch));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    model = MainModel.of(context);
    var condition = model.getSearchCondition(findVehicle);
    if (condition != null) {
      if (condition.pickup != null) {
        myControllerStart.text = condition.pickup;
      }
      if (condition.dropoff != null) {
        myControllerEnd.text = condition.dropoff;
      }
    }
    // Build a Form widget using the _formKey we created above
    return Form(
      key: _formKey,
      child: ListView(
        padding: EdgeInsets.all(16),
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(
              hintText: '请输入出发点',
              icon: Icon(Icons.pin_drop),
              labelText: '出发地',
            ),
            controller: myControllerStart,
          ),
          TextFormField(
            decoration: InputDecoration(
              hintText: '请输入目的地',
              icon: Icon(Icons.assistant_photo),
              labelText: '目的地',
            ),
            controller: myControllerEnd,
          ),
          DateTimePicker(
            labelText: '出发日期',
            selectedDate: _fromDate,
            selectedTime: _fromTime,
            selectDate: (DateTime date) {
              setState(() {
                _fromDate = date;
              });
            },
            selectTime: (TimeOfDay time) {
              setState(() {
                _fromTime = time;
              });
            },
          ),
          SizedBox(
            height: 16,
          ),
          RaisedButton(
            onPressed: () {
              // Validate will return true if the form is valid, or false if
              // the form is invalid.
              if (_formKey.currentState.validate()) {
                _search();
              }
            },
            child: Text('搜索'),
          ),
        ],
      ),
    );
  }
}
