
import 'dart:convert';
import 'dart:io';

import '../handlers/handler.dart';
import 'player.dart';

abstract class WebSocketHandler extends Handler {

  WebSocketHandler({
    required this.socket,
    required this.req
  }) {
    socket.listen(internal);
  }

  final WebSocket socket;
  final HttpRequest req;

  void internal(message);
}
