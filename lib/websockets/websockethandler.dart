
import 'dart:convert';
import 'dart:io';

import 'package:multigamewebsocketsdart/main.dart';

import '../handlers/handler.dart';
import 'player.dart';

abstract class WebSocketHandler extends Handler {

  WebSocketHandler({
    required this.socket,
    required this.req
  }) {
    socket.listen(
      internal,
      onDone: onDone,
      onError: onError
    );
  }

  final WebSocket socket;
  final HttpRequest req;

  void onDone();
  void onError(error);
  void internal(message);
}
