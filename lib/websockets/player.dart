
import 'dart:io';

abstract class Player {
  String id;
  String name;
  WebSocket socket;

  Player({
    required this.socket,
    required this.name,
    required this.id
  });

  String toJson();
}