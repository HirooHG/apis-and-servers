
import 'dart:convert';

import 'package:multigamewebsocketsdart/websockets/websockethandler.dart';
import 'tictactoeplayer.dart';
import "../../main.dart";

class TicTacToeHandler extends WebSocketHandler {

  TicTacToeHandler({
    required super.req,
    required super.socket
  });

  @override
  void internal() {
    socket.listen((message) async {
      var json = jsonDecode(message);
      var action = json["action"];
      var data = json["data"];

      switch(action) {
        case "connect":
          var player = TicTacToePlayer(
            id: req.session.id,
            name: data,
            points: 0
          );
          GamePlayers.playersTicTac.add(player);
          socket.add(jsonEncode({"action": "connect", "data": player.toJson()}));
          print(GamePlayers.playersTicTac);
          break;
        case "close":
          var id = data;
          GamePlayers.playersTicTac.remove(getById(id));
          broadcastRemovedPlayer();
          await socket.close();
          break;
        case "newGame":
          break;
        case "win":
          break;
        case "play":
          break;
        case "resign":
          break;
      }
    });
  }

  TicTacToePlayer getById(String id)
    => GamePlayers.playersTicTac.singleWhere((element) => element.id == id) as TicTacToePlayer;

  void broadcastRemovedPlayer() {
    // TODO
  }
  void broadcastAddedPlayer() {
    // TODO
  }
}