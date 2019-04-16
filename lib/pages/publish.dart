import 'dart:async';

import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("发布"),
        ),
        body: MyCustomForm()
//        MyCustomForm(),
        );
  }
}

class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm> {
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
      'type': '0',
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
          _DateTimePicker(
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
          RaisedButton(
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
            child: Text('发布'),
          ),
        ],
      ),
    );
  }
}

class _DateTimePicker extends StatelessWidget {
  const _DateTimePicker(
      {Key key,
      this.labelText,
      this.selectedDate,
      this.selectedTime,
      this.selectDate,
      this.selectTime})
      : super(key: key);

  final String labelText;
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final ValueChanged<DateTime> selectDate;
  final ValueChanged<TimeOfDay> selectTime;

  Future<void> _selectDate(BuildContext context) async {
//    final DateTime picked = await showDatePicker(
//        context: context,
//        initialDate: selectedDate,
//        firstDate: DateTime(2015, 8),
//        lastDate: DateTime(2101));
//    if (picked != null && picked != selectedDate) selectDate(picked);
    DatePicker.showDatePicker(
      context,
      currentTime: selectedDate,
      locale: LocaleType.zh,
      onConfirm: (picked) {
        if (picked != null && picked != selectedDate) selectDate(picked);
      },
    );
  }

  Future<void> _selectTime(BuildContext context) async {
//    final TimeOfDay picked =
//        await showTimePicker(context: context, initialTime: selectedTime);
//    if (picked != null && picked != selectedTime) selectTime(picked);
    final now = new DateTime.now();
    final currentDate = DateTime(
        now.year, now.month, now.day, selectedTime.hour, selectedTime.minute);

    DatePicker.showTimePicker(
      context,
      currentTime: currentDate,
      locale: LocaleType.zh,
      onConfirm: (picked) {
        if (picked != null && picked != selectedDate)
          selectTime(TimeOfDay.fromDateTime(picked));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle valueStyle = Theme.of(context).textTheme.title;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(
          flex: 4,
          child: _InputDropdown(
            labelText: labelText,
            valueText: DateFormat("y年M月d日").format(selectedDate),
            valueStyle: valueStyle,
            onPressed: () {
              _selectDate(context);
            },
          ),
        ),
        const SizedBox(width: 12.0),
        Expanded(
          flex: 3,
          child: _InputDropdown(
            valueText: MaterialLocalizations.of(context)
                .formatTimeOfDay(selectedTime, alwaysUse24HourFormat: true),
            valueStyle: valueStyle,
            onPressed: () {
              _selectTime(context);
            },
          ),
        ),
      ],
    );
  }
}

class _InputDropdown extends StatelessWidget {
  const _InputDropdown(
      {Key key,
      this.child,
      this.labelText,
      this.valueText,
      this.valueStyle,
      this.onPressed})
      : super(key: key);

  final String labelText;
  final String valueText;
  final TextStyle valueStyle;
  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: labelText,
        ),
        baseStyle: valueStyle,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(valueText, style: valueStyle),
            Icon(Icons.arrow_drop_down,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.grey.shade700
                    : Colors.white70),
          ],
        ),
      ),
    );
  }
}
