import 'dart:io';

import 'package:test/test.dart';

void main() {
  test('connect', () async {
    var socket = await WebSocket.connect(
      "ws://localhost:3402/ws/tictactoe"
    );

    socket.add({"action": "yay", "data": "yay"});

    socket.listen((message) {
      print("message received $message");
    });
  });
}