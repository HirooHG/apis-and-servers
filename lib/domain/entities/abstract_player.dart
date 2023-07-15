
import 'dart:convert';

abstract class Player {

  final String id;
  String name;

  Player({
    required this.id,
    required this.name
  });

  Map<String, Object> toMap();

  String toJson() => jsonEncode(toMap());
}
