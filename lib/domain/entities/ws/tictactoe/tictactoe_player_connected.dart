
import 'dart:io';

import 'package:api/domain/entities/ws/tictactoe/tictactoe_player.dart';

class TicTacToePlayerConnected extends TicTacToePlayer {

  TicTacToePlayerConnected({
    required super.id,
    required super.name,
    required super.points,
    required this.socket,
    this.opponent
  });

  final WebSocket socket;
  TicTacToePlayerConnected? opponent;

  TicTacToePlayer toToePlayer() => TicTacToePlayer(
    id: id,
    name: name,
    points: points
  );
}
