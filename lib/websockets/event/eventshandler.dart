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
      Events.connectedUsers.remove(currentUser);
      removeUser(currentUser!.id);
    }
  }

  @override
  void onError(error) {
    if(currentUser != null) {
      print("There was an error with ${currentUser!.identifiant}");
      Events.connectedUsers.remove(currentUser);
      removeUser(currentUser!.id);
    }
  }


  @override
  void internal(message) async {
    var msg = Message.fromMap(message);
    currentUser ??= User.empty(socket);


    switch(msg.action) {
      case 'test':
        print("bdd users list");
        print(await users.find().toList());
        print("bdd events list");
        print(await events.find().toList());
        print("users list");
        print(Events.users);
        print("connected users list");
        print(Events.connectedUsers);
        print("events list");
        print(Events.events);
        break;
      case "init":
        var message = Message(
          action: "lists",
          data: jsonEncode({
            "events": [...Events.events.map((e) => e.toJson())],
            "users": [...Events.connectedUsers.map((e) => e.toJson())]
          })
        );
        socket.add(message());
        break;
      case "connect":
        // connection with id and pwd
        var json = jsonDecode(msg.data);
        var identifiant = json["identifiant"];
        var pwd = json["pwd"];

        try {
          currentUser = Events.users.singleWhere((element) => element.identifiant == identifiant);

          if(pwd == currentUser!.password) {
            currentUser!.socket = socket;
            Events.connectedUsers.add(currentUser!);
            var message = Message(
              action: "connected",
              data: currentUser!.toJson()
            )();
            socket.add(message);
            addUser(currentUser!);
          } else {
            throw Exception();
          }
        } catch(e) {
          socket.add(Message(
            action: "refused",
            data: ""
          )());
        }
        break;
      case "inscription":
        // create an account
        currentUser = User.fromMessage(msg, socket);
        try {
          Events.users.singleWhere((element) => element.identifiant == currentUser!.identifiant);
          socket.add(Message(action: "refused", data: "Identifier already exists")());
        } catch(e) {
          Events.connectedUsers.add(currentUser!);
          Events.users.add(currentUser!);
          await users.insertOne(currentUser!.toMap());
          socket.add(Message(action: "connected", data: currentUser!.toJson())());
          addUser(currentUser!);
        }
        break;
      case "deco":
        // disconnect
        Events.connectedUsers.remove(currentUser);
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
        // delete an event
        var id = msg.data;
        Events.events.removeWhere((element) => element.id == id);
        await events.remove({"id": id});
        removeEvent(id);
        break;
      case "modifEvent":
        // modification of an event
        var eventToModif = Event.fromMessage(msg);
        var event = Events.events.singleWhere((element) => element.id == eventToModif.id);

        event.date = eventToModif.date;
        event.description = eventToModif.description;
        event.nom = eventToModif.nom;

        await events.replaceOne({ "id": event.id }, event.toMap());
        modifEvent(event);
        break;
      case "modifUser":
        // modification of an event
        var userToModif = User.fromMessage(msg, socket);
        var user = Events.connectedUsers.singleWhere((element) => element.id == userToModif.id);

        user.identifiant = userToModif.identifiant;
        user.password = userToModif.password;
        user.eventId = userToModif.eventId;

        await users.replaceOne({ "id": user.id }, user.toMap());
        modifUser(user);
        break;
      case "retire":
      // An user want to retire in an event
        var id = msg.data;
        var event = Events.events.singleWhere((element) => element.id == id);

        currentUser!.eventId = null;
        event.usersIds.removeWhere((element) => element == currentUser!.id);

        await events.replaceOne({ "id": event.id }, event.toMap());
        await users.replaceOne({ "id": currentUser!.id }, currentUser!.toMap());
        removeUserEvent(event.id, currentUser!.id);
        break;
      case "takepart":
        // An user want to take part in an event
        var id = msg.data;
        var event = Events.events.singleWhere((element) => element.id == id);

        currentUser!.eventId = event.id;
        event.usersIds.add(currentUser!.id);

        await events.replaceOne({ "id": event.id }, event.toMap());
        await users.replaceOne({ "id": currentUser!.id }, currentUser!.toMap());
        addUserEvent(event.id, currentUser!.id);
        break;
    }
  }

  void removeUserEvent(String eventId, String userId) {
    var data = jsonEncode({
      "action": "removeUserToEvent",
      "data": jsonEncode({"eventId": eventId, "userId": userId})
    });

    for (var i in Events.connectedUsers){
      i.socket!.add(data);
    }
  }
  void addUserEvent(String eventId, String userId) {
    var data = jsonEncode({
      "action": "addUserToEvent",
      "data": jsonEncode({"eventId": eventId, "userId": userId})
    });

    for (var i in Events.connectedUsers){
      i.socket!.add(data);
    }
  }
  void modifUser(User user) {
    var data = jsonEncode({
      "action": "modifEvent",
      "data": user.toJson()
    });

    for (var i in Events.connectedUsers){
      i.socket!.add(data);
    }
  }
  void modifEvent(Event event) {
    var data = jsonEncode({
      "action": "modifEvent",
      "data": event.toJson()
    });

    for (var i in Events.connectedUsers){
      i.socket!.add(data);
    }
  }
  void addEvent(Event event) {
    var data = jsonEncode({
      "action": "addEvent",
      "data": event.toJson()
    });

    for (var i in Events.connectedUsers){
      i.socket!.add(data);
    }
  }
  void addUser(User user) {

    var data = jsonEncode({
      "action": "addUser",
      "data": user.toJson()
    });

    for (var i in Events.connectedUsers){
      i.socket!.add(data);
    }
  }
  void removeUser(String id) {

    var data = jsonEncode({
      "action": "removeUser",
      "data": id
    });

    for (var i in Events.connectedUsers){
      i.socket!.add(data);
    }
  }
  void removeEvent(String id) {

    var data = jsonEncode({
      "action": "removeEvent",
      "data": id
    });

    for (var i in Events.connectedUsers){
      i.socket!.add(data);
    }
  }
}
