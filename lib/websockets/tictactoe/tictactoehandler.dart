
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
  void internal(message) async {
      var json = jsonDecode(message);

      var action = json["action"];
      var id = json["id"];
      var msgData = json["data"];

      TicTacToePlayer? player = getById(id);

      player ??= TicTacToePlayer(
        socket: socket,
        id: req.session.id,
        name: msgData ?? "",
        points: 0
      );

      print(action);

    switch(action) {
      case "test":
        socket.add("test");
        break;
      case "connect":
        player.name = msgData ?? "";
        GamePlayers.playersTicTac.add(player);
        socket.add(jsonEncode({"action": "connected", "data": player.toJson()}));
        broadcastPlayers();
        break;
      case "close":
        GamePlayers.playersTicTac.remove(player);
        broadcastPlayers();
        await socket.close();
        break;
      case "newGame":
        var data = jsonEncode({
          "action": "newGame",
          "data": jsonEncode({
            "opponentId": player.id
          })
        });
        var opponent = getById(jsonDecode(msgData)["opponentId"]);
        player.opponent = opponent;
        opponent!.opponent = player;
        opponent.socket.add(data);
        break;
      case "win":
        var data = jsonEncode({
          "action": "lost",
        });
        player.opponent!.points--;
        player.points++;
        player.opponent!.socket.add(data);
        player.opponent = null;
        break;
      case "play":
        var data = jsonEncode({
          "action": "play",
          "data": jsonEncode({
            "grid": jsonDecode(msgData)["grid"],
            "character": jsonDecode(msgData)["character"]
          })
        });
        player.opponent!.socket.add(data);
        break;
      case "resign":
        var data = jsonEncode({
          "action": "resigned",
        });
        player.opponent!.points++;
        player.points--;
        player.opponent!.socket.add(data);
        player.opponent = null;
        break;
    }
  }

  TicTacToePlayer? getById(String? id) {
    try {
      if(id == null) throw Exception();
      return GamePlayers.playersTicTac.singleWhere((element) => element.id == id) as TicTacToePlayer;
    } catch (e) {
      return null;
    }
  }

  void broadcastPlayers() {
    var players = [];
    for (var i in GamePlayers.playersTicTac) {
      players.add(i.toJson());
    }

    var data = jsonEncode({
      "action": "list",
      "data": players
    });

    for (var i in GamePlayers.playersTicTac){
      i.socket.add(data);
    }
  }
}
