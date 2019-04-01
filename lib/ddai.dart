import 'dart:convert';

main() {
//  var aa = Map();
//  var bb = {"aa": "xxxx"};
//  print(jsonEncode(bb));
  test1("start", (Map map) {
    print("work = $map");
  });
}

void test1(String start, Function(Map) callback) {
  print("test1");
  callback({"xxx": start});
  print("test2");
}

void work(Map map) {
  print("work = $map");
}
