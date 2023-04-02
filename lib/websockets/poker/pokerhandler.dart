
import 'dart:io';

import 'package:multigamewebsocketsdart/websockets/websockethandler.dart';

class PokerHandler extends WebSocketHandler {
  PokerHandler({required super.db, required super.req, required super.socket});

  @override
  void onDone() {
    // TODO: implement onDone
  }

  @override
  void onError(error) {
    // TODO: implement onError
  }

  @override
  void internal(message) {

  }
}
