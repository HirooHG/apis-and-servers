import 'package:multigamewebsocketsdart/data/datasources/tictactoe/tictactoe_datasource.dart';
import 'package:multigamewebsocketsdart/data/mongo_handler.dart';
import 'package:multigamewebsocketsdart/server/server.dart';

Future<void> main() async {
  final server = Server();

  await server.init();
  await server.serve();
  await MongoHandler.init();
  await TicTacToeDataSource.init();
}
