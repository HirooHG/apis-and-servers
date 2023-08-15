
import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:api/controllers/ws/abstract_ws_controller.dart';
import 'package:api/data/ws/tictactoe_datasource.dart';
import 'package:api/domain/entities/ws/message.dart';
import 'package:api/domain/entities/ws/tictactoe/tictactoe_player_connected.dart';

class TicTacToeController extends AbstractWsController {
  TicTacToeController({
    required super.request,
    required super.socket,
    required super.authProvider,
    required this.dataSource
  });

  final TicTacToeDataSource dataSource;
  late final TicTacToePlayerConnected player;

  @override
  void onDone() {
    quit("disconnected");
  }

  @override
  void onError(error) {
    quit("there was an error with");
  }

  void quit(String msg) {
    try {
      print("$msg ${player.name}");
      dataSource.remove(player);
      dataSource.broadcastPlayers();
    } catch(e) {
      print("player not initialized");
    }
  }

  void init(Message msg) async {
    try {
      player.id;
    } catch(e) {

      player = TicTacToePlayerConnected(
        socket: socket,
        id: Uuid().v1(),
        name: msg.data ?? "",
        points: 0
      );
    }
  }
  
  bool testMsg(dynamic message) {
    try {
      jsonDecode(message);
      return true;
    } catch(e) {
      return false;
    }
  }

  @override
  void internal(message) async {
    if(!testMsg(message)) {
      socket.add(Message(action: "error", data: "Message not json decodable").toJson());
      return;
    }

    var msg = Message.fromJson(message);
    init(msg);

    switch(msg.action) {
      case "test":
        socket.add(Message(action: "test", data: "test").toJson());
        print(msg);
        break;
      case "connect":
        connect(msg);
        break;
      case "close":
        close();
        break;
      case "newGame":
        newGame(msg);
        break;
      case "win":
        win();
        break;
      case "play":
        play(message);
        break;
      case "resign":
        resign();
        break;
    }
  }

  TicTacToePlayerConnected getById(String id) {
    return dataSource.find(id);
  }
  
  void close() async {
    dataSource.remove(player);
    dataSource.broadcastPlayers();
    await socket.close();
  }

  void newGame(Message msg) {
    Message mesg = Message(action: "newGame", data: player.id);
    TicTacToePlayerConnected opponent = getById(msg.data);
    player.opponent = opponent;
    opponent.opponent = player;
    opponent.socket.add(mesg.toJson());
  }

  void play(dynamic mesg) {
    player.opponent!.socket.add(mesg);
  }

  void connect(Message msg) {
    player.name = msg.data ?? "";
    dataSource.add(player);
    Message mesg = Message(action: "connected", data: player.toJson());
    socket.add(mesg.toJson());
    dataSource.broadcastPlayers();
  }
  
  void win() {
    Message mesg = Message(action: "lost", data: "");
    player.opponent!.socket.add(mesg.toJson());
    player.opponent!.points--;
    player.points++;
    player.opponent!.opponent = null;
    player.opponent = null;
  }

  void resign() {
    Message mesg = Message(action: "resigned", data: "");
    player.opponent!.socket.add(mesg.toJson());
    player.opponent!.points++;
    player.points--;
    player.opponent!.opponent = null;
    player.opponent = null;
  }
}
