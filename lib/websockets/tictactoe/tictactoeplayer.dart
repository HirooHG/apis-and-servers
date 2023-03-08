
import 'package:multigamewebsocketsdart/websockets/player.dart';

class TicTacToePlayer extends Player {
  TicTacToePlayer({required super.name, required this.points});

  final int points;
}