
import 'dart:convert';
import 'dart:io';

import 'package:multigamewebsocketsdart/websockets/event/message.dart';

class User {

  String? id;
  String identifiant;
  String password;
  WebSocket socket;

  User({this.id, required this.socket, required this.identifiant, required this.password});

  User.fromMessage(Message msg, WebSocket sock) :
      socket = sock,
      id = jsonDecode(msg.data)["id"],
      identifiant = jsonDecode(msg.data)["identifiant"],
      password = jsonDecode(msg.data)["pwd"];

  User.fromJson(dynamic map, WebSocket sock) :
      socket = sock,
      id = jsonDecode(map)["id"],
      identifiant = jsonDecode(map)["identifiant"],
      password = jsonDecode(map)["pwd"];

  @override
  bool operator ==(Object other) {
    return other is User
        && id == other.id;
  }

  String toJson(){
    return jsonEncode({
      "id": id,
      "identifiant": identifiant,
      "pwd": password
    });
  }

  @override
  String toString() {
    return "id: $id\n"
      "identifiant: $identifiant\n"
      "pwd: $password";
  }
}