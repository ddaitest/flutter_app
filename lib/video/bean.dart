class VideoInfo {
  VideoInfo({this.time, this.title, this.desc, this.type, this.remark});

  num time;
  String title = "";
  String desc = "";
  String remark = "";
  num type; //0:car 1:passenger

  factory VideoInfo.fromJson(Map<String, dynamic> json) {
    return VideoInfo(
      time: json['time'],
      title: json['title'],
      desc: json['desc'],
      remark: json['remark'],
      type: json['type'],
    );
  }
}