
import 'dart:convert';
import 'dart:io';

import 'handler.dart';

class WebSocketHandler extends Handler {

  WebSocketHandler({
    required this.socket,
    required this.req
  }) {
    _initInternal();
  }

  final WebSocket socket;
  final HttpRequest req;

  void _initInternal() {
    socket.listen((message) {
      var msg = jsonDecode(message as String);


    });
  }

  static Future<WebSocketHandler> init({required HttpRequest req}) async {
    var socket = await WebSocketTransformer.upgrade(req);
    print('Client connected ! ${req.connectionInfo!.remoteAddress}');

    return WebSocketHandler(socket: socket, req: req);
  }
}
