import 'dart:io';

import 'package:mongo_dart/mongo_dart.dart';

import 'package:multigamewebsocketsdart/handlers/requesthandler.dart';
import 'package:multigamewebsocketsdart/websockets/player.dart';
import 'package:multigamewebsocketsdart/websockets/event/event.dart';
import 'package:multigamewebsocketsdart/websockets/event/user.dart';



Future<void> main() async {
  var server = await HttpServer.bind(InternetAddress.anyIPv4, 3402);
  print("Listening on ws://${server.address.address}:${server.port}");
  Db db = Db("mongodb://localhost:27017");
  await db.open();
  await initEvents(db);

  await for (HttpRequest request in server) {
    var handler = await RequestHandler.init(req: request, db: db);
    if(handler == null) {
      print("cannot handle request");
    }
  }
}

Future<void> initEvents(Db db) async {
  var eventsdb = await db.collection("events").find().toList();
  var usersdb = await db.collection("users").find().toList();
  Events.events.addAll(eventsdb.map((e) => Event.fromMap(e)));
  Events.users.addAll(usersdb.map((e) => User.fromMap(e, null)));
}

abstract class Events {
  static List<Event> events = [];
  static List<User> users = [];
  static List<User> connectedUsers = [];
}

abstract class GamePlayers {
  static List<Player> playersTicTac = [];
  static List<Player> playersPoker = [];
}