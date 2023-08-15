import 'dart:io';

import 'package:api/controllers/abstract_controller.dart';
import 'package:api/controllers/api/japanimation/japanimation_controller.dart';
import 'package:api/controllers/ws/tictactoe/tictactoe_controller.dart';
import 'package:api/data/api/datasources/japanimation_datasource.dart';
import 'package:api/data/api/repositories/japanimation_repository.dart';
import 'package:api/data/ws/tictactoe_datasource.dart';
import 'package:api/domain/enums/api_type.dart';
import 'package:api/domain/enums/request_type.dart';
import 'package:api/domain/enums/websocket_type.dart';
import 'package:api/domain/extension/list_ext.dart';
import 'package:api/server/middleware/constants.dart';
import 'package:api/server/middleware/entities/response.dart';

class GenController extends AbstractController {

  const GenController({
    required super.request,
    required super.authProvider
  });

  void handleRequest() async {
    if(request.uri.toString() == loginPath) {
      await handleLogin();
      return;
    }

    if(!(await verifyAudience(Audience.service))) {
      return;
    }

    final type = _getType();

    switch (type) {
      case RequestType.ws:
        _handleWs();
        break;
      case RequestType.api:
        _handleApi();
        break;
      default:
        notFound();
        break;
    }
  }

  Future<void> handleLogin() async {
    final Response response = await authProvider.auth(request);
    if(response.isOk()) {
      success(response.token!);
    } else {
      forbidden();
    }
  }

  void _handleApi() async {
    if(!(await verifyAudience(Audience.api))) {
      return;
    }

    final type = _getApiType();

    switch (type) {
      case ApiType.japanimation:
        if(!(await verifyAudience(Audience.japanimation))) {
          break;
        }
        JapanimationController(
          request: request,
          authProvider: authProvider,
          repository: JapanimationRepository(
            dataSource: JapanimationDatasource()
          )
        ).handlerRequest();
        break;
      default:
        notFound();
        break;
    }
  }

  void _handleWs() async {
    if(!(await verifyAudience(Audience.ws))) {
      return;
    }
    final type = _getWsType();

    switch (type) {
      case WebsocketType.tictactoe:
        if(!(await verifyAudience(Audience.japanimation))) {
          break;
        }

        final socket = await testWs(request);
        if(socket != null) {
          TicTacToeController(
            request: request,
            authProvider: authProvider,
            socket: socket,
            dataSource: TicTacToeDataSource()
          ).listenToChannel();
        }
        break;
      default:
        notFound();
        break;
    }
  }

  Future<bool> verifyAudience(Audience audience) async {
    final response = await authProvider.verify(request, Audience.ws);
    if(!response.isOk()) {
      forbidden();
    }
    return response.isOk();
  }

  Future<WebSocket?> testWs(HttpRequest req) async {
    try {
      return await WebSocketTransformer.upgrade(req);
    } catch(e) {
      return null;
    }
  }

  ApiType? _getApiType() {
    final segment = getSegment(1);
    if(segment == null) {
      return null;
    }
    return ApiType.values.nullWhere((e) => e.name == segment);
  }
  
  WebsocketType? _getWsType() {
    final segment = getSegment(1);
    if(segment == null) {
      return null;
    }
    return WebsocketType.values.nullWhere((e) => e.name == segment);
  }

  RequestType? _getType() {
    final segment = getSegment(0);
    if(segment == null) {
      return null;
    }
    return RequestType.values.nullWhere((e) => e.name == segment);
  }
}
