
import 'package:multigamewebsocketsdart/domain/entities/abstract_player.dart';

class TicTacToePlayer extends Player {
  int points;

  TicTacToePlayer({
    required super.id,
    required super.name,
    required this.points,
  });

  TicTacToePlayer.fromJson(Map<String, dynamic> json)
    : points = 0,
      super(id: json["id"], name: json["name"]);

  @override
  Map<String, Object> toMap() {
    return {
      "id": id, 
      "name": name
    };
  }

  @override
  String toString() {
    return "id: $id\n"
        "name: $name\n"
        "points: $points";
  }
}
