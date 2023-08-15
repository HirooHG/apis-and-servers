
import 'package:mongo_dart/mongo_dart.dart';
import 'package:api/data/mongo_handler.dart';
import 'package:api/domain/entities/ws/message.dart';
import 'package:api/domain/entities/ws/tictactoe/tictactoe_player.dart';
import 'package:api/domain/entities/ws/tictactoe/tictactoe_player_connected.dart';

class TicTacToeDataSource {

  // gen
  final String _collectionName = "tictactoe";

  late final DbCollection _tictacCollection;
  late final MongoHandler _mongoHandler;

  static final TicTacToeDataSource _singleton = TicTacToeDataSource._internal();

  factory TicTacToeDataSource() {
    return _singleton;
  }

  TicTacToeDataSource._internal();

  // players
  List<TicTacToePlayer> players = [];
  List<TicTacToePlayerConnected> connectedPlayers = [];

  Future<void> init() async {
    _mongoHandler = MongoHandler();
    _tictacCollection = _mongoHandler.getCollection(_collectionName);
    final map = await _tictacCollection.find().toList();
    players = map.map((json) => TicTacToePlayer.fromJson(json)).toList();
  }

  Future<void> addToDb(TicTacToePlayerConnected player) async {
    await _tictacCollection.insertOne(player.toToePlayer().toMap()); // -> void
  }

  Future<void> removeFromDb(TicTacToePlayerConnected player) async {
    await _tictacCollection.remove(player.toToePlayer().toMap()); // -> Map<String, dynamic>
  }

  Future<void> updateFromDb(TicTacToePlayerConnected player) async {
    await _tictacCollection.updateOne(where.eq("id", player.id), player.toToePlayer().toMap()); // -> writeResult
  }

  void remove(TicTacToePlayerConnected player) {
    connectedPlayers.remove(player);
  }

  void add(TicTacToePlayerConnected player) {
    connectedPlayers.add(player);
  }

  TicTacToePlayerConnected find(String id) {
    return connectedPlayers.singleWhere((player) => player.id == id);
  }

  void broadcastPlayers() {
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
