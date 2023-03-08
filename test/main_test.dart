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

    socket2.listen((message) {
      print("message received ${jsonDecode(message)}");
    });

    socket.listen((message) {
      print("message received ${jsonDecode(message)}");
      var id = jsonDecode(jsonDecode(message)["data"])["id"];
      var close = {
        "action": "close",
        "data": id
      };
      final closeMsg = jsonEncode(close);
      socket.add(closeMsg);
      print("closed");
    });

    const data = {
      "action": "connect",
      "data": ""
    };
    final msg = jsonEncode(data);

    socket.add(msg);
    socket2.add(msg);
  });
}