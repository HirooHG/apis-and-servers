
import 'package:mongo_dart/mongo_dart.dart';
import 'package:multigamewebsocketsdart/controllers/abstract_ws_controller.dart';
import 'package:multigamewebsocketsdart/data/datasources/tictactoe/tictactoe_datasource.dart';
import 'package:multigamewebsocketsdart/domain/entities/message.dart';
import 'package:multigamewebsocketsdart/domain/entities/tictactoe/tictactoe_player_connected.dart';

class TicTacToeController extends AbstractWsController {
  TicTacToeController({
    required super.req,
    required super.socket,
  });

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
      TicTacToeDataSource.remove(player);
      TicTacToeDataSource.broadcastPlayers();
    } catch(e) {
      print("player not initialized");
    }
  }

  void init(Message msg) {
    try {
      print(player.id);
    } catch(e) {

      player = TicTacToePlayerConnected(
        socket: socket,
        id: Uuid().v1(),
        name: msg.data ?? "",
        points: 0
      );
    }
  }

  @override
  void internal(message) async {
    var msg = Message.fromJson(message);

    init(msg);

    switch(msg.action) {
      case "test":
        socket.add("test");
        print(player.id);
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
    return TicTacToeDataSource.find(id);
  }
  
  void close() async {
    TicTacToeDataSource.remove(player);
    TicTacToeDataSource.broadcastPlayers();
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
    TicTacToeDataSource.add(player);
    Message mesg = Message(action: "connected", data: player.toJson());
    socket.add(mesg.toJson());
    TicTacToeDataSource.broadcastPlayers();
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
