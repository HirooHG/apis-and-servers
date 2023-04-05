import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:multigamewebsocketsdart/main.dart';
import 'package:multigamewebsocketsdart/websockets/event/event.dart';
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

  User? currentUser;

  @override
  void onDone() {
    if(currentUser != null) {
      print("disconnected ${currentUser!.identifiant}");
      Events.users.remove(currentUser);
      removeUser(currentUser!.id);
    }
  }

  @override
  void onError(error) {
    if(currentUser != null) {
      print("There was an error with ${currentUser!.identifiant}");
      Events.users.remove(currentUser);
      removeUser(currentUser!.id);
    }
  }

  @override
  void internal(message) async {
    var msg = Message.fromMap(message);
    currentUser ??= User.empty(socket);

    switch(msg.action) {
      case 'test':
        print(await users.find().toList());
        print(await events.find().toList());
        print(Events.users);
        print(Events.events);
        break;
      case "connect":
        // connection with id and pwd
        var json = jsonDecode(msg.data);
        var identifiant = json["identifiant"];
        var pwd = json["pwd"];

        var user = await users.findOne(where.eq("identifiant", identifiant));
        if(user != null && pwd == user["pwd"]) {
          currentUser = User.fromMap(user, socket);
          Events.users.add(currentUser!);
          var message = Message(
            action: "connected",
            data: currentUser!.toJson()
          )();
          socket.add(message);
          addUser(currentUser!);
        } else {
          socket.add(Message(
            action: "refused",
            data: ""
          )());
        }
        break;
      case "inscription":
        // create an account
        currentUser = User.fromMessage(msg, socket);
        if(Events.users.where((element) => element.identifiant == currentUser!.identifiant).isNotEmpty) {
          socket.add(Message(action: "refused", data: "Identifier already exists"));
        } else {
          Events.users.add(currentUser!);
          await users.insertOne(currentUser!.toMap());
          socket.add(Message(action: "connected", data: currentUser!.toJson())());
          addUser(currentUser!);
        }
        break;
      case "deco":
        // disconnect
        Events.users.remove(currentUser);
        socket.add(Message(action: "disconnected", data: "")());
        removeUser(currentUser!.id);
        break;
      case "create":
        // create an event
        var event = Event.fromMessage(msg);
        Events.events.add(event);
        await events.insertOne(event.toMap());
        addEvent(event);
        break;
      case "delete":
        // create an event
        var id = msg.data;
        Events.events.removeWhere((element) => element.id == id);
        await events.remove({"id": id});
        removeEvent(id);
        break;
      case "modif":
        // modification of an event
        var eventToModif = Event.fromMessage(msg);
        var event = Events.events.singleWhere((element) => element.id == eventToModif.id);
        event.date = eventToModif.date;
        event.description = eventToModif.description;
        event.nom = eventToModif.nom;
        await events.replaceOne({ "id": event.id }, event.toMap());
        modifEvent(event);
        break;
      case "takepart":
        // An user want to take part in an event
        var id = msg.data;
        var event = Events.events.singleWhere((element) => element == id);
        event.users.add(currentUser!);
        addUserEvent(event.id, currentUser!.id);
        await events.replaceOne({ "id": event.id }, event.toMap());
        break;
    }
  }

  void addUserEvent(String eventId, String userId) {
    var data = jsonEncode({
      "action": "removeEvent",
      "data": jsonEncode({"eventId": eventId, "userId": userId})
    });

    for (var i in Events.users){
      i.socket.add(data);
    }
  }
  void modifEvent(Event event) {
    var data = jsonEncode({
      "action": "removeEvent",
      "data": event.toJson()
    });

    for (var i in Events.users){
      i.socket.add(data);
    }
  }
  void addEvent(Event event) {
    var data = jsonEncode({
      "action": "addEvent",
      "data": event.toJson()
    });

    for (var i in Events.users){
      i.socket.add(data);
    }
  }
  void addUser(User user) {

    var data = jsonEncode({
      "action": "addUser",
      "data": user.toJson()
    });

    for (var i in Events.users){
      i.socket.add(data);
    }
  }
  void removeUser(String id) {

    var data = jsonEncode({
      "action": "removeUser",
      "data": id
    });

    for (var i in Events.users){
      i.socket.add(data);
    }
  }
  void removeEvent(String id) {

    var data = jsonEncode({
      "action": "removeEvent",
      "data": id
    });

    for (var i in Events.users){
      i.socket.add(data);
    }
  }
}
