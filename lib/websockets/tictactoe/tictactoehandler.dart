
import 'dart:convert';

import 'package:multigamewebsocketsdart/websockets/websockethandler.dart';
import 'tictactoeplayer.dart';

class TicTacToeHandler extends WebSocketHandler {

  TicTacToeHandler({
    required super.req,
    required super.socket
  });

  @override
  void internal() {
    socket.listen((message) {
      var json = jsonDecode(message);
      var action = json["action"];
      var data = json["data"];

      switch(action) {
        case "connect":
          var player = TicTacToePlayer(name: data, points: 0);
          break;
      }
    });
  }
}