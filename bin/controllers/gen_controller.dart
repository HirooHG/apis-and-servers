import 'dart:io';

import 'package:multigamewebsocketsdart/controllers/tictactoe/tictactoe_controller.dart';
import 'package:multigamewebsocketsdart/domain/enums/api_type.dart';
import 'package:multigamewebsocketsdart/domain/enums/request_type.dart';
import 'package:multigamewebsocketsdart/domain/enums/websocket_type.dart';

class GenController {

  final HttpRequest request;

  const GenController({required this.request});

  void handleRequest() {
    final type = _getType();

    switch (type) {
      case RequestType.ws:
        _handleWs();
        break;
      case RequestType.api:
        _handleApi();
        break;
      default:
        request
          ..response.statusCode = HttpStatus.badRequest
          ..response.close();
        break;
    }
  }

  void _handleApi() async {
    final type = _getApiType();

    switch (type) {
      default:
        request
          ..response.statusCode = HttpStatus.badRequest
          ..response.close();
        break;
    }
  }

  void _handleWs() async {
    final type = _getWsType();

    switch (type) {
      case WebsocketType.tictactoe:
        final socket = await WebSocketTransformer.upgrade(request);
        TicTacToeController(req: request, socket: socket)
          .listenToChannel();
        break;
      default:
        request
          ..response.statusCode = HttpStatus.badRequest
          ..response.close();
        break;
    }
  }

  ApiType _getApiType() {
    try {
      final typeStr = request.uri.pathSegments[1];
      return ApiType.values.singleWhere((e) => e.name == typeStr);
    } catch (e) {
      return ApiType.nope;
    }
  }
  
  WebsocketType _getWsType() {
    try {
      final typeStr = request.uri.pathSegments[1];
      return WebsocketType.values.singleWhere((e) => e.name == typeStr);
    } catch (e) {
      return WebsocketType.nope;
    }
  }

  RequestType _getType() {
    try {
      final typeStr = request.uri.pathSegments[0];
      return RequestType.values.singleWhere((e) => e.name == typeStr);
    } catch (e) {
      return RequestType.nope;
    }
  }
}



