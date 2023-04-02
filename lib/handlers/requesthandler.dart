
import 'dart:io';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:multigamewebsocketsdart/api/ApiHandler.dart';
import 'package:multigamewebsocketsdart/websockets/poker/pokerhandler.dart';
import 'package:multigamewebsocketsdart/websockets/tictactoe/tictactoehandler.dart';
import 'package:multigamewebsocketsdart/websockets/event/eventshandler.dart';
import 'handler.dart';

class RequestHandler {
  const RequestHandler({
    required this.req,
    this.handler,
    required this.db
  });

  final HttpRequest req;
  final Handler? handler;
  final Db db;

  static RequestHandler? handlingWebsocket({required HttpRequest req, required WebSocket socket, required Db db}) {
    if(req.uri.pathSegments.length < 2) {
      req.response.statusCode = HttpStatus.badRequest;
      req.response.close();
      return null;
    }

    switch(req.uri.pathSegments[1]) {
      case 'poker':
        var pokerHandler = PokerHandler(req: req, socket: socket, db: db);
        return RequestHandler(req: req, handler: pokerHandler, db: db);

      case 'tictactoe':
        var tictactoeHandler = TicTacToeHandler(req: req, socket: socket, db: db);
        return RequestHandler(req: req, handler: tictactoeHandler, db: db);

      case 'events':
        var eventsHandler = EventsHandler(req: req, socket: socket, db: db);
        return RequestHandler(req: req, handler: eventsHandler, db: db);

      default:
        req.response.statusCode = HttpStatus.badRequest;
        req.response.close();
        return null;
    }
  }

  static Future<RequestHandler?> init({required HttpRequest req, required Db db}) async {
    if(req.uri.pathSegments.isEmpty) {
      req.response.statusCode = HttpStatus.forbidden;
      req.response.close();
      return null;
    }

    switch(req.uri.pathSegments[0]) {
      case 'ws':
        var socket = await WebSocketTransformer.upgrade(req);
        return handlingWebsocket(req: req, socket: socket, db: db);
      case 'api':
        var apiHandler = ApiHandler(req: req);
        return RequestHandler(req: req, handler: apiHandler, db: db);
      default:
        req.response.statusCode = HttpStatus.badRequest;
        req.response.close();
        return null;
    }
  }
}