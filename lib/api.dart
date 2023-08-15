
import 'package:api/data/ws/tictactoe_datasource.dart';
import 'package:api/data/mongo_handler.dart';
import 'package:api/server/server.dart';

Future<void> server() async {
  await MongoHandler().init();
  await TicTacToeDataSource().init();

  final server = Server();
  await server.init();
  await server.serve();
}
