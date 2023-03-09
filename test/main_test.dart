import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';

void main() {
  test('connect', () async {
    var socket = await WebSocket.connect(
      "ws://localhost:3402/ws/tictactoe"
    );
    var socket2 = await WebSocket.connect(
        "ws://localhost:3402/ws/tictactoe"
    );

    socket.listen((event) {
      print("socket 1 received : $event");
      print("socket 1 type : ${jsonDecode(event)["data"].runtimeType}");
    });

    socket2.listen((event) {
      print("socket 2 received : $event");
      print("socket 2 type : ${jsonDecode(event)["data"].runtimeType}");
    });

    socket.add(jsonEncode({"action": "connect"}));
    socket2.add(jsonEncode({"action": "connect"}));
  });
}