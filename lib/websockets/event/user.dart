
import 'dart:convert';
import 'dart:io';
import 'package:uuid/uuid.dart';

import 'package:multigamewebsocketsdart/main.dart';
import 'package:multigamewebsocketsdart/websockets/event/message.dart';
import 'package:multigamewebsocketsdart/websockets/event/event.dart';

class User {

  String id;
  String identifiant;
  String password;
  WebSocket? socket;
  String? eventId;

  Event? get event {
    return (eventId == null)
        ? null
        : Events.events.singleWhere((element) => element.id == eventId);
  }

  User({
    required this.id,
    required this.eventId,
    required this.identifiant,
    required this.password,
    this.socket,
  });

  // factory
  factory User.fromId(String id, WebSocket socket) {
    var user = Events.users.singleWhere((element) => element.id == id);
    user.socket = socket;
    return user;
  }
  factory User.fromMessage(Message msg, WebSocket? sock) {
    return User.fromJson(msg.data, sock);
  }
  factory User.fromJson(dynamic map, WebSocket? sock) {
    return User.fromMap(jsonDecode(map), sock);
  }

  // named
  User.empty(WebSocket? sock) :
    id = Uuid().v4(),
    password = "",
    identifiant = "",
    socket = sock,
    eventId = null;
  User.fromMap(Map<String, dynamic> map, WebSocket? sock) :
    id = map["id"],
    socket = sock,
    identifiant = map["identifiant"],
    password = map["pwd"],
    eventId = map["eventId"];

  // methods
  String toJson(){
    return jsonEncode(toMap());
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "identifiant": identifiant,
      "pwd": password,
      "eventId": eventId
    };
  }

  //override
  @override
  bool operator ==(Object other) {
    return other is User
        && id == other.id;
  }
  @override
  String toString() {
    return
      "id: $id\n"
      "identifiant: $identifiant\n"
      "pwd: $password\n"
      "event: ${eventId ?? "inscrit à aucun event"}";
  }
}