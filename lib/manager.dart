class Event {
  Event({this.time, this.start, this.end, this.phone, this.remark});

  num time;
  String start = "";
  String end = "";
  String phone = "";
  String remark = "";
  num type; //0:car 1:passenger
  num publishTime;
  String publisherId;

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      time: json['time'],
      start: json['start'],
      end: json['end'],
      phone: json['phone'],
      remark: json['remark'],
    );
  }
}


