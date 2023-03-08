
import 'dart:io';

import 'package:multigamewebsocketsdart/api/ApiHandler.dart';
import 'package:multigamewebsocketsdart/websockets/poker/pokerhandler.dart';
import 'package:multigamewebsocketsdart/websockets/tictactoe/tictactoehandler.dart';
import 'handler.dart';

class RequestHandler {

  const RequestHandler({
    required this.req,
    this.handler
  });

  final HttpRequest req;
  final Handler? handler;

  static RequestHandler? handlingWebsocket({required HttpRequest req, required WebSocket socket}) {
    if(req.uri.pathSegments.length < 2) {
      req.response.statusCode = HttpStatus.badRequest;
      req.response.close();
      return null;
    }

    switch(req.uri.pathSegments[1]) {
      case 'poker':
        var pokerHandler = PokerHandler(req: req, socket: socket);
        return RequestHandler(req: req, handler: pokerHandler);

      case 'tictactoe':
        var tictactoeHandler = TicTacToeHandler(req: req, socket: socket);
        return RequestHandler(req: req, handler: tictactoeHandler);

      default:
        req.response.statusCode = HttpStatus.badRequest;
        req.response.close();
        return null;
    }
  }

  static Future<RequestHandler?> init({required HttpRequest req}) async {
    if(req.uri.pathSegments.isEmpty) {
      req.response.statusCode = HttpStatus.forbidden;
      req.response.close();
      return null;
    }

    switch(req.uri.pathSegments[0]) {
      case 'ws':
        var socket = await WebSocketTransformer.upgrade(req);
        return handlingWebsocket(req: req, socket: socket);
      case 'api':
        var apiHandler = ApiHandler(req: req);
        return RequestHandler(req: req, handler: apiHandler);
      default:
        req.response.statusCode = HttpStatus.badRequest;
        req.response.close();
        return null;
    }
  }
}