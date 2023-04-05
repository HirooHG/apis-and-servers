
import 'dart:convert';

import 'package:multigamewebsocketsdart/websockets/event/user.dart';
import 'package:multigamewebsocketsdart/main.dart';
import 'message.dart';

class Event {

  String id;
  String nom;
  String description;
  DateTime date;
  List<User> users;

  Event({
    required this.id,
    required this.nom,
    required this.description,
    required this.date,
    required this.users
  });

  factory Event.fromMessage(Message msg) {
    return Event.fromJson(msg.data);
  }
  factory Event.fromId(String id) {
    return Events.events.singleWhere((element) => element.id == id);
  }
  factory Event.fromJson(dynamic map) {
    return Event.fromMap(jsonDecode(map));
  }

  Event.fromMap(dynamic map) :
    id = map["id"],
    nom = map["nom"],
    description = map["id"],
    date = DateTime.parse(map["date"]),
    users = (map["users"] as List).map((e) => User.fromId(e)).toList();

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "nom": nom,
      "description": description,
      "data": date.toString(),
      "users": users.map((e) => e.id).toList()
    };
  }

  String toJson() {
    return jsonEncode(toMap());
  }
}