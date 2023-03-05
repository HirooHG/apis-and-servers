import 'dart:io';

import 'package:test/test.dart';

void main() {
  test('connect', () async {
    var socket = await WebSocket.connect(
      "ws://hugogolliet.fr:34001/ws"
    );

    socket.add("heya boi");

    socket.listen((message) {
      print("message received $message");
    });
  });
}