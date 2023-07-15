
import 'dart:io';

import 'package:multigamewebsocketsdart/domain/entities/tictactoe/tictactoe_player.dart';

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
}
