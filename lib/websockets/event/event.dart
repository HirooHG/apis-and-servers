
import 'dart:convert';

import 'package:multigamewebsocketsdart/websockets/event/user.dart';
import 'package:multigamewebsocketsdart/main.dart';
import 'message.dart';

class Event {

  String id;
  String nom;
  String description;
  DateTime date;
  List<String> usersIds;

  List<User> get users {
    return usersIds.map(
      (e) => Events.users.singleWhere(
        (element) => element.id == e
      )
    ).toList();
  }

  Event({
    required this.id,
    required this.nom,
    required this.description,
    required this.date,
    required this.usersIds
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
    description = map["description"],
    date = DateTime.parse(map["date"]),
    usersIds = (map["users"] as List).map((e) => "$e").toList();

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "nom": nom,
      "description": description,
      "date": date.toString(),
      "users": usersIds
    };
  }

  String toJson() {
    return jsonEncode(toMap());
  }

  @override
  String toString() {
    return "nom: $nom\n"
        "description: $description\n"
        "date: $date\n"
        "users: $users";
  }
}