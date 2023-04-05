
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
  WebSocket socket;
  Event? event;

  User({
    required this.id,
    required this.event,
    required this.socket,
    required this.identifiant,
    required this.password
  });

  // factory
  factory User.fromId(String id) {
    return Events.users.singleWhere((element) => element.id == id);
  }
  factory User.fromMessage(Message msg, WebSocket sock) {
    return User.fromJson(msg.data, sock);
  }
  factory User.fromJson(dynamic map, WebSocket sock) {
    return User.fromMap(jsonDecode(map), sock);
  }

  // named
  User.empty(WebSocket sock) :
    id = Uuid().v4(),
    password = "",
    identifiant = "",
    socket = sock,
    event = null;
  User.fromMap(Map<String, dynamic> map, WebSocket sock) :
    id = map["id"],
    socket = sock,
    identifiant = map["identifiant"],
    password = map["pwd"],
    event = (map["eventId"] == null) ? null : Event.fromId(map["eventId"]);

  // methods
  String toJson(){
    return jsonEncode(toMap());
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "identifiant": identifiant,
      "pwd": password,
      "eventId": event?.id
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
      "pwd: $password"
      "event: ${event ?? "inscrit à aucun event"}";
  }
}