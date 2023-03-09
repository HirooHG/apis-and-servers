
import 'dart:convert';

import 'package:multigamewebsocketsdart/websockets/player.dart';

class TicTacToePlayer extends Player {
  TicTacToePlayer({
    required super.socket,
    required super.name,
    required super.id,
    required this.points,
    this.opponent
  });

  int points;
  TicTacToePlayer? opponent;

  @override
  String toJson() {
    final data = {
      "id": id,
      "name": name,
      "points": points
    };

    return jsonEncode(data);
  }

  @override
  String toString() {
    return "id: $id\n"
        "name: $name\n"
        "points: $points";
  }
}