import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:multigamewebsocketsdart/main.dart';
import 'package:multigamewebsocketsdart/websockets/event/message.dart';
import 'package:multigamewebsocketsdart/websockets/websockethandler.dart';
import 'user.dart';

class EventsHandler extends WebSocketHandler {
  EventsHandler({
    required super.db,
    required super.req,
    required super.socket
  }) {
    users = db.collection("users");
    events = db.collection("events");
  }

  late final DbCollection users;
  late final DbCollection events;

  User? user;

  @override
  void onDone() {
    if(user != null) {
      print("disconnected ${user!.identifiant}");
      Events.users.remove(user);
      broadcastUsers();
    }
  }

  @override
  void onError(error) {
    if(user != null) {
      print("There was an error with ${user!.identifiant}");
      Events.users.remove(user);
      broadcastUsers();
    }
  }

  @override
  void internal(message) {
    var msg = Message.fromMap(message);

    user ??= User(
      socket: socket,
      identifiant: "",
      password: "",
    );

    switch(msg.action) {
      case "connect":
        // connection with id and pwd
        var json = jsonDecode(msg.data);
        var identifiant = json["identifiant"];
        var pwd = json["pwd"];

        users.findOne(where.eq("identifiant", identifiant)).then((value) {
          if(value != null && pwd == value["pwd"]) {
            user = User(id: req.session.id, socket: socket, identifiant: identifiant, password: pwd);
            Events.users.add(user!);
            var message = Message(action: "connected", data: user!.toJson())();

            socket.add(message);
          } else {
            socket.add(Message(action: "refused", data: "")());
          }
        });
        break;
      case "inscription":
        // create an account
        break;
      case "deco":
        // deconnect
        break;
      case "create":
        // create an event
        break;
      case "modif":
        // modification on an event
        break;
      case "takepart":
        // An user want to take part in an event
        break;
    }
  }

  void broadcastEvents() {
    var events = [];
    for (var i in Events.events) {
      events.add(i.toJson());
    }

    var data = jsonEncode({
      "action": "list",
      "data": events
    });

    for (var i in Events.users){
      i.socket.add(data);
    }
  }

  void broadcastUsers() {
    var users = [];
    for (var i in Events.users) {
      users.add(i.toJson());
    }

    var data = jsonEncode({
      "action": "list",
      "data": users
    });

    for (var i in Events.users){
      i.socket.add(data);
    }
  }
}
