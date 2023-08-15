
import 'dart:convert';

class Message {

  final String action;
  final dynamic data;

  Message({
    required this.action,
    required this.data
  });

  Message.fromJson(dynamic map)
    : action = jsonDecode(map)["action"],
      data = jsonDecode(map)["data"];

  Map<String, dynamic> _toMap() {
    return {
      "action": action,
      "data": data
    };
  }

  String toJson() {
    return jsonEncode(_toMap());
  }

  @override
  String toString() {
    return "action : $action\n"
        "data: $data";
  }
}
