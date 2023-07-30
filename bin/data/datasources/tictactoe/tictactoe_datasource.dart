
import 'package:mongo_dart/mongo_dart.dart';
import 'package:multigamewebsocketsdart/data/mongo_handler.dart';
import 'package:multigamewebsocketsdart/domain/entities/message.dart';
import 'package:multigamewebsocketsdart/domain/entities/tictactoe/tictactoe_player.dart';
import 'package:multigamewebsocketsdart/domain/entities/tictactoe/tictactoe_player_connected.dart';

abstract class TicTacToeDataSource {

  static const String _collectionName = "tictactoe";
  static late DbCollection _tictacCollection;

  static List<TicTacToePlayer> players = [];
  static List<TicTacToePlayerConnected> connectedPlayers = [];

  static Future<void> init() async {
    _tictacCollection = MongoHandler.getCollection(_collectionName);
    final map = await _tictacCollection.find().toList();
    players = map.map((json) => TicTacToePlayer.fromJson(json)).toList();
  }

  static void remove(TicTacToePlayerConnected player) {
    connectedPlayers.remove(player);
  }

  static void add(TicTacToePlayerConnected player) {
    connectedPlayers.add(player);
  }

  static TicTacToePlayerConnected find(String id) {
    return connectedPlayers.singleWhere((player) => player.id == id);
  }

  static void broadcastPlayers() {
    List<String> players = [];
    for (var i in connectedPlayers) {
      players.add(i.toJson());
    }

    Message mesg = Message(action: "list", data: players);

    for (var i in connectedPlayers){
      i.socket.add(mesg.toJson());
    }
  }
}
