import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/common/date_time_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

enum DialogDemoAction {
  cancel,
  discard,
  disagree,
  agree,
}

class PublishPage extends StatelessWidget {
  final bool findVehicle;

  PublishPage(this.findVehicle, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("发布"),
        ),
        body: MyCustomForm(findVehicle)
//        MyCustomForm(),
        );
  }
}

class MyCustomForm extends StatefulWidget {
  final bool findVehicle;

  MyCustomForm(this.findVehicle, {Key key}) : super(key: key);

  @override
  MyCustomFormState createState() {
    return MyCustomFormState(findVehicle);
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  ///false if vehicle.
  final bool findVehicle;

  MyCustomFormState(this.findVehicle);

  // Create a global key that will uniquely identify the Form widget and allow
  // us to validate the form
  //
  // Note: This is a `GlobalKey<FormState>`, not a GlobalKey<MyCustomFormState>!
  final _formKey = GlobalKey<FormState>();

  final myControllerStart = TextEditingController();
  final myControllerEnd = TextEditingController();
  final myControllerPhone = TextEditingController();
  final myControllerRemark = TextEditingController();

  @override
  void dispose() {
    myControllerStart.dispose();
    myControllerEnd.dispose();
    myControllerPhone.dispose();
    myControllerRemark.dispose();
    super.dispose();
  }

  DateTime _fromDate = DateTime.now();
  TimeOfDay _fromTime = TimeOfDay.fromDateTime(DateTime.now());

  void _upload() async {
    String dataURL = "http://39.96.16.125:8082/api/event/publish";
    final x = DateTime(
      _fromDate.year,
      _fromDate.month,
      _fromDate.day,
      _fromTime.hour,
      _fromTime.minute,
    );
    print(
        "DDAI= _fromDate=${_fromDate.toString()} ; _fromDate=${_fromDate.toString()}; x=${x.toString()}");
    print("<<<<==================${new DateFormat("y-M-D H:m ").format(x)}");
    print(
        "${x.millisecondsSinceEpoch}==================${new DateTime.now().millisecondsSinceEpoch}");
    final body = {
      'start': myControllerStart.text,
      'end': myControllerEnd.text,
      'time': x.millisecondsSinceEpoch.toString(),
      'phone': myControllerPhone.text,
      'remark': myControllerRemark.text,
      'type': findVehicle ? '1' : '0',
      'publish_time': '0',
      'publish_id': '0',
    };
    http.Response response = await http.post(dataURL, body: body);
    print("DDAI= code=${response.statusCode} ;end=${response.body}");

//    final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
//    final newData = parsed.map<Event>((json) => Event.fromJson(json)).toList();
//    data.clear();
//    data.addAll(newData);
//    setState(() {
//      data.clear();
//      data.addAll(newData);
//    });
  }

  _doPublish() {
    Timer(const Duration(seconds: 2), () {
      Navigator.pop(context, DialogDemoAction.cancel);
      Navigator.pop(context);
    });
    _upload();
    return showDialog<DialogDemoAction>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("发布中"),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  LinearProgressIndicator(),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey we created above
    return Form(
      key: _formKey,
      child: ListView(
        padding: EdgeInsets.all(16),
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(
              hintText: '请输入 出发点',
              icon: Icon(Icons.pin_drop),
              labelText: '出发：',
            ),
            controller: myControllerStart,
            // The validator receives the text the user has typed in
            validator: (value) {
              if (value.isEmpty) {
                return '不能为空...';
              }
            },
          ),
          TextFormField(
            decoration: InputDecoration(
              hintText: '请输入 到达点',
              icon: Icon(Icons.assistant_photo),
              labelText: '到达：',
            ),
            controller: myControllerEnd,
            // The validator receives the text the user has typed in
            validator: (value) {
              if (value.isEmpty) {
                return '不能为空...';
              }
            },
          ),
          TextFormField(
            decoration: InputDecoration(
              hintText: '请输入 联系电话',
              icon: Icon(Icons.mobile_screen_share),
              labelText: '联系电话：',
            ),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            controller: myControllerPhone,
            // The validator receives the text the user has typed in
            validator: (value) {
              if (value.isEmpty) {
                return '不能为空...';
              }
            },
          ),
          TextFormField(
            decoration: InputDecoration(
              hintText: '请输入 备注',
              icon: Icon(Icons.textsms),
              labelText: '备注：',
            ),
            controller: myControllerRemark,
          ),
          DateTimePicker(
            labelText: '出发时间',
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
          MaterialButton(
            color: Colors.blue,
            onPressed: () {
              // Validate will return true if the form is valid, or false if
              // the form is invalid.
              if (_formKey.currentState.validate()) {
                // If the form is valid, display a snackbar. In the real world, you'd
                // often want to call a server or save the information in a database
//                Scaffold.of(context)
//                    .showSnackBar(SnackBar(content: Text('Processing Data')));
                _doPublish();
              }
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            child: Text(
              '发布',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
